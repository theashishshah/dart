// ============================================================
// DART CLASSES — Part 1: Basics, Variables, Methods
// Run: dart run classes_basics.dart
// ============================================================

// ----- 1. SIMPLEST CLASS -----
class Dog {
  // Instance variables — every Dog object gets its own copy.
  String name; // Stores the dog's name. 'String' = text type.
  int age; // Stores the dog's age. 'int' = whole number.

  // Constructor — the function that runs when you write Dog(...).
  // 'this.name' is shorthand for: take the argument and assign it to the 'name' property.
  Dog(this.name, this.age);

  // Method — a function that belongs to each Dog object.
  // 'void' means it doesn't return any value — it just does something (prints).
  void bark() {
    print('$name says: Woof! I am $age years old.');
    // '$name' is string interpolation — Dart plugs in the variable's value.
  }
}

// ----- 2. VARIABLES — ALL TYPES -----
class BankAccount {
  // 'final' — once set, can never change. Perfect for things like account numbers.
  final String accountNumber;

  // Regular instance variable — can change anytime.
  String holderName;

  // Private variable — the underscore '_' makes it private (only accessible in THIS file).
  // WHY private? Balance should only change through deposit() and withdraw(), not directly.
  double _balance;

  // 'static' — belongs to the CLASS, not to any individual object.
  // WHY? We want ONE interest rate for ALL accounts, not a different rate per account.
  static double interestRate = 7.5;

  // Constructor with named parameters (curly braces).
  // 'required' forces the caller to provide these values — can't create an account without them.
  BankAccount({
    required this.accountNumber,
    required this.holderName,
    double initialBalance = 0, // Optional with default value of 0.
  }) : _balance = initialBalance; // Initializer list — sets _balance before the constructor body runs.

  // Getter — looks like a property from outside, but runs code internally.
  // Usage: account.balance (no parentheses needed!)
  double get balance => _balance;
  // '=>' is shorthand for: { return _balance; }
  // WHY a getter instead of making _balance public? Control. We can add logging/validation later.

  // Method to deposit money.
  void deposit(double amount) {
    if (amount <= 0) {
      // Guards against invalid input. Good practice: validate at the boundary.
      print('❌ Deposit amount must be positive.');
      return; // Exits the method early. Nothing below this line runs.
    }
    _balance += amount; // '+=' adds amount to current balance.
    print('✅ Deposited ₹$amount. New balance: ₹$_balance');
  }

  // Method to withdraw money.
  void withdraw(double amount) {
    if (amount > _balance) {
      print('❌ Insufficient balance. Available: ₹$_balance');
      return;
    }
    _balance -= amount; // '-=' subtracts amount from balance.
    print('✅ Withdrew ₹$amount. Remaining balance: ₹$_balance');
  }

  // Static method — belongs to the class, called via BankAccount.calculateInterest().
  // WHY static? Interest calculation doesn't need a specific account object — it's a utility.
  static double calculateInterest(double principal, int years) {
    return principal * interestRate * years / 100;
  }

  // Overriding toString() — controls what prints when you write print(account).
  @override
  String toString() {
    return 'Account($accountNumber, $holderName, Balance: ₹$_balance)';
    // Without this override, print(account) would show: "Instance of 'BankAccount'" — useless.
  }
}

// ----- 3. CONSTRUCTORS — ALL FLAVORS -----
class User {
  final String id;
  String name;
  String email;
  DateTime createdAt;

  // Default constructor with named parameters.
  User({
    required this.id,
    required this.name,
    required this.email,
  }) : createdAt = DateTime.now(); // Initializer list: sets createdAt to current time.

  // Named constructor — creates a User from a JSON map.
  // WHY? When you fetch data from an API, it comes as Map<String, dynamic> (JSON).
  // This converts that raw data into a proper User object with type safety.
  User.fromJson(Map<String, dynamic> json)
      : id = json['id'] as String, // 'as String' casts the dynamic value.
        name = json['name'] as String,
        email = json['email'] as String,
        createdAt = DateTime.parse(json['created_at'] as String);
  // DateTime.parse converts a string like "2024-01-15" into a DateTime object.

  // Named constructor — creates a guest user with default values.
  // WHY? Common pattern for apps that allow browsing without login.
  User.guest()
      : id = 'guest',
        name = 'Guest User',
        email = 'guest@example.com',
        createdAt = DateTime.now();

