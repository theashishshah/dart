// Working with path
import "package:path/path.dart" as path;

void main() {
  // String fullPath = path.join("dir", "text.txt");
  // print(fullPath);

  // String userpath = "users/ashish/docs/report.pdf";
  // print("File name: ${path.basename(userpath)}");
  // print("Extension of file: ${path.extension(userpath)}");
  // print("Directory name before file name: ${path.dirname(userpath)}");
  // print("Get the file name without extension: ${path.withoutExtension(path.basename(userpath))}");

  // Messy paths:
  String messy = "./home/username/ashish/../docs/../file.txt";
  print(path.normalize(messy));

  print(path.isAbsolute("/usr/passwd"));
}
