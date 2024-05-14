import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PostIndividualScreen extends StatefulWidget {
  const PostIndividualScreen({super.key});

  @override
  State<PostIndividualScreen> createState() => _PostIndividualScreenState();
}

class _PostIndividualScreenState extends State<PostIndividualScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        title: SizedBox(
          width: 110.w,
          height: 44.h,
          child: Text('Post', style: TextStyle(fontSize: 24.sp)),
        ),
        backgroundColor: const Color(0xfffafafa),
      ),
      body: CustomScrollView(
        slivers: [
          // FutureBuilder<List<Post>>(
          //   future: _postListFuture,
          //   builder:
          //       (BuildContext context, AsyncSnapshot<List<Post>> snapshot) {
          //     if (snapshot != null) {
          //       if (snapshot.connectionState == ConnectionState.waiting) {
          //         print("Loading posts...");
          //         return const SliverFillRemaining(
          //             child: Center(child: CircularProgressIndicator()));
          //       } else if (snapshot.hasError) {
          //         print(snapshot.error);
          //         return SliverFillRemaining(
          //             child: Text('Error: ${snapshot.error}'));
          //       } else {
          //         return SliverList(
          //           delegate: SliverChildBuilderDelegate(
          //                 (BuildContext context, int index) {
          //               return PostWidget(post: snapshot.data![index]);
          //             },
          //             childCount: snapshot.data!.length,
          //           ),
          //         );
          //       }
          //     } else {
          //       return const SliverFillRemaining(
          //           child: Center(child: CircularProgressIndicator()));
          //     }
          //   },
          // ),
        ],
      ),
    );
  }
}
