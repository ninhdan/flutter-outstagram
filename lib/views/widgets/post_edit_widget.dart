import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:instagram_flutter/models/post.dart';
import 'package:instagram_flutter/utils/global.dart';
import 'package:instagram_flutter/utils/image_cached.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:video_player/video_player.dart';

class PostEditWidget extends StatefulWidget {
  final Post post;
  final Function(String) onUpdateCaption;
  const PostEditWidget({required this.post, required this.onUpdateCaption, super.key});

  @override
  State<PostEditWidget> createState() => _PostEditWidgetState();
}

class _PostEditWidgetState extends State<PostEditWidget> {
  String username = '';
  String avatar = '';
  final _controller = PageController();
  final caption = TextEditingController();

  @override
  void initState() {
    super.initState();
    username = Global.user?.username ?? '';
    avatar = Global.user?.avatar ?? '';

    caption.text = widget.post.caption;
    caption.addListener(() {
      widget.onUpdateCaption(caption.text);
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
                style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w600),
              ),
              trailing: Text(
                widget.post?.createdAt != null
                    ? '${formatTime(widget.post!.createdAt)} '
                    : '',
                style: TextStyle(
                  fontSize: 13.sp,
                  color: Colors.grey,
                ),
              ),
            ),
          ),
        ),
        Stack(
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
          ],
        ),
        Container(
          width: 375.w,
          color: Colors.white,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment
                .center, // Align children to the center horizontally
            children: [
              SizedBox(height: 10.h),
              Center(
                // Center the dot indicator horizontally
                child: SmoothPageIndicator(
                  controller: _controller,
                  count: widget.post.images.length,
                  effect: ScrollingDotsEffect(
                    dotWidth: 6.0,
                    dotHeight: 6.0,
                    dotColor: Colors.grey.withOpacity(0.6),
                    activeDotColor: Colors.blue,
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 20.h),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 30.w),
          child: Row(
            children: [
              Expanded(
                child: SizedBox(
                  height: 80.h,
                  child: TextField(
                    controller: caption,
                    decoration: InputDecoration(
                      hintText: 'Write a caption ...',
                      hintStyle: TextStyle(color: Colors.grey),
                      border: InputBorder.none,
                    ),
                    style: const TextStyle(color: Colors.black),
                    maxLength: 2000,
                    maxLengthEnforcement: MaxLengthEnforcement.enforced,
                    maxLines: 10,
                  ),
                ),
              ),
            ],
          ),
        ),
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
