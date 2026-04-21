// ============================================================
// DART CLASSES — Part 3: Real Flutter App Patterns
// These are the EXACT patterns used in production Flutter apps.
// Run: dart run classes_flutter_patterns.dart
// ============================================================

// ----- PATTERN 1: DATA MODEL -----
// In every Flutter app, data from APIs must be converted to Dart objects.
// This class represents a product in an e-commerce app.

class Product {
  final String id;          // Unique identifier. 'final' because IDs never change.
  final String name;
  final double price;
  final String imageUrl;
  final String category;
  int quantity;              // NOT final — changes when user adds/removes from cart.

  // Constructor with named parameters.
  // 'required' = must be provided. No default value allowed for required params.
  Product({
    required this.id,
    required this.name,
    required this.price,
    required this.imageUrl,
    required this.category,
    this.quantity = 0,       // Optional, defaults to 0.
  });

  // Factory constructor — creates Product from JSON (API response).
  // 'Map<String, dynamic>' is how Dart represents JSON: keys are strings, values can be anything.
  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'] as String,
      name: json['name'] as String,
      price: (json['price'] as num).toDouble(),
      // WHY (as num).toDouble()? APIs sometimes send 999 (int) instead of 999.0 (double).
      // 'num' handles both int and double. Then toDouble() converts to consistent type.
      imageUrl: json['image_url'] as String,
      category: json['category'] as String,
      quantity: json['quantity'] as int? ?? 0,
      // 'as int?' — cast to nullable int (might be null in JSON).
      // '?? 0' — if null, use 0. This is the null-coalescing operator.
    );
  }

  // Converts object back to JSON — needed for sending data TO an API.
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'price': price,
      'image_url': imageUrl,
      'category': category,
      'quantity': quantity,
    };
  }

  // Creates a copy with some fields changed.
  // WHY? In Flutter state management, you never mutate objects — you create new ones.
  Product copyWith({
    String? id,
    String? name,
    double? price,
    String? imageUrl,
    String? category,
    int? quantity,
  }) {
    return Product(
      id: id ?? this.id,           // Use new value if provided, else keep current.
      name: name ?? this.name,
      price: price ?? this.price,
      imageUrl: imageUrl ?? this.imageUrl,
      category: category ?? this.category,
      quantity: quantity ?? this.quantity,
    );
  }

  @override
  String toString() => 'Product($name, ₹$price, qty: $quantity)';
}

// ----- PATTERN 2: SERVICE CLASS -----
// Services contain BUSINESS LOGIC — the brains of your app.
// They don't know about UI. They just process data.

class CartService {
  final List<Product> _items = [];
  // Private list. WHY? External code must use addItem/removeItem.
  // If _items were public, someone could do cart._items.clear() and bypass all logic.

  // Getter returns unmodifiable list — read-only access.
  List<Product> get items => List.unmodifiable(_items);
  // WHY unmodifiable? If you returned _items directly, external code could modify it.
  // List.unmodifiable creates a wrapper that throws if you try to add/remove.

  void addItem(Product product) {
    // Check if product already exists in cart.
    final existingIndex = _items.indexWhere((item) => item.id == product.id);
    // indexWhere loops through the list and returns index of first match, or -1 if none.
    // (item) => item.id == product.id is a lambda/anonymous function that checks IDs.

    if (existingIndex != -1) {
      // Product already in cart — increase quantity.
      _items[existingIndex].quantity++;
      print('📦 ${product.name} quantity increased to ${_items[existingIndex].quantity}');
    } else {
      // New product — add to cart with quantity 1.
      _items.add(product.copyWith(quantity: 1));
      // WHY copyWith? We don't want to mutate the original product object.
      print('🛒 ${product.name} added to cart');
    }
  }

  void removeItem(String productId) {
    final index = _items.indexWhere((item) => item.id == productId);
    if (index == -1) {
      print('❌ Product not found in cart');
      return;
    }

    if (_items[index].quantity > 1) {
      _items[index].quantity--;
      print('📦 ${_items[index].name} quantity decreased to ${_items[index].quantity}');
    } else {
      final name = _items[index].name;
      _items.removeAt(index);
      // removeAt removes by index position. Different from removeWhere which uses a condition.
      print('🗑️ $name removed from cart');
    }
  }

  // Computed getter — total price of everything in cart.
  double get totalPrice {
    return _items.fold(0.0, (sum, item) => sum + (item.price * item.quantity));
    // 'fold' starts with 0.0 and accumulates:
    // Step 1: sum=0 + (firstItem.price * firstItem.quantity)
    // Step 2: sum=result + (secondItem.price * secondItem.quantity)
    // ...until all items are processed.
  }

