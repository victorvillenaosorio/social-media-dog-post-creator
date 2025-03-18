import 'dart:convert';
import 'package:http/http.dart' as http;

class PostService {
  final String apiBaseUrl;

  PostService(this.apiBaseUrl);

  Future<http.Response> savePost(Map<String, dynamic> postData, {bool isNew = false}) async {
    final url = Uri.parse('$apiBaseUrl/post');
    return isNew
        ? await http.post(url, body: json.encode(postData), headers: {'Content-Type': 'application/json'})
        : await http.put(url, body: json.encode(postData), headers: {'Content-Type': 'application/json'});
  }

  Future<http.Response> deletePost(String postId) async {
    final url = Uri.parse('$apiBaseUrl/post/$postId');
    return await http.delete(url);
  }
}