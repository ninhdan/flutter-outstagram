import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:instagram_flutter/models/post.dart';
import 'package:instagram_flutter/models/post_create.dart';
import 'package:instagram_flutter/models/response/responsedata.dart';
import 'package:instagram_flutter/services/postservice.dart';
import 'package:instagram_flutter/utils/toast.dart';
import 'package:video_player/video_player.dart';

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
  final PostCreate post = PostCreate(caption: '', files: []);

  void handleSharePost() async {
    post.caption = caption.text;

    if(caption.text.length > 2000){
      CustomToast.showToast('Caption is too long');
      return;
    }

    if (caption.text.isEmpty) {
      CustomToast.showToast('Caption is required');
      return;
    }
    for (var file in widget.files) {
      post.files.add(file.path);
      print(file);
    }
    setState(() {
      islooding = true;
    });


    ResponseData result = await PostService().createPost(post);

    if (result.status == 200) {
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
        iconTheme: const IconThemeData(color: Colors.black),
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
    if (widget.files == null || widget.files.isEmpty) {
      return Container(); // hoặc một widget khác để hiển thị khi không có files
    }
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            height: 200.h,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: widget.files.length,
              itemBuilder: (context, index) {
                final file = widget.files[index];
                if (file.path.endsWith('.mp4') || file.path.endsWith('.mov')) {
                  return Stack(
                    children: [
                      VideoWidget(file),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: Icon(
                          Icons.camera_alt,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                    ],
                  );
                } else {
                  return Stack(
                    children: [
                      Container(
                        width: 200.w,
                        height: 200.h,
                        decoration: BoxDecoration(
                          color: Colors.amber,
                          image: DecorationImage(
                            image: FileImage(file),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: Icon(
                          Icons.camera_alt,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                    ],
                  );
                }
              },
            ),
          ),
          SizedBox(height: 10.h),
          Row(
            children: [
              Expanded(
                child: SizedBox(
                  width: 280.w,
                  height: 80.h,
                  child: TextField(
                    controller: controller,
                    decoration: const InputDecoration(
                      hintText: 'Write a caption ...',
                      hintStyle: TextStyle(color: Colors.grey),
                      border: InputBorder.none,
                    ),
                    style: const TextStyle(color: Colors.black),
                    maxLength: 2000, // Set the maximum character length
                    maxLengthEnforcement: MaxLengthEnforcement.enforced,
                    maxLines: 5,
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

class VideoWidget extends StatefulWidget {
  final File file;

  VideoWidget(this.file);

  @override
  _VideoWidgetState createState() => _VideoWidgetState();
}

class _VideoWidgetState extends State<VideoWidget> {
  late VideoPlayerController _controller;
  bool _isPlaying = false;

  @override
  void initState() {
    super.initState();
    if (widget.file != null) {
      _controller = VideoPlayerController.file(widget.file)
        ..initialize().then((_) {
          setState(() {});
        });
      _controller.setLooping(true);
      _controller.play();
      _controller.addListener(() {
        setState(() {
          _isPlaying = _controller.value.isPlaying;
        });
      });
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  void _togglePlayPause() {
    if (_isPlaying) {
      _controller.pause();
    } else {
      _controller.play();
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _togglePlayPause,
      child: AspectRatio(
        aspectRatio: 10 / 10,
        child: Stack(
          children: [
            if (_controller != null && _controller.value.isInitialized)
              VideoPlayer(_controller),
          ],
        ),
      ),
    );
  }
}