import 'package:http/http.dart' as http;

class ApiClient {

  Future<http.Response> get(String url, [Map<String, String>? headers]) async {
    return await http.get(Uri.parse(url), headers: headers);
  }

  Future<http.Response> post(String url, {Map<String, String>? headers, String? body}) async {
    return await http.post(Uri.parse(url), headers: headers, body: body);
  }

}