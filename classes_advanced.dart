// ============================================================
// DART CLASSES — Part 2: Inheritance, Abstract, Mixins, Enums
// Run: dart run classes_advanced.dart
// ============================================================

// ----- 1. ENUMS -----
// An enum defines a fixed set of named values. 
// WHY? Instead of using strings like 'admin', 'user', 'guest' (which can be misspelled),
// enums give you compile-time safety — Dart catches typos before the code even runs.
enum UserRole { admin, editor, viewer }

// Enhanced enum (Dart 3+) — enums can have properties and methods too.
enum OrderStatus {
  placed('Order Placed'),           // Each value has an associated label.
  preparing('Being Prepared'),
  outForDelivery('Out for Delivery'),
  delivered('Delivered'),
  cancelled('Cancelled');

  final String label;               // Property that stores the human-readable label.
  const OrderStatus(this.label);    // Const constructor — enum values are compile-time constants.

  // Method on the enum — check if the order is still active.
  bool get isActive => this != delivered && this != cancelled;
  // WHY a method on enum? Keeps related logic next to the data it operates on.
}

// ----- 2. INHERITANCE -----
// Base class — the parent that other classes will extend.
class Vehicle {
  String brand;
  int year;
  double _fuelLevel;    // Private — managed internally.

  Vehicle(this.brand, this.year, this._fuelLevel);

  double get fuelLevel => _fuelLevel;

  void refuel(double liters) {
    _fuelLevel += liters;
    print('⛽ Refueled $brand. Fuel: $_fuelLevel L');
  }

  void drive(double km) {
    double fuelNeeded = km * 0.08;  // 0.08 L per km as a base consumption rate.
    if (fuelNeeded > _fuelLevel) {
      print('❌ Not enough fuel to drive $km km');
      return;
    }
    _fuelLevel -= fuelNeeded;
    print('🚗 $brand drove $km km. Fuel remaining: ${_fuelLevel.toStringAsFixed(1)} L');
    // toStringAsFixed(1) rounds to 1 decimal place for clean output.
  }

  @override
  String toString() => '$brand ($year)';
}

// 'extends' — Car IS a Vehicle. It inherits ALL of Vehicle's properties and methods.
class Car extends Vehicle {
  int numberOfDoors;    // Car-specific property. Vehicles don't have doors, but Cars do.

  Car(String brand, int year, double fuelLevel, this.numberOfDoors)
      : super(brand, year, fuelLevel);
  // 'super(...)' calls the parent's constructor. Car needs to initialize Vehicle too.
  // WHY? Vehicle has its own setup (brand, year, fuel) that must happen.

  // Overriding drive() to add car-specific behavior.
  @override
  void drive(double km) {
    print('🚘 Car driving...');
    super.drive(km);    // Calls Vehicle's drive() — reuses parent logic.
    // WHY call super? We want the base fuel calculation, just adding a print before it.
  }

  void honk() {
    print('🔊 $brand: BEEP BEEP!');    // Only cars can honk. Vehicles in general don't.
  }
}

// Another child class — demonstrates different override behavior.
class ElectricCar extends Vehicle {
  double batteryPercent;

  ElectricCar(String brand, int year, this.batteryPercent)
      : super(brand, year, 0);    // Electric cars have 0 fuel.
  // WHY pass 0 for fuel? They don't use fuel at all. Battery is their energy source.

  @override
  void drive(double km) {
    double batteryNeeded = km * 0.5;    // 0.5% per km.
    if (batteryNeeded > batteryPercent) {
      print('🔋 Not enough battery to drive $km km');
      return;
    }
    batteryPercent -= batteryNeeded;
    print('⚡ $brand drove $km km. Battery: ${batteryPercent.toStringAsFixed(1)}%');
    // Notice: we DON'T call super.drive() because electric cars don't use fuel at all.
    // The parent's logic is irrelevant here — we completely replace it.
  }

  @override
  void refuel(double liters) {
    print('⚡ $brand is electric! Use charge() instead.');
    // Override to prevent confusion — electrics don't refuel.
  }

  void charge(double percent) {
    batteryPercent = (batteryPercent + percent).clamp(0, 100);
    // 'clamp(0, 100)' ensures battery stays between 0% and 100%. Never negative, never over 100.
    print('🔌 $brand charged to ${batteryPercent.toStringAsFixed(1)}%');
  }
}

// ----- 3. ABSTRACT CLASSES -----
// 'abstract' — cannot be instantiated directly. It's a CONTRACT.
// Any class that extends it MUST implement all abstract methods.
abstract class PaymentMethod {
  String get methodName;    // Abstract getter — no body. Subclasses MUST provide the name.

  // Abstract method — no body, just signature. Forces subclasses to implement payment logic.
  bool processPayment(double amount);

  // Concrete method — HAS a body. Shared by ALL payment methods.
  // WHY concrete? Receipt generation is the SAME regardless of payment type.
  void generateReceipt(double amount) {
    print('📄 Receipt: ₹$amount paid via $methodName');
  }
}

class CashPayment extends PaymentMethod {
  @override
  String get methodName => 'Cash';    // Provides the required getter.

  @override
  bool processPayment(double amount) {
    print('💵 Processing cash payment of ₹$amount...');
    print('💵 Cash received. Payment complete.');
    return true;    // Cash payments always succeed (in this simple model).
  }
}

class UPIPayment extends PaymentMethod {
  String upiId;    // UPI-specific field.

  UPIPayment(this.upiId);

  @override
  String get methodName => 'UPI ($upiId)';

