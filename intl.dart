import "package:intl/intl.dart";

void main() {
  DateTime time = DateTime.now();
  var dateFormat = DateFormat("dd-MM-yyyy");
  String date = dateFormat.format(time);
  print(date);
}
