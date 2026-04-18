import "package:http/http.dart" as http;
import "dart:convert";

Future<void> getData(String url) async {
  Uri uri = Uri.parse(url);

  var response = await http.get(uri);
  if (response.statusCode != 200)
    throw Exception("Bad GET request from server");
  if (response.statusCode == 500)
    throw Exception("Internal Server error, ${response}");

  print(response.statusCode);
  print(response.body);
}

Future<void> postData(String url) async {
  Uri uri = Uri.parse(url);

  var response = await http.post(uri,
      headers: {
        "Content-Type": "application/json",
      },
      body: jsonEncode({
        "Name": "Ashish Shah",
        "Age": 22,
        "Address": "KSR Layout, Bangalore, India"
      }));

  print(response.statusCode);
  print(response.body);
}

void main() async {
  const String baseUrl = "http://localhost:9000/data";

  print("--- Fetching Data (GET) ---");
  await getData(baseUrl);

  print("\n--- Sending Data (POST) ---");
  await postData(baseUrl);
}