  @override
  bool processPayment(double amount) {
    print('📱 Sending UPI request to $upiId for ₹$amount...');
    // Simulating — in real app, this would call a payment gateway API.
    if (amount > 100000) {
      print('❌ UPI limit exceeded. Max ₹1,00,000 per transaction.');
      return false;    // Payment failed.
    }
    print('✅ UPI payment successful!');
    return true;
  }
}

// ----- 4. MIXINS -----
// Mixins let you REUSE code across unrelated classes.
// Unlike inheritance, you can 'mix in' multiple mixins. Dart only allows single inheritance.

mixin Loggable {
  // Any class using this mixin gets a log() method.
  void log(String message) {
    final timestamp = DateTime.now().toString().substring(11, 19);
    // substring(11, 19) extracts just the time portion: "14:30:45"
    print('[$timestamp] $message');
  }
}

mixin Serializable {
  // Any class using this mixin promises to provide toMap().
  Map<String, dynamic> toMap();

  // Converts the map to a simple string representation.
  String serialize() {
    return toMap().entries.map((e) => '${e.key}=${e.value}').join('&');
    // .entries gives key-value pairs.
    // .map() transforms each pair into "key=value" strings.
    // .join('&') combines them with '&' separator.
    // Result looks like: "name=Ashish&age=25&city=Mumbai"
  }
}

// Using multiple mixins with 'with' keyword.
class Employee with Loggable, Serializable {
  String name;
  String department;
  double salary;

  Employee(this.name, this.department, this.salary);

  @override
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'department': department,
      'salary': salary,
    };
  }

  void promote(double raise) {
    salary += raise;
    log('$name promoted! New salary: ₹$salary');
    // 'log()' comes from the Loggable mixin — Employee didn't define it.
  }
}

// ----- 5. FACTORY CONSTRUCTOR (Singleton Pattern) -----
class AppDatabase {
  static final AppDatabase _instance = AppDatabase._internal();
  // 'static' — belongs to the class itself.
  // 'final' — the instance never changes.
  // '_internal()' — calls the private constructor to create the ONE instance.

  final Map<String, dynamic> _data = {};
  // In-memory storage. In a real app, this would be SQLite or similar.

  factory AppDatabase() {
    // 'factory' — instead of creating a new object, it returns the existing singleton.
    return _instance;
    // WHY singleton? A database should have ONE connection/instance to avoid conflicts.
  }

  AppDatabase._internal();
  // Private constructor (underscore). No one outside this class can call it.
  // The only place it's called is in the static _instance initialization above.

  void insert(String key, dynamic value) {
    _data[key] = value;
    print('📝 Inserted: $key = $value');
  }

  dynamic get(String key) {
    return _data[key];    // Returns null if key doesn't exist (Map's default behavior).
  }

  void printAll() {
    print('📊 Database contents: $_data');
  }
}

// ============================================================
// MAIN — Run all the examples
// ============================================================
void main() {
  print('=' * 50);
  print('1. ENUMS');
  print('=' * 50);

  OrderStatus status = OrderStatus.preparing;
  print('Status: ${status.label}');        // "Being Prepared" — the human-readable label.
  print('Is active? ${status.isActive}');  // true — order is still in progress.

  OrderStatus delivered = OrderStatus.delivered;
  print('Delivered is active? ${delivered.isActive}');  // false

  print('');
  print('=' * 50);
  print('2. INHERITANCE');
  print('=' * 50);

  Car car = Car('Honda City', 2024, 40, 4);
  car.drive(100);     // 🚘 Car driving... 🚗 Honda City drove 100 km.
  car.honk();         // 🔊 Honda City: BEEP BEEP!
  car.refuel(20);     // ⛽ Refueled Honda City.

  print('');
  ElectricCar tesla = ElectricCar('Tesla Model 3', 2024, 85);
  tesla.drive(50);    // ⚡ Tesla drove 50 km. Battery: 60.0%
  tesla.refuel(10);   // ⚡ Tesla is electric! Use charge() instead.
  tesla.charge(30);   // 🔌 Tesla charged to 90.0%

  print('');
  print('=' * 50);
  print('3. ABSTRACT CLASSES & POLYMORPHISM');
  print('=' * 50);

  // Polymorphism — treating different types through a common interface.
  List<PaymentMethod> methods = [
    CashPayment(),
    UPIPayment('ashish@upi'),
  ];
  // WHY a List<PaymentMethod>? We can loop through any payment type uniformly.
  // This is the POWER of abstract classes — code that works with ANY payment method.

  double orderAmount = 2500;
  for (PaymentMethod method in methods) {
    print('---');
    bool success = method.processPayment(orderAmount);
    if (success) {
      method.generateReceipt(orderAmount);
    }
  }

  print('');
  print('=' * 50);
  print('4. MIXINS');
  print('=' * 50);

  Employee emp = Employee('Ashish', 'Engineering', 50000);
  emp.promote(10000);              // Uses Loggable mixin's log() method.
  print('Serialized: ${emp.serialize()}');  // Uses Serializable mixin.
  // Output: name=Ashish&department=Engineering&salary=60000.0

  print('');
  print('=' * 50);
  print('5. SINGLETON (Factory Constructor)');
  print('=' * 50);

  AppDatabase db1 = AppDatabase();    // Gets the singleton.
  AppDatabase db2 = AppDatabase();    // Gets the SAME singleton.

  print('Same instance? ${identical(db1, db2)}');  // true — both point to the same object.

  db1.insert('user', 'Ashish');
  db2.insert('theme', 'dark');

  db1.printAll();  // Shows BOTH entries — because db1 and db2 are the same object.
  // Output: {user: Ashish, theme: dark}
}
