import "dart:convert";

void main() {
  String jsonString = '{"name": "Alice", "age": 30}';
  Map<String, dynamic> user = jsonDecode(jsonString);
  print('Name: ${user['name']}');
  print('Age: ${user['age']}');

  Map<String, dynamic> newUser = {'name': 'Bob', 'age': 25};
  String newJsonString = jsonEncode(newUser);
  print(newJsonString);
}
