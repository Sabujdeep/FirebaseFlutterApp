import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'post_model.dart';

class PostRepository {

  Future<List<Post>> fetchPosts() async {
    try {
      final response = await http.get(
        Uri.parse('https://jsonplaceholder.typicode.com/posts'),
      );

      final List data = json.decode(response.body);

      final posts = data.map((e) => Post.fromJson(e)).toList();

      // Save locally
      final prefs = await SharedPreferences.getInstance();
      prefs.setString('cached_posts', json.encode(data));

      return posts;

    } catch (e) {
      // If API fails → get from local
      final prefs = await SharedPreferences.getInstance();
      final cached = prefs.getString('cached_posts');

      if (cached != null) {
        final List data = json.decode(cached);
        return data.map((e) => Post.fromJson(e)).toList();
      }

      throw Exception("No data");
    }
  }
}