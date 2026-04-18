import "dart:io";

// use stream instead

Stream<String> getLines(File file) async* {
  await Future.delayed(Duration(seconds: 1));
}

void main() async {
  File file = File("config.txt");

  // read entire file, but this is not a good way of reading files
  // String content = await file.readAsString();
  // print("content data: $content");

  // List<String> lineContent = await file.readAsLines();
  // int i = 1;
  // for (String line in lineContent) print("Line ${i++}: $line");
}
