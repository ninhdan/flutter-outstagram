import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:instagram_flutter/views/widgets/post_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
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
                right: 9.0), // Add left padding to the first button
            child: IconButton(
              onPressed: () {},
              icon: Image.asset(
                'assets/images/Like.png',
                width: 30,
                height: 44,
              ),
              color: Color(0xFF2F2F2F),
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
        backgroundColor: Color(0xfffafafa),
      ),
      body: CustomScrollView(
        slivers: [
          SliverList(
              delegate: SliverChildBuilderDelegate(
            (context, index) {
              return  PostWidget();
            },
            childCount: 1,
          )),
        ],
      ),
    );
  }
}
