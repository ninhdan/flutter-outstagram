import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:instagram_flutter/models/post.dart';
import 'package:instagram_flutter/services/postservice.dart';
import 'package:instagram_flutter/views/widgets/post_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Future<List<Post>> _postListFuture;

  @override
  void initState() {
    super.initState();
    _postListFuture = _fetchPosts();
  }

  Future<List<Post>> _fetchPosts() async {
    var result = await PostService().getAllPostOfUser();
    return result;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        title: SizedBox(
          width: 105.w,
          height: 44.h,
          child: Image.asset('assets/images/logo.png'),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(
                right: 9.0),
            child: IconButton(
              onPressed: () async {},
              icon: Image.asset(
                'assets/images/Like.png',
                width: 30,
                height: 44,
              ),
              color: const Color(0xFF2F2F2F),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
                right: 14.0), // Add left padding to the first button
            child: IconButton(
              onPressed: () {},
              icon: Image.asset(
                'assets/images/Messenger.png',
                width: 30,
                height: 44,
              ),
            ),
          ),
        ],
        backgroundColor: const Color(0xfffafafa),
      ),
      body: CustomScrollView(
        slivers: [
          FutureBuilder<List<Post>>(
            future: _postListFuture,
            builder:
                (BuildContext context, AsyncSnapshot<List<Post>> snapshot) {
              if (snapshot != null) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  print("Loading posts...");
                  return const SliverFillRemaining(
                      child: Center(child: CircularProgressIndicator()));
                } else if (snapshot.hasError) {
                  print(snapshot.error);
                  return SliverFillRemaining(
                      child: Text('Error: ${snapshot.error}'));
                } else {
                  return SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (BuildContext context, int index) {
                        return PostWidget(post: snapshot.data![index]);
                      },
                      childCount: snapshot.data!.length,
                    ),
                  );
                }
              } else {
                return const SliverFillRemaining(
                    child: Center(child: CircularProgressIndicator()));
              }
            },
          ),
        ],
      ),
    );
  }
}
