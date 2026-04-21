// Model Class - Representing data
class Task {
  final String id;
  final String title;
  final bool isCompleted;
  final DateTime createdAt;

  Task(
      {required this.id,
      required this.title,
      this.isCompleted = false,
      required this.createdAt});

  Task copyWith({String? title, String? id}) {
    // it will create another task with provided data else with same data
    return Task(
        createdAt: this.createdAt,
        title: title ?? this.title,
        isCompleted: this.isCompleted,
        id: id ?? this.id);
  }

  Map<String, dynamic> toMap() {

    // return an object to save into database
    return {
      "Id": id,
      "title": title,
      "isCompleted": isCompleted,
      "createdAt": createdAt.toIso8601String();
    };
  }

  factory Task.fromMap(){
    
  }
}
