import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:instagram_flutter/models/post.dart';
import 'package:instagram_flutter/services/postservice.dart';
import 'package:instagram_flutter/views/widgets/post_widget.dart';

class PostScreen extends StatefulWidget {
  final String postId;

  PostScreen({required this.postId});

  @override
  State<PostScreen> createState() => _PostScreenState();
}

class _PostScreenState extends State<PostScreen> {
  late Future<List<Post>> _postsFuture;
  late Future<Post> _postFuture;

  @override
  void initState() {
    super.initState();
    _postFuture = fetchPost(widget.postId);
    _postsFuture = fetchPosts();
  }

  Future<Post> fetchPost(String postId) async {
    var result = await PostService().getPostById(postId);
    return result;
  }

  Future<List<Post>> fetchPosts() async {
    var result = await PostService().getAllPostsOfUserMe();
    return result;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        title: const Row(
          children: [
            Text(
              'Posts',
              style:
                  TextStyle(color: Colors.black, fontWeight: FontWeight.w700),
            ),
          ],
        ),
        backgroundColor: const Color(0xfffafafa),
      ),
      body: FutureBuilder(
        future: Future.wait([_postFuture, _postsFuture]),
        builder: (context, AsyncSnapshot<List<dynamic>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            Post selectedPost = snapshot.data![0];
            List<Post> posts = snapshot.data![1];

            // Loại bỏ bài viết đã chọn khỏi danh sách các bài viết còn lại
            posts = posts.where((post) => post.id != selectedPost.id).toList();

            return CustomScrollView(
              slivers: [
                SliverList(
                  delegate: SliverChildListDelegate([
                    PostWidget(post: selectedPost), // Display selected post
                    // Add any spacing or divider widgets here if needed
                  ]),
                ),
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                        (BuildContext context, int index) {
                      return PostWidget(post: posts[index]);
                    },
                    childCount: posts.length,
                  ),
                ),
              ],
            );
          }
        },
      ),
    );
  }
}
