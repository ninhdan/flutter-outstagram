import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';


class PostWidget extends StatefulWidget {
  const PostWidget({super.key});

  @override
  State<PostWidget> createState() => _PostWidgetState();
}

class _PostWidgetState extends State<PostWidget> {
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
                leading: ClipOval(
                  child: SizedBox(
                    width: 35.w,
                    height: 35.h,
                    child: Image.asset('assets/images/person.png'),
                  ),
                ),
                title: Text(
                  'username',
                  style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.bold),
                ),
                subtitle: Text(
                  'location',
                  style: TextStyle(fontSize: 11.sp),
                ),

                trailing: const Icon(Icons.more_vert, color: Color(0xFF2F2F2F), size: 25),
              )),
        ),
        Container(
          width: 375.w,
          height: 375.h,
          child: Image.asset(
            'assets/images/post.jpg',
            fit: BoxFit.cover,
          ),
          color: Colors.white,
        ),
        Container(
          width: 375.w,
          color: Colors.white,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
              children: [
            SizedBox(height: 14.h),
            Row(
              children: [
                SizedBox(width: 14.w),
                Icon(
                  Icons.favorite_outline,
                  size: 25.w,
                  color: Color(0xFF2F2F2F),
                ),
                SizedBox(width: 15.w),
                Image.asset('assets/images/Comment.png',
                    height: 25.h),
                SizedBox(width: 15.w),
                Image.asset('assets/images/Share.png', height: 25.h),
                const Spacer(),
                Padding(
                  padding: EdgeInsets.only(right: 15.w),
                  child: Image.asset('assets/images/Bookmark.png',
                      height: 25.h),
                )
              ],
            ),
            Padding(
              padding: EdgeInsets.only(
                  left: 19.w, top: 13.5.h, bottom: 5.h),
              child: Text(
                '0',
                style: TextStyle(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 15.w),
              child: Row(children: [
                Text(
                  'username' + ' ',
                  style: TextStyle(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'caption',
                  style: TextStyle(
                    fontSize: 13.sp,
                  ),
                ),
              ]),
            ),
            Padding(
                padding: EdgeInsets.only(left: 15.w, top: 20.h, bottom: 8.h),
                child: Text('dateformat',
                    style: TextStyle(
                        fontSize: 11.sp , color: Colors.grey)))
          ]),
        )
      ],
    );
  }
}