  int get totalItems {
    return _items.fold(0, (sum, item) => sum + item.quantity);
    // Total count of items considering quantities.
  }

  void clear() {
    _items.clear();
    print('🧹 Cart cleared');
  }

  void printCart() {
    if (_items.isEmpty) {
      print('🛒 Cart is empty');
      return;
    }
    print('🛒 Cart:');
    for (var item in _items) {
      print('  • ${item.name} x${item.quantity} = ₹${item.price * item.quantity}');
    }
    print('  Total: ₹$totalPrice ($totalItems items)');
  }
}

// ----- PATTERN 3: STATE CLASS (Immutable) -----
// Flutter state management (Provider, Riverpod, Bloc) uses immutable state.
// You NEVER modify state directly — you always create a new copy.

enum AuthStatus { unauthenticated, loading, authenticated, error }

class AuthState {
  final AuthStatus status;
  final String? userId;
  final String? userName;
  final String? errorMessage;

  // 'const' constructor — enables creating compile-time constant instances.
  // WHY const? Dart can optimize const objects — they're created once and reused.
  const AuthState({
    this.status = AuthStatus.unauthenticated,
    this.userId,
    this.userName,
    this.errorMessage,
  });

  // Named constructor for common states — convenience and readability.
  const AuthState.initial() : this();
  // 'this()' redirects to the default constructor with all defaults.

  const AuthState.loading()
      : status = AuthStatus.loading,
        userId = null,
        userName = null,
        errorMessage = null;

