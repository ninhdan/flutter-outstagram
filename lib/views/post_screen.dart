import 'package:flutter/material.dart';
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
  late Future<Post> _postFuture;
  late Stream<List<Post>> _postStream;
  final PostService _postService = PostService();

  @override
  void initState() {
    super.initState();
    _postFuture = fetchPost(widget.postId);
    _postStream = _postService.getAllPostsOfUserMe();
  }

  Future<Post> fetchPost(String postId) async {
    var result = await PostService().getPostById(postId);
    return result;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        title: const Text(
          'Posts',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.w700),
        ),
        backgroundColor: const Color(0xfffafafa),
      ),
      body: FutureBuilder(
        future: _postFuture,
        builder: (context, AsyncSnapshot<Post> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            final selectedPost = snapshot.data!;
            return StreamBuilder<List<Post>>(
              stream: _postStream,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else {
                  final posts = snapshot.data!;

                  final otherPosts = posts
                      .where((post) => post.id != selectedPost.id)
                      .toList();

                  return CustomScrollView(
                    slivers: [
                      SliverList(
                        delegate: SliverChildListDelegate([
                          PostWidget(post: selectedPost),
                        ]),
                      ),
                      SliverList(
                        delegate: SliverChildBuilderDelegate(
                          (BuildContext context, int index) {
                            return PostWidget(post: otherPosts[index]);
                          },
                          childCount: otherPosts.length,
                        ),
                      ),
                    ],
                  );
                }
              },
            );
          }
        },
      ),
    );
  }
}