  // Converts the object back to JSON (a Map).
  // WHY? When sending data to an API, you need to convert objects to maps/JSON.
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'created_at': createdAt.toIso8601String(),
      // toIso8601String() converts DateTime to standard format: "2024-01-15T10:30:00.000"
    };
  }

  @override
  String toString() => 'User($name, $email)';
}

// ----- 4. GETTERS & SETTERS -----
class Rectangle {
  double _width; // Private — only accessible through getter/setter.
  double _height;

  Rectangle(this._width, this._height);

  // Getter for width.
  double get width => _width;

  // Setter with validation — prevents negative dimensions.
  set width(double value) {
    if (value <= 0) throw ArgumentError('Width must be positive');
    // 'throw' raises an error. The program crashes unless someone catches it.
    // WHY throw instead of just printing? Errors should be LOUD so bugs don't go unnoticed.
    _width = value;
  }

  double get height => _height;

  set height(double value) {
    if (value <= 0) throw ArgumentError('Height must be positive');
    _height = value;
  }

  // Computed property — not stored, calculated on demand.
  double get area => _width * _height;
  // WHY not store area? Because if width or height changes, a stored area would be outdated.
  // Computing it ensures it's always correct.

  double get perimeter => 2 * (_width + _height);

  // A method that returns whether this rectangle is a square.
  bool get isSquare => _width == _height;
}

// ============================================================
// MAIN — Run all the examples
// ============================================================
void main() {
  print('=' * 50);
  print('1. BASIC CLASS');
  print('=' * 50);

  Dog dog1 = Dog('Bruno', 3); // Creates a Dog object.
  Dog dog2 = Dog('Max', 1); // Creates another — each has its OWN name and age.
  dog1.bark(); // Output: Bruno says: Woof! I am 3 years old.
  dog2.bark(); // Output: Max says: Woof! I am 1 years old.

  print('');
  print('=' * 50);
  print('2. BANK ACCOUNT (Variables & Methods)');
  print('=' * 50);

  // Creating an account with named parameters.
  BankAccount account = BankAccount(
    accountNumber: 'ACC-001',
    holderName: 'Ashish',
    initialBalance: 10000,
  );

  print(account); // Calls toString() → Account(ACC-001, Ashish, Balance: ₹10000.0)
  account.deposit(5000); // ✅ Deposited ₹5000. New balance: ₹15000.0
  account.withdraw(3000); // ✅ Withdrew ₹3000. Remaining balance: ₹12000.0
  account.withdraw(50000); // ❌ Insufficient balance.
  account.deposit(-100); // ❌ Deposit amount must be positive.

  // Static method — called on the CLASS, not on an object.
  double interest = BankAccount.calculateInterest(100000, 2);
  print('Interest on ₹1,00,000 for 2 years: ₹$interest');

  print('');
  print('=' * 50);
  print('3. USER (Constructors)');
  print('=' * 50);

  // Using the default constructor.
  User user1 = User(id: '1', name: 'Ashish', email: 'ashish@example.com');
  print(user1); // User(Ashish, ashish@example.com)

  // Using the named constructor fromJson — simulating API data.
  Map<String, dynamic> apiData = {
    'id': '2',
    'name': 'Priya',
    'email': 'priya@example.com',
    'created_at': '2024-06-15T10:30:00.000',
  };
  User user2 = User.fromJson(apiData);
  print(user2); // User(Priya, priya@example.com)

  // Converting back to JSON.
  print('User as JSON: ${user1.toJson()}');

  // Using the guest constructor.
  User guest = User.guest();
  print('Guest: $guest');

  print('');
  print('=' * 50);
  print('4. RECTANGLE (Getters & Setters)');
  print('=' * 50);

  Rectangle rect = Rectangle(10, 5);
  print('Width: ${rect.width}'); // 10
  print('Height: ${rect.height}'); // 5
  print('Area: ${rect.area}'); // 50 — computed, not stored.
  print('Perimeter: ${rect.perimeter}'); // 30
  print('Is square? ${rect.isSquare}'); // false

  rect.width = 5; // Uses the setter (validates positive value).
  print('After making it 5x5:');
  print('Area: ${rect.area}'); // 25
  print('Is square? ${rect.isSquare}'); // true

  // Uncommenting the below line would throw an ArgumentError:
  // rect.width = -5;  // ArgumentError: Width must be positive
}
