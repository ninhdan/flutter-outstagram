import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:instagram_flutter/models/post.dart';
import 'package:instagram_flutter/utils/global.dart';
import 'package:instagram_flutter/utils/image_cached.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class PostWidget extends StatefulWidget {
  final Post post;

  const PostWidget({required this.post, super.key});

  @override
  State<PostWidget> createState() => _PostWidgetState();
}

class _PostWidgetState extends State<PostWidget> {
  String username = '';
  String avatar = '';
  final _controller = PageController();

  @override
  void initState() {
    super.initState();
    username = Global.user?.username ?? '';
    avatar = Global.user?.avatar ?? '';
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
          height: 70.h,
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
            trailing:
                const Icon(Icons.more_vert, color: Color(0xFF2F2F2F), size: 25),
          )),
        ),
        Column(
          children: [
            SizedBox(
              height: 375.h,
              child: PageView.builder(
                controller: _controller,
                scrollDirection: Axis.horizontal,
                itemCount: widget.post.images.length,
                itemBuilder: (BuildContext context, int index) {
                  return Container(
                    width: 375.w,
                    height: 375.h,
                    color: Colors.white,
                    child: CachedImage(
                      widget.post.images[index].url,
                      // fit: BoxFit.cover,
                    ),
                  );
                },
              ),
            ),
          ],
        ),
        Container(
          width: 375.w,
          color: Colors.white,
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            SizedBox(height: 14.h),
            Row(
              children: [
                SizedBox(width: 14.w),
                Icon(
                  Icons.favorite_outline,
                  size: 25.w,
                  color: const Color(0xFF2F2F2F),
                ),
                SizedBox(width: 15.w),
                Image.asset('assets/images/Comment.png', height: 25.h),
                SizedBox(width: 15.w),
                Image.asset('assets/images/Share.png', height: 25.h),
                const Spacer(flex: 1),

                if (widget.post.images.length > 1) // Kiểm tra số lượng ảnh
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
                const Spacer(flex: 3,),

                Padding(
                  padding: EdgeInsets.only(right: 15.w),
                  child:
                      Image.asset('assets/images/Bookmark.png', height: 25.h),
                )
              ],
            ),
            Padding(
              padding: EdgeInsets.only(left: 15.w, top: 10.5.h, bottom: 5.h),
              child: Text(
                'View by ninh nguyen and 10 others',
                style: TextStyle(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 15.w),
              child: Row(children: [
                Text(
                  username + ' ',
                  style: TextStyle(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  '${widget.post?.createdAt != null ? formatTime(widget.post!.createdAt) + ' ' : ''}',
                  style: TextStyle(
                    fontSize: 13.sp,
                    color: Colors.grey,
                  ),
                ),
                const Icon(
                  Icons.brightness_1,
                  size: 6, // Điều chỉnh kích thước của biểu tượng
                  color: Colors.grey,
                ),
                Text(
                  ''
                  ' ${widget.post?.caption != null ? widget.post!.caption + ' ' : ' '}',
                  style: TextStyle(
                    fontSize: 13.sp,
                  ),
                ),
              ]),
            ),
          ]),
        )
      ],
    );
  }
}
