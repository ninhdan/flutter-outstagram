import 'package:flutter/material.dart';
import 'package:instagram_flutter/models/post.dart';
import 'package:instagram_flutter/models/post_edit.dart';
import 'package:instagram_flutter/services/postservice.dart';
import 'package:instagram_flutter/utils/toast.dart';
import 'package:instagram_flutter/views/post_screen.dart';
import 'package:instagram_flutter/views/widgets/post_edit_widget.dart';
import 'package:instagram_flutter/views/widgets/post_widget.dart';

class PostEditScreen extends StatefulWidget {
  final String postId;

  PostEditScreen({required this.postId});

  @override
  State<PostEditScreen> createState() => _PostEditScreenState();
}

class _PostEditScreenState extends State<PostEditScreen> {
  late Future<Post> _postFuture;
  String _editedCaption = '';
  @override
  void initState() {
    super.initState();
    _postFuture = fetchPost(widget.postId);
  }

  Future<Post> fetchPost(String postId) async {
    var result = await PostService().getPostById(postId);
    return result;
  }

  void handleSavePostEdit() async {
    PostEdit postEdit = PostEdit(
      postId: widget.postId,
      caption: _editedCaption,
    );
    bool result = await PostService().editPost(postEdit);
    if (result) {
      CustomToast.showToast('Post edited');
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => PostScreen(postId: widget.postId)),
            (route) => route.isFirst, // Remove routes until you reach the first route
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        title: const Text(
          'Edit info',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.w700),
        ),
        backgroundColor: Color(0xfffafafa),
        actions: <Widget>[
          GestureDetector(
            onTap: () {
              handleSavePostEdit();
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Icon(
                Icons.check,
                size: 30,
                color: Colors.blue,
              ),
            ),
          ),
        ],
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
            return CustomScrollView(
              slivers: [
                SliverList(
                  delegate: SliverChildListDelegate([
                    PostEditWidget(
                      post: selectedPost,
                      onUpdateCaption: (newCaption) {
                        setState(() {
                          _editedCaption = newCaption;
                        });
                      },
                    ), // Display selected post
                  ]),
                ),
              ],
            );
          }
        },
      ),
    );
  }
}
