import 'dart:async';
import 'dart:convert';
import 'package:instagram_flutter/models/comment_create.dart';
import 'package:instagram_flutter/models/comment_post.dart';
import 'package:instagram_flutter/models/post.dart';
import 'package:instagram_flutter/models/post_create.dart';
import 'package:http/http.dart' as http;
import 'package:instagram_flutter/models/post_edit.dart';
import 'package:instagram_flutter/models/response/responsedata.dart';
import 'package:instagram_flutter/utils/global.dart';
import 'package:instagram_flutter/views/widgets/comment.dart';
import 'package:permission_handler/permission_handler.dart';
import '../utils/const.dart';
import 'package:http_parser/http_parser.dart';
import 'package:mime/mime.dart';

class PostService {
  Future<ResponseData> createPost(PostCreate post) async {
    ResponseData responsesData = ResponseData(message: '');

    List<String> fileNamesList = post.files;
    String token = Global.user!.token;

    List<String> acceptedTypes = [
      'image/jpeg',
      'image/png',
      'image/jpg',
      'image/webp',
      'video/mp4'
    ];
    var request = http.MultipartRequest('POST', Uri.parse('$urlBase/posts/me'));

    for (var fileName in fileNamesList) {
      if (fileName.isNotEmpty) {
        String? contentType = lookupMimeType(fileName);
        if (contentType != null && acceptedTypes.contains(contentType)) {
          request.files.add(
            await http.MultipartFile.fromPath(
              'files',
              fileName,
              contentType: MediaType.parse(contentType),
            ),
          );
        } else {
          print('File type not supported: $fileName');
        }
      }
    }

    request.fields.addAll({
      'caption': post.caption,
    });

    request.headers.addAll({
      'Authorization': 'Bearer $token',
    });

    try {
      var response = await request.send();

      var responseData = await response.stream.transform(utf8.decoder).join();
      var jsonData = jsonDecode(responseData);
      var code = jsonData['code'];
      var message = jsonData['message'];
      var data = jsonData['data'];

      if (code == 201) {
        responsesData.status = code;
        responsesData.message = message;
        responsesData.data = data;
      } else {
        responsesData.message = message;
        responsesData.data = data;
      }
    } catch (e) {
      responsesData.message = e.toString();
    }

    return responsesData;
  }

  Future<List<Post>> getAllPostOfUser(String userId) async {
    List<Post> posts = [];
    String token = Global.user!.token;
    try {
      final response = await http.get(
        Uri.parse('$urlBase/posts/user/$userId'),
        headers: <String, String>{
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body)['data'];
        for (var item in jsonData) {
          posts.add(Post.fromJson(item));
        }
        return posts;
      } else {
        print('Failed to load posts: ${response.statusCode}');
        return [];
      }
    } catch (e) {
      print('Error: $e');
      print('Failed to load posts check 1: $e');
      return [];
    }
  }

  final StreamController<List<Post>> _postStreamController =
      StreamController<List<Post>>();
  Stream<List<Post>> getAllPostsOfUserMe() async* {
    List<Post> posts = [];
    String token = Global.user!.token;
    try {
      final response = await http.get(
        Uri.parse('$urlBase/posts/me'),
        headers: <String, String>{
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body)['data'];
        for (var item in jsonData) {
          posts.add(Post.fromJson(item));
        }
        _postStreamController.add(posts);
      } else {
        print('Failed to load posts: ${response.statusCode}');
        _postStreamController
            .addError('Failed to load posts: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
      print('Failed to load posts check 2: $e');
      _postStreamController.addError('Error: $e');
    }
    yield* _postStreamController.stream;
  }

  Future<Post> getPostById(String postId) async {
    String token = Global.user!.token;
    try {
      final response = await http.get(
        Uri.parse('$urlBase/posts/$postId'),
        headers: <String, String>{
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body)['data'];
        return Post.fromJson(jsonData);
      } else {
        print('Failed to load post: ${response.statusCode}');
        return Post.empty();
      }
    } catch (e) {
      print('Error: $e');
      return Post.empty();
    }
  }

  Future<List<Post>> getListPostLastUpdate() async {
    List<Post> posts = [];
    String token = Global.user!.token;
    try {
      final response = await http.get(
        Uri.parse('$urlBase/posts/me'),
        headers: <String, String>{
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body)['data'];
        for (var item in jsonData) {
          posts.add(Post.fromJson(item));
        }
        return posts;
      } else {
        print('Failed to load posts: ${response.statusCode}');
        return [];
      }
    } catch (e) {
      print('Error: $e');
      print('Failed to load posts check 1: $e');
      return [];
    }
  }

  Future<bool> likePost(String postId) async {
    String token = Global.user!.token;
    try {
      final response = await http.post(
        Uri.parse('$urlBase/posts/me/like/$postId'),
        headers: <String, String>{
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );

      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  Future<bool> editPost(PostEdit postEdit) async {
    String token = Global.user!.token;
    Map<String, String> param = {
      'caption': postEdit.caption,
      'platform': 'Flutter',
    };
    try {
      final response = await http.put(
        Uri.parse('$urlBase/posts/me/${postEdit.postId}'),
        headers: <String, String>{
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(param),
      );

      if (response.statusCode == 200) {
        print('Post edited');
        return true;
      } else {
        print('Failed to edit post');
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  Future<bool> deletePost(String postId) async {
    String token = Global.user!.token;
    try {
      final response = await http.delete(
        Uri.parse('$urlBase/posts/me/$postId'),
        headers: <String, String>{
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );

      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  Future<bool> createComment(CommentCreate comment) async {
    String token = Global.user!.token;
    Map<String, String> param = {
      'content': comment.content,
      'platform': 'Flutter',
    };
    try {
      final response = await http.post(
        Uri.parse('$urlBase/posts/me/comment/${comment.postId}'),
        headers: <String, String>{
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(param),
      );

      if (response.statusCode == 201) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }


  Stream<List<CommentPost>> getCommentByPostId(String postId) async* {
    String token = Global.user!.token;
    try {
      final response = await http.get(
        Uri.parse('$urlBase/posts/comment/$postId'),
        headers: <String, String>{
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body)['data'];
        final List<CommentPost> commentPosts = (jsonData as List)
            .map((item) => CommentPost.fromJson(item))
            .toList();
        yield commentPosts;
      } else {
        print('Failed to load post: ${response.statusCode}');
        yield []; // Yield an empty list if failed
      }
    } catch (e) {
      print('Error: $e');
      yield []; // Yield an empty list if error occurred
    }
  }

}
