// import 'user.dart';

/* class User {
  String name;
  int age;
  User(this.name, this.age);

  void greed() {
    print("Hi, My name is $name, and I'm $age YO.");
  }
}

*/

class Product {
  String title;
  double price;
  static int _totalProducts = 0;
  final String id;
  late String description;

  Product(this.title, this.price, this.id) {
    _totalProducts++;
  }
}

class Calculator {
  static double _result = 0;

  void add(double number) {
    if (number >= 0)
      _result += number;
    else
      throw Exception("Number can't be less than 0 to add");
  }

  static double total() => _result;

  static double quickAdd(double a, double b) => a + b;
}

class BankAccount {
  String owner;
  double _balance;
  // Private variable. We don't want outsiders to set any random value.

  BankAccount(this.owner, this._balance);
  // Constructor takes owner and initial balance.

  double get balance => _balance;
  // "get" defines a getter. It looks like a property but runs code.
  // "=>" is shorthand for { return _balance; }
  // Now outsiders can READ the balance: account.balance

  set balance(double balance) {
    if (balance < 0) throw Exception("Negative value can't not be set");
    _balance += balance;
  }

  // set balance(double amount) {
  //   // "set" defines a setter. It controls HOW the value is changed.
  //   if (amount >= 0) {
  //     _balance = amount;
  //     // Only allow non-negative values.
  //   } else {
  //     print('Balance cannot be negative!');
  //   }
  // }

  void deposit(double amount) {
    if (amount > 0) {
      _balance += amount;
      // Only add positive amounts.
    }
  }

  void withdraw(double amount) {
    if (amount > 0 && amount <= _balance) {
      _balance -= amount;
      // Only withdraw if there's enough balance.
    } else {
      print('Insufficient balance!');
    }
  }
}

class User {
  String name;
  String? id;
  late int age;
  String role;

  User(this.name, this.age, this.id, this.role);
  User.admin(this.name, this.age, this.id) : role = "admin";
  User.guest()
      : role = "guest",
        age = 0,
        name = "guest";

  @override
  String toString() {
    return 'User(name: $name, age: $age, role: $role, id: $id)';
  }
}

void main() {
  // User user = User("Ashish Shah", 22);
  // user.greed();

  // Product p1 = Product("Notebook", 10, "NYVO-212344");
  // Product p2 = Product("Notebook LLM", 28, "NYVO-2246");
  // print("Total products: ${Product._totalProducts}");
  // print("Product-1 ID: ${p1.id}");
  // print("Product-2 ID: ${p2.id}");

  // Calculator cal = Calculator();
  // cal.add(39);
  // cal.add(29);
  // print(Calculator._result);

  // print("User Password: ${Userr.password}");

  // BankAccount bankAccount = BankAccount("Ashish Shah", 34111.24);
  // print("Bank Balance: ${bankAccount.balance}");
  // // deposit some money to bank account
  // bankAccount.balance = 2944.2;
  // print("Bank Balance: ${bankAccount.balance}");

  User u1 = User("Ashish Shah", 22, "NYVO-213add", "owner");
  User u2 = User.admin("Prateek Dwivedi", 22, "RENEW_33243");
  User u3 = User.guest();

  print(u1);
  print(u2);
  print(u3);
}
