import 'dart:convert';
import 'package:http/http.dart' as http;

import 'post_item.dart';

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

  Future<List<PostItem>> fetchPosts() async {
      final response = await http.get(Uri.parse('$apiBaseUrl/posts'));
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((post) {
          return PostItem(
            id: post['id'],
            message: post['message'],
            imageUrl: post['imageUrl'],
            likes: post['likes'] ?? 0,
            hashtags: post['hashtags'] != null ? List<String>.from(post['hashtags']) : [],
            scheduledDate: post['scheduledDate'] != null ? DateTime.parse(post['scheduledDate']) : null,
          );
        }).toList();
      } else {
        throw Exception('Failed to fetch posts: ${response.reasonPhrase}');
      }
    }

    Future<PostItem> generateNewPost() async {
      final response = await http.get(Uri.parse('$apiBaseUrl/post'));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return PostItem(
          id: '',
          message: data['message'],
          imageUrl: data['imageUrl'],
          likes: 0,
          hashtags: data['hashtags'] != null ? List<String>.from(data['hashtags']) : [],
          scheduledDate: data['scheduledDate'] != null ? DateTime.parse(data['scheduledDate']) : null,
        );
      } else {
        throw Exception('Failed to generate a new post: ${response.reasonPhrase}');
      }
    }
  
}