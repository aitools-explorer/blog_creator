import 'dart:typed_data';
import 'package:http/http.dart' as http;

class BlogImageProvider {

  Future<Uint8List> getNetworkImage(String url) async {
  final response = await http.get(Uri.parse(url));
  if (response.statusCode == 200) {
    return response.bodyBytes;
  } else {
    return Uint8List.fromList([]);
  }
}

}
