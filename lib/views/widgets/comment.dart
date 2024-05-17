import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:instagram_flutter/models/comment_create.dart';
import 'package:instagram_flutter/models/comment_post.dart';
import 'package:instagram_flutter/services/postservice.dart';
import 'package:instagram_flutter/utils/image_cached.dart';

class Comment extends StatefulWidget {
  final String postId;

  const Comment({required this.postId, super.key});

  @override
  State<Comment> createState() => _CommentState();
}

class _CommentState extends State<Comment> {
  final comment = TextEditingController();
  bool isloading = false;

  Future<void> handleComment() async {
    setState(() {
      isloading = true;
    });

    CommentCreate commentPost =
        CommentCreate(postId: widget.postId, content: comment.text);

    if (comment.text.isNotEmpty) {
      bool result = await PostService().createComment(commentPost);
      if (result) {
        print('Comment created');
      } else {
        print('Failed to create comment');
      }
    }
    setState(() {
      isloading = false;
      comment.clear();
    });
  }

  String formatTime(DateTime? time) {
    if (time == null) return '';

    final now = DateTime.now();
    final difference = now.difference(time);

    if (difference.inDays >= 365) {
      return '${difference.inDays ~/ 365}y';
    } else if (difference.inDays >= 30) {
      return '${difference.inDays ~/ 30}M';
    } else if (difference.inDays >= 7) {
      return '${difference.inDays ~/ 7}w';
    } else if (difference.inDays > 0) {
      return '${difference.inDays}d';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m';
    } else {
      return 'just now';
    }
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(25.r),
        topRight: Radius.circular(25.r),
      ),
      child: Container(
        color: Colors.white,
        height: 300.h,
        child: Stack(
          children: [
            Align(
              alignment: Alignment.topCenter,
              child: Padding(
                padding: EdgeInsets.only(top: 12.h),
                child: Column(
                  children: [
                    Container(
                      width: 50.w,
                      height: 6.h,
                      decoration: BoxDecoration(
                        color: Colors.grey[700],
                        borderRadius: BorderRadius.circular(6.h),
                      ),
                    ),
                    SizedBox(height: 25.h),
                    Text(
                      'Comments',
                      style: TextStyle(
                        color: Colors.black87,
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 10.h),
                    const Divider(
                      height: 1,
                      thickness: 1,
                      color: Color(0xFFD4D9DF),
                    ),
                    SizedBox(height: 10.h),
                    StreamBuilder<List<CommentPost>>(
                      stream: PostService().getCommentByPostId(widget.postId),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Center(child: CircularProgressIndicator());
                        } else if (snapshot.hasError) {
                          return Center(
                              child: Text('Error: ${snapshot.error}'));
                        } else {
                          List<CommentPost> comments = snapshot.data ?? [];
                          return ListView.builder(
                            physics: AlwaysScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: comments.length,
                            itemBuilder: (context, index) {
                              return comment_item(
                                comments[index].userName,
                                comments[index].avatar,
                                comments[index].content,
                                comments[index].createdAt,
                              );
                            },

                          );
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              //top: 0,
              left: 0,
              right: 0,
              bottom: 0,

              child: Container(
                height: 60.h,
                width: double.infinity,
                color: Colors.white,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    SizedBox(
                      height: 45.h,
                      width: 260.w,
                      child: TextField(
                        controller: comment,
                        maxLines: 4,
                        decoration: const InputDecoration(
                            hintText: 'Add a comment',
                            border: InputBorder.none),
                      ),
                    ),
                    GestureDetector(
                      onTap: handleComment,
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          color: Colors.blue,
                        ),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 17, vertical: 6),
                        child: isloading
                            ? SizedBox(
                                width: 10.w,
                                height: 10.h,
                                child: const CircularProgressIndicator(
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.white),
                                ))
                            : Icon(
                                FontAwesomeIcons.arrowUp,
                                color: Colors.white,
                                size: 18.sp,
                              ),
                      ),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget comment_item(
      String username, String avatar, String comment, DateTime createdAt) {
    return ListTile(
      leading: ClipOval(
        child: SizedBox(
          height: 35.h,
          width: 35.w,
          child: CachedImage(
            avatar.isNotEmpty ? avatar : 'https://instagram.fixc1-9.fna.fbcdn.net/v/t51.2885-19/44884218_345707102882519_2446069589734326272_n.jpg?_nc_ht=instagram.fixc1-9.fna.fbcdn.net&_nc_cat=1&_nc_ohc=TokSSzUDPVcQ7kNvgGMF0u_&edm=AJ9x6zYBAAAA&ccb=7-5&ig_cache_key=YW5vbnltb3VzX3Byb2ZpbGVfcGlj.2-ccb7-5&oh=00_AYCetGx_2KnUphpAbrzv_kkxLPaX07mcXeJxPNOXkBSYIg&oe=6648F00F&_nc_sid=65462d',
          ),
        ),
      ),
      title: Row(
        children: [
          Text(
            username,
            style: TextStyle(
              fontSize: 12.sp,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          SizedBox(width: 5.w), // Add some space between username and timestamp
          Text(
            formatTime(createdAt),
            style: TextStyle(
              fontSize: 12.sp, // Decreased font size for timestamp
              color: Colors.grey, // Changed color to grey for timestamp
            ),
          ),
        ],
      ),
      subtitle: Text(
        comment,
        style: TextStyle(
          fontSize: 12.sp,
          color: Colors.black,
        ),
      ),
    );
  }
}
