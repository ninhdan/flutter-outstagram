import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:instagram_flutter/models/post.dart';
import 'package:instagram_flutter/services/postservice.dart';
import 'package:instagram_flutter/utils/global.dart';
import 'package:instagram_flutter/utils/image_cached.dart';
import 'package:instagram_flutter/views/post_edit_screen.dart';
import 'package:instagram_flutter/views/post_screen.dart';
import 'package:instagram_flutter/views/widgets/comment.dart';
import 'package:instagram_flutter/views/widgets/like_animation.dart';
import 'package:path/path.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:video_player/video_player.dart';

class PostWidget extends StatefulWidget {
  final Post post;

  const PostWidget({required this.post, super.key});

  @override
  State<PostWidget> createState() => _PostWidgetState();
}

class _PostWidgetState extends State<PostWidget> {
  @override
  bool isAnimating = false;
  late bool isPostLiked;
  String username = '';
  String avatar = '';
  final _controller = PageController();
  bool showFullCaption = false;
  late int countPost;

  late Stream<List<Post>> _postStream;

  @override
  void initState() {
    super.initState();

    username = Global.user?.username ?? '';
    avatar = Global.user?.avatar ?? '';
    isPostLiked = widget.post.likes.any((like) => like.isLiked);

    countPost = widget.post.likes.where((like) => like.isLiked).length;
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

  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 375.w,
          height: 54.h,
          color: Colors.white,
          child: Center(
              child: ListTile(
                  leading: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.grey.shade500,
                        width: 1.5,
                      ),
                    ),
                    child: CircleAvatar(
                      radius: 15, // Adjust the radius as needed
                      backgroundImage: NetworkImage(
                        avatar.isEmpty
                            ? 'https://instagram.fixc1-9.fna.fbcdn.net/v/t51.2885-19/44884218_345707102882519_2446069589734326272_n.jpg?_nc_ht=instagram.fixc1-9.fna.fbcdn.net&_nc_cat=1&_nc_ohc=TokSSzUDPVcQ7kNvgGMF0u_&edm=AJ9x6zYBAAAA&ccb=7-5&ig_cache_key=YW5vbnltb3VzX3Byb2ZpbGVfcGlj.2-ccb7-5&oh=00_AYCetGx_2KnUphpAbrzv_kkxLPaX07mcXeJxPNOXkBSYIg&oe=6648F00F&_nc_sid=65462d'
                            : avatar,
                      ),
                    ),
                  ),
                  title: Text(
                    username,
                    style:
                        TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w600),
                  ),
                  trailing: GestureDetector(
                    onTap: () {
                      showModalBottomSheet(
                        context: context,
                        builder: (context) {
                          return Container(
                            padding: EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.white,
                            ),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                ListTile(
                                  leading: SvgPicture.asset(
                                    'assets/images/Arch.svg',
                                    width: 27, // Adjust size as needed
                                    height: 27,
                                    color:
                                        Colors.black, // Adjust color as needed
                                  ),
                                  title: Text('Archive',
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.w500)),
                                  onTap: () {},
                                ),
                                ListTile(
                                  leading: Image.asset(
                                    'assets/images/no-chatting.png',
                                    width: 27, // Adjust size as needed
                                    height: 27,
                                    color:
                                        Colors.black, // Adjust color as needed
                                  ),
                                  title: Text('Hide comment count',
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.w500)),
                                  onTap: () {},
                                ),
                                ListTile(
                                  leading: Image.asset(
                                    'assets/images/like_hide.png',
                                    width: 30, // Adjust size as needed
                                    height: 30,
                                    color:
                                        Colors.black, // Adjust color as needed
                                  ),
                                  title: Text('Hide like count',
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.w500)),
                                  onTap: () {},
                                ),
                                ListTile(
                                  leading: SvgPicture.asset(
                                    'assets/images/edit.svg',
                                    width: 30, // Adjust size as needed
                                    height: 30,
                                    color:
                                        Colors.black, // Adjust color as needed
                                  ),
                                  title: Text('Edit',
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.w500)),
                                  onTap: () {
                                    Navigator.pop(context);
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => PostEditScreen(
                                            postId: widget.post.id),
                                      ),
                                    );
                                  },
                                ),
                                ListTile(
                                  leading: SvgPicture.asset(
                                    'assets/images/pin-3.svg', // Path to your SVG file
                                    width: 30, // Adjust size as needed
                                    height: 30,
                                    color:
                                        Colors.black, // Adjust color as needed
                                  ),
                                  title: Text('Pin to your profile',
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.w500)),
                                  onTap: () {},
                                ),
                                ListTile(
                                  leading: SvgPicture.asset(
                                    'assets/images/trash.svg', // Path to your SVG file
                                    width: 26, // Adjust size as needed
                                    height: 26,
                                    color: Colors.red, // Adjust color as needed
                                  ),
                                  title: Text('Delete',
                                      style: TextStyle(
                                          color: Colors.red,
                                          fontWeight: FontWeight.w500)),
                                  onTap: () {
                                    //Navigator.pop(context);
                                    showDialog(
                                        context: context,
                                        builder: (context) {
                                          return dialogDelete(context);
                                        });
                                  },
                                ),
                              ],
                            ),
                          );
                        },
                      );
                    },
                    child: const Icon(Icons.more_vert,
                        color: Color(0xFF2F2F2F), size: 25),
                  ))),
        ),
        GestureDetector(
          onDoubleTap: () async {
            if (!isPostLiked) {
              final success = await PostService().likePost(widget.post.id);
              if (success) {
                setState(() {
                  isPostLiked = !isPostLiked;
                  isAnimating = true;
                  countPost++;
                });
              }
            } else {
              setState(() {
                isPostLiked = true;
                isAnimating = true;
              });
            }
          },
          child: Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(
                height: 375.h,
                child: PageView.builder(
                  controller: _controller,
                  scrollDirection: Axis.horizontal,
                  itemCount: widget.post.images.length,
                  itemBuilder: (BuildContext context, int index) {
                    final media = widget.post.images[index].url;
                    if (media.endsWith('.mp4')) {
                      return Container(
                        width: 375.w,
                        height: 375.h,
                        color: Colors.black,
                        child: VideoWidget(media),
                      );
                    } else {
                      return Container(
                        width: 375.w,
                        height: 375.h,
                        color: Colors.black,
                        child: CachedImage(media),
                      );
                    }
                  },
                ),
              ),
              AnimatedOpacity(
                duration: const Duration(milliseconds: 200),
                opacity: isAnimating ? 1 : 0,
                child: LikeAnimation(
                  isAnimating: isAnimating,
                  duration: const Duration(milliseconds: 400),
                  iconlike: false,
                  End: () {
                    setState(() {
                      isAnimating = false;
                    });
                  },
                  child: Icon(FontAwesomeIcons.solidHeart,
                      size: 100.w, color: Colors.white),
                ),
              )
            ],
          ),
        ),
        Container(
          width: 375.w,
          color: Colors.white,
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            SizedBox(height: 10.h),
            Row(
              children: [
                SizedBox(width: 10.w),
                LikeAnimation(
                  isAnimating: isPostLiked,
                  child: IconButton(
                    onPressed: () async {
                      await PostService().likePost(widget.post.id);
                      setState(() {
                        isPostLiked = !isPostLiked;
                        countPost = isPostLiked ? countPost + 1 : countPost - 1;
                      });
                    },
                    icon: Icon(
                      isPostLiked
                          ? FontAwesomeIcons.solidHeart
                          : FontAwesomeIcons.heart,
                      size: 25.w,
                      color: isPostLiked ? Colors.red : const Color(0xFF2F2F2F),
                    ),
                  ),
                ),
                SizedBox(width: 13.w),
                GestureDetector(
                  onTap: () {
                    showBottomSheet(
                      backgroundColor: Colors.transparent,
                      context: context,
                      builder: (context) {
                        return Padding(
                          padding: EdgeInsets.only(
                              //bottom: MediaQuery.of(context).viewInsets.bottom,
                              ),
                          child: DraggableScrollableSheet(
                            maxChildSize: 0.8,
                            initialChildSize: 0.6,
                            minChildSize: 0.2,
                            builder: (context, scrollController) {
                              return Comment(postId: widget.post.id);
                            },
                          ),
                        );
                      },
                    );
                  },
                  child: Image.asset('assets/images/Comment.png', height: 27.w),
                ),
                SizedBox(width: 15.w),
                Image.asset('assets/images/Share.png', height: 27.w),
                const Spacer(flex: 1),
                if (widget.post.images.length > 1)
                  SmoothPageIndicator(
                    controller: _controller,
                    count: widget.post.images.length,
                    effect: ScrollingDotsEffect(
                      dotWidth: 6.0,
                      dotHeight: 6.0,
                      dotColor: Colors.grey.withOpacity(0.6),
                      activeDotColor: Colors.blue,
                    ),
                  ),
                const Spacer(
                  flex: 3,
                ),
                Padding(
                  padding: EdgeInsets.only(right: 15.w),
                  child:
                      Image.asset('assets/images/Bookmark.png', height: 27.h),
                )
              ],
            ),
            Padding(
              padding: EdgeInsets.only(left: 15.w, top: 5.5.h, bottom: 5.h),
              child: Text(
                '$countPost likes',
                style: TextStyle(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 15.w),
              child:
                  Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(
                  '$username ',
                  style: TextStyle(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  widget.post?.createdAt != null
                      ? '${formatTime(widget.post!.createdAt)} '
                      : '',
                  style: TextStyle(
                    fontSize: 13.sp,
                    color: Colors.grey,
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.only(top: 8.0),
                  child: Icon(
                    Icons.brightness_1,
                    size: 6,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(width: 5),
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        showFullCaption = !showFullCaption;
                      });
                    },
                    child: Text(
                      showFullCaption
                          ? widget.post?.caption ?? ''
                          : ((widget.post?.caption ?? '').length > 100
                              ? (widget.post?.caption ?? '').substring(0, 100)
                              : widget.post?.caption ?? ''),
                      style: TextStyle(
                        fontSize: 13.sp,
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: showFullCaption
                          ? 100
                          : 1, // Số dòng tối đa hiển thị khi chưa mở rộng
                    ),
                  ),
                ),
                if ((widget.post?.caption ?? '').length > 100)
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        showFullCaption = !showFullCaption;
                      });
                    },
                    child: Text(
                      showFullCaption ? ' Less' : 'More',
                      style: TextStyle(
                        color: Colors.blue,
                        fontSize: 13.sp,
                      ),
                    ),
                  ),
              ]),
            ),
          ]),
        )
      ],
    );
  }

  Widget dialogDelete(BuildContext context) {
    return AlertDialog(
      title: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Center(
            child: Text(
              'Delete is post?',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          SizedBox(height: 15),
          Center(
            child: Text(
              'You can restore this post \n form Recently Deleted in Your \n activity within 30 days. After \n that, it will be permanently \n deleted.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w400,
                color: Colors.grey[600],
              ),
            ),
          ),
          const SizedBox(height: 15),
          const Divider(
            height: 1,
            thickness: 1,
            color: Color(0xFFD4D9DF),
          ),
        ],
      ),
      content: GestureDetector(
        onTap: () async {
          bool result = await PostService().deletePost(widget.post.id);

          if (result) {
            setState(() {
              _postStream = PostService().getAllPostsOfUserMe();
            });

            List<Post> posts = await PostService().getListPostLastUpdate();

            if (posts.isEmpty) {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text("No posts available"),
                    actions: <Widget>[
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Text("OK"),
                      ),
                    ],
                  );
                },
              );
            } else {
              Post nearestPost = posts.firstWhere(
                (post) => post.id != widget.post.id,
                orElse: () => posts.first,
              );

              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                    builder: (context) => PostScreen(postId: nearestPost.id)),
                (route) => route
                    .isFirst, // Remove routes until you reach the first route
              );
            }
          } else {
            //show error
          }
        },
        child: const Text(
          'Delete',
          style: TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 18,
            color: Color(0xFF0C92127),
          ),
          textAlign: TextAlign.center,
        ),
      ),
      actions: <Widget>[
        const Divider(
          height: 1,
          thickness: 1,
          color: Color(0xFFD4D9DF),
        ),
        Center(
          child: TextButton(
            onPressed: () => Navigator.pop(context, 'Cancel'),
            child: const Text(
              'Cancel',
              style: TextStyle(
                fontWeight: FontWeight.w400,
                fontSize: 19,
                color: Colors.black87,
              ),
            ),
          ),
        )
      ],
    );
  }
}

class VideoWidget extends StatefulWidget {
  final String videoUrl;

  VideoWidget(this.videoUrl);

  @override
  _VideoWidgetState createState() => _VideoWidgetState();
}

class _VideoWidgetState extends State<VideoWidget> {
  late VideoPlayerController _controller;
  bool _isSoundOn = false;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.network(widget.videoUrl)
      ..initialize().then((_) {
        setState(() {});
      });
    _controller.setLooping(true);
    _controller.play();
    _controller.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _toggleSound() {
    double volume = _isSoundOn ? 0.0 : 1.0;
    _controller.setVolume(volume);
    setState(() {
      _isSoundOn = !_isSoundOn;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 16 / 9,
      child: Stack(
        alignment: Alignment.bottomRight,
        children: [
          VideoPlayer(_controller),
          GestureDetector(
            // GestureDetector bao bọc Stack để xử lý sự kiện nhấn
            onTap: _toggleSound,
            child: Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  // Lớp tròn
                  width: 36, // Kích thước của lớp tròn
                  height: 36,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.black.withOpacity(0.5),
                  ),
                ),
                IconButton(
                  onPressed: null,
                  icon: Icon(
                    _isSoundOn ? Icons.volume_up : Icons.volume_off,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
