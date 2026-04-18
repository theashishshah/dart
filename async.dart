import "dart:async";

import "package:http/http.dart";

void main() async {
  Future<String> getUsername({String email = "test@mail.com"}) async {
    print("Getting username for the email: $email ...");
    await Future.delayed(Duration(seconds: 1));
    return "iamashishshah";
  }

  Stream<int> streamNumber(n) async* {
    for (int i = 0; i < n; i++) {
      await Future.delayed(Duration(seconds: 1));
      yield i;
    }
  }

  // String data = await getUsername();
  // print("Username: $data");

  print("Streaming numbers...");
  streamNumber(10).listen((num) => print(num));
}
