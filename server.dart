import 'dart:io';

void main() async {
  final server = await HttpServer.bind(
    InternetAddress.loopbackIPv4,
    4000,
  );
  print('Server running at http://${server.address.address}:${server.port}/');

  await for (HttpRequest request in server) {
    request.response
      ..write('Hello from Dart!')
      ..close();
  }
}
