import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:instagram_flutter/models/post.dart';
import 'package:instagram_flutter/models/response/responsedata.dart';
import 'package:instagram_flutter/services/postservice.dart';
import 'package:instagram_flutter/utils/toast.dart';

class AddPostTextScreen extends StatefulWidget {
  final List<File> files;
  const AddPostTextScreen({required this.files, Key? key}) : super(key: key);

  @override
  State<AddPostTextScreen> createState() => _AddPostTextScreenState();
}

class _AddPostTextScreenState extends State<AddPostTextScreen> {
  final caption = TextEditingController();
  final location = TextEditingController();
  bool islooding = false;
  final Post post = Post(caption: '', files: []);

  void handleSharePost() async {
    post.caption = caption.text;

    if (caption.text.isEmpty) {
      CustomToast.showToast('Caption is required');
      return;
    }
    for (var file in widget.files) {
      post.files.add(file.path);
    }
    setState(() {
      islooding = true;
    });
    ResponseData result = await PostService().post(post);

    if(result.status == 200){
      CustomToast.showToast(result.message);
    } else {
      CustomToast.showToast(result.message);
    }
    setState(() {
      islooding = false;
    });

    //Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.black),
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          'New post',
          style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 20.sp),
        ),
        centerTitle: false,
        actions: [
          Center(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: GestureDetector(
                onTap: () async {
                  handleSharePost();
                },
                child: Text(
                  'OK',
                  style: TextStyle(
                      color: Colors.blue,
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w600),
                ),
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: islooding
            ? const Center(
                child: CircularProgressIndicator(
                color: Colors.black,
              ))
            : Padding(
                padding: EdgeInsets.only(top: 10.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Caption(caption),
                    const Divider(
                      height: 1,
                      thickness: 1,
                    ),
                    // Location(location),
                  ],
                ),
              ),
      ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.white,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.blue,
            borderRadius: BorderRadius.circular(6),
          ),
          height: 56,
          child: TextButton(
            onPressed: () {
              handleSharePost();
            },
            child: const Text(
              'Share',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget Caption(TextEditingController controller) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Stack(
            children: [
              Container(
                width: 200.w,
                height: 200.h,
                decoration: BoxDecoration(
                  color: Colors.amber,
                  image: DecorationImage(
                    image: FileImage(widget.files[0]),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const Positioned(
                bottom: 0,
                right: 0,
                child: Icon(
                  Icons.camera_alt,
                  color: Colors.white,
                  size: 20,
                ),
              ),
            ],
          ),
          SizedBox(height: 10.h),
          Row(
            children: [
              Expanded(
                child: SizedBox(
                  width: 280.w,
                  height: 60.h,
                  child: TextField(
                    controller: controller,
                    decoration: const InputDecoration(
                      hintText: 'Write a caption ...',
                      hintStyle: TextStyle(color: Colors.grey),
                      border: InputBorder.none,
                    ),
                    style: const TextStyle(color: Colors.black),
                  ),
                ),
              ),
              SizedBox(width: 10.w),
              const Icon(
                Icons.camera_alt,
                color: Colors.white,
                size: 20,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget Location(TextEditingController controller) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10.w),
      child: SizedBox(
        width: 280.w,
        height: 30.h,
        child: TextField(
          controller: controller,
          decoration: const InputDecoration(
            hintText: 'Add location',
            border: InputBorder.none,
          ),
        ),
      ),
    );
  }
}