  // copyWith — the bread and butter of immutable state management.
  AuthState copyWith({
    AuthStatus? status,
    String? userId,
    String? userName,
    String? errorMessage,
  }) {
    return AuthState(
      status: status ?? this.status,
      userId: userId ?? this.userId,
      userName: userName ?? this.userName,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  String toString() =>
      'AuthState(status: $status, user: $userName, error: $errorMessage)';
}

// Simulating a state management flow (like what Riverpod/Bloc does internally).
class AuthNotifier {
  AuthState _state = const AuthState.initial();
  // Starts with initial state (unauthenticated, no user).

  AuthState get state => _state;

  // Simulates login — in a real app, this calls Firebase Auth or your API.
  Future<void> login(String email, String password) async {
    _state = const AuthState.loading();
    // State is now: loading. In Flutter, this would trigger a CircularProgressIndicator.
    print('State → $_state');

    await Future.delayed(Duration(seconds: 1));
    // Simulates network delay. In real apps, this is the API call.

    if (email == 'test@test.com' && password == '123456') {
      _state = _state.copyWith(
        status: AuthStatus.authenticated,
        userId: 'usr_001',
        userName: 'Ashish',
      );
      // WHY copyWith instead of creating new AuthState()?
      // copyWith preserves any fields you don't specify. More concise and less error-prone.
    } else {
      _state = _state.copyWith(
        status: AuthStatus.error,
        errorMessage: 'Invalid credentials',
      );
    }
    print('State → $_state');
  }

  void logout() {
    _state = const AuthState.initial();
    print('State → $_state');
  }
}

// ----- PATTERN 4: REPOSITORY (Data Access Layer) -----
// Repositories abstract WHERE data comes from.
// Your business logic talks to repositories, not directly to APIs or databases.
// WHY? You can swap API for mock data in tests, or add caching, without changing business logic.

abstract class ProductRepository {
  Future<List<Product>> getAll();
  Future<Product?> getById(String id);
  // 'Product?' — nullable return. If product not found, returns null instead of crashing.
}

// Concrete implementation — this one simulates an API.
class ApiProductRepository implements ProductRepository {
  // 'implements' means this class MUST provide ALL methods from ProductRepository.
  // Unlike 'extends', it gets NO inherited implementation — everything is from scratch.

  // Simulated database of products.
  final List<Map<String, dynamic>> _fakeApiData = [
    {
      'id': 'p1',
      'name': 'iPhone 15',
      'price': 79999,
      'image_url': 'https://example.com/iphone.jpg',
      'category': 'Electronics',
    },
    {
      'id': 'p2',
      'name': 'Running Shoes',
      'price': 4999,
      'image_url': 'https://example.com/shoes.jpg',
      'category': 'Fashion',
    },
    {
      'id': 'p3',
      'name': 'The Alchemist',
      'price': 299,
      'image_url': 'https://example.com/book.jpg',
      'category': 'Books',
    },
    {
      'id': 'p4',
      'name': 'Wireless Earbuds',
      'price': 2499,
      'image_url': 'https://example.com/earbuds.jpg',
      'category': 'Electronics',
    },
  ];

  @override
  Future<List<Product>> getAll() async {
    // 'async' allows using 'await'. This function returns a Future (a promise of future data).
    await Future.delayed(Duration(milliseconds: 500));
    // Simulates network delay. Real app: await http.get(...)

    return _fakeApiData.map((json) => Product.fromJson(json)).toList();
    // .map() transforms each JSON map into a Product object.
    // .toList() converts the lazy Iterable to a concrete List.
    // This is the EXACT pattern used in every Flutter API integration.
  }

  @override
  Future<Product?> getById(String id) async {
    await Future.delayed(Duration(milliseconds: 200));
    final data = _fakeApiData.where((json) => json['id'] == id).firstOrNull;
    // .where() filters the list. .firstOrNull returns null if nothing matches.
    // WHY firstOrNull instead of first? 'first' throws if the list is empty. Safer to return null.
    if (data == null) return null;
    return Product.fromJson(data);
  }
}

// ----- PATTERN 5: UTILITY/HELPER CLASSES -----
// Static methods for common operations used everywhere in the app.

class PriceFormatter {
  // Private constructor — prevents anyone from creating an instance.
  // WHY? This class only has static methods. There's no reason to create objects of it.
  PriceFormatter._();

  static String format(double price) {
    // Convert 79999.0 → "₹79,999"
    String priceStr = price.toStringAsFixed(0);
    // toStringAsFixed(0) removes decimal places: 79999.0 → "79999"

    // Add comma separators (Indian format: 79,999 or 1,00,000).
    String result = '';
    int count = 0;
    for (int i = priceStr.length - 1; i >= 0; i--) {
      count++;
      result = priceStr[i] + result;
      // We're building the string right-to-left (from last digit).
      if (count == 3 && i > 0) {
        result = ',$result';
        // After first 3 digits from right, add comma.
        // For a more complete Indian format, you'd switch to groups of 2 after the first comma.
      }
    }
    return '₹$result';
  }

  static String formatWithDecimal(double price) {
    return '₹${price.toStringAsFixed(2)}';
    // toStringAsFixed(2) keeps 2 decimal places: 299.0 → "₹299.00"
  }
}

// ============================================================
// MAIN — Simulate a real app flow
// ============================================================
void main() async {
  // 'async' on main() because we use 'await' inside.

  print('=' * 55);
  print('🏪 E-COMMERCE APP SIMULATION');
  print('=' * 55);

  // ----- Step 1: Fetch Products (Repository Pattern) -----
  print('\n📡 Fetching products from API...');
  ProductRepository repo = ApiProductRepository();
  // WHY type it as ProductRepository, not ApiProductRepository?
  // So you can swap to MockProductRepository for testing without changing this code.
  // This is called "coding to an interface" — a core software engineering principle.

  List<Product> products = await repo.getAll();
  // 'await' pauses until the Future completes (data arrives).
  print('✅ Loaded ${products.length} products:');
  for (var p in products) {
    print('  • ${p.name} - ${PriceFormatter.format(p.price)}');
  }

  // ----- Step 2: User Authentication (State Pattern) -----
  print('\n🔐 User Authentication:');
  AuthNotifier auth = AuthNotifier();

  // Attempt login with wrong credentials.
  await auth.login('wrong@email.com', 'wrong');

  // Attempt login with correct credentials.
  await auth.login('test@test.com', '123456');

  // ----- Step 3: Shopping Cart (Service Pattern) -----
  print('\n🛒 Shopping Cart Operations:');
  CartService cart = CartService();

  // Add products to cart.
  cart.addItem(products[0]);    // iPhone 15
  cart.addItem(products[2]);    // The Alchemist
  cart.addItem(products[0]);    // iPhone 15 again (should increase quantity)
  cart.addItem(products[3]);    // Wireless Earbuds

  cart.printCart();

  // Remove one iPhone (quantity should decrease from 2 to 1).
  print('\nRemoving one iPhone...');
  cart.removeItem('p1');
  cart.printCart();

  // ----- Step 4: Single Product Lookup -----
  print('\n🔍 Looking up product p2...');
  Product? found = await repo.getById('p2');
  if (found != null) {
    print('Found: ${found.name} - ${PriceFormatter.format(found.price)}');
    print('As JSON: ${found.toJson()}');
  }

  // ----- Step 5: Demonstrate copyWith -----
  print('\n📋 Product copyWith demo:');
  Product original = products[0];
  Product discounted = original.copyWith(price: original.price * 0.8);
  // Creates a new product with 20% discount, keeping all other fields.
  print('Original: ${original.name} - ${PriceFormatter.format(original.price)}');
  print('Discounted: ${discounted.name} - ${PriceFormatter.format(discounted.price)}');

  // ----- Step 6: Logout -----
  print('\n👋 Logging out...');
  auth.logout();
}
