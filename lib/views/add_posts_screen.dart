import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:instagram_flutter/utils/toast.dart';
import 'package:instagram_flutter/views/add_post_text_screen.dart';
import 'package:instagram_flutter/views/widgets/navigation.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:video_player/video_player.dart';

class AddPostScreen extends StatefulWidget {
  const AddPostScreen({Key? key}) : super(key: key);

  @override
  _AddPostScreenState createState() => _AddPostScreenState();
}

class _AddPostScreenState extends State<AddPostScreen> {
  final List<Widget> _mediaList = [];
  final List<File> path = [];
  File? _file;
  int currentPage = 0;
  int? lastPage;
  bool isMultipleSelection = false;

  List<File> selectedFiles = [];

  int selectedIndex = -1;
  _fetchNewMedia() async {
    lastPage = currentPage;
    final PermissionState ps = await PhotoManager.requestPermissionExtend();
    if (ps.isAuth) {
      List<AssetPathEntity> album =
          await PhotoManager.getAssetPathList(type: RequestType.common);
      List<AssetEntity> media =
          await album[0].getAssetListPaged(page: currentPage, size: 60);

      for (var asset in media) {
        if (asset.type == AssetType.image || asset.type == AssetType.video) {
          final file = await asset.file;
          if (file != null) {
            path.add(File(file.path));
            _file = path[0];
          }
        }
      }
      List<Widget> temp = [];
      for (var asset in media) {
        if (asset.type == AssetType.video) {
          temp.add(VideoWidget(asset));
        } else
          temp.add(
            FutureBuilder(
              future: asset.thumbnailDataWithSize(ThumbnailSize(200, 200)),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done)
                  return Container(
                    child: Stack(
                      children: [
                        Positioned.fill(
                          child: Image.memory(
                            snapshot.data!,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ],
                    ),
                  );

                return Container();
              },
            ),
          );
      }
      setState(() {
        _mediaList.addAll(temp);
        currentPage++;
      });
    }
  }

  void toggleSelectionMode() {
    setState(() {
      isMultipleSelection = !isMultipleSelection;

      if (!isMultipleSelection) {
        selectedFiles.clear();
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _fetchNewMedia();
  }

  int indexx = 0;

  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Row(
          children: [
            GestureDetector(
              onTap: () {
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => const Navigations_Screen()),
                      (route) => false,
                );
              },
              child: const Icon(Icons.close, color: Colors.black, size: 30),
            ),
            const SizedBox(width: 15),
            const Text(
              'New Post',
              style:
                  TextStyle(color: Colors.black, fontWeight: FontWeight.w700),
            ),
          ],
        ),
        centerTitle: false,
        actions: [
          Center(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.w),
              child: GestureDetector(
                onTap: () {
                  if (selectedFiles.isNotEmpty) {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) =>
                          AddPostTextScreen(files: selectedFiles),
                    ));
                  } else {
                    CustomToast.showToast('Please select a image or video');
                  }
                },
                child: Text(
                  'Next',
                  style: TextStyle(
                      fontSize: 15.sp,
                      color: Colors.blue,
                      fontWeight: FontWeight.w600),
                ),
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            child: Column(
              children: [
                SizedBox(
                  height: 375.h,
                  child: GridView.builder(
                    //shrinkWrap: true,
                    //physics: NeverScrollableScrollPhysics(),
                    itemCount: _mediaList.isEmpty ? _mediaList.length : 1,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 1,
                      mainAxisSpacing: 1,
                      crossAxisSpacing: 1,
                    ),
                    itemBuilder: (context, index) {
                      if (_mediaList[indexx] is VideoWidget) {
                        return _mediaList[indexx];
                      } else {
                        return _mediaList[indexx];
                      }
                    },
                  ),
                ),
                Container(
                  width: double.infinity,
                  height: 40.h,
                  color: Colors.white,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal:
                                15.w), // Adjust horizontal padding as needed
                        child: Text(
                          'Recents',
                          style: TextStyle(
                            fontSize: 15.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          toggleSelectionMode();
                        },
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal:
                                  15.w), // Adjust horizontal padding as needed
                          child: Container(
                            decoration: BoxDecoration(
                              color: isMultipleSelection
                                  ? Colors.blueAccent
                                  : Color(0xFF666666), // Set the desired color
                              borderRadius: BorderRadius.circular(
                                  20.0), // Adjust the radius to make the corners rounded
                            ),
                            child: Padding(
                              padding: EdgeInsets.all(
                                  8.0), // Adjust the inner padding if needed
                              child: Icon(
                                Icons.filter_none,
                                size: 13.sp,
                                color:
                                    Colors.white, // Set the color of the icon
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height - 375.h - 40.h,
                  child: GridView.builder(
                      shrinkWrap: true,
                      itemCount: _mediaList.length,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 4,
                        mainAxisSpacing: 1,
                        crossAxisSpacing: 2,
                      ),
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: EdgeInsets.all(0),
                          child: Stack(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    indexx = index;
                                    _file = path[index];
                                    if (selectedIndex != -1) {
                                      selectedFiles.remove(path[selectedIndex]);
                                    }
                                    selectedIndex = index;
                                    selectedFiles.add(path[index]);
                                  });
                                },
                                child: _mediaList[index],
                              ),
                              Visibility(
                                visible: isMultipleSelection,
                                child: Positioned.fill(
                                  child: Align(
                                    alignment: Alignment.topRight,
                                    child: GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          if (selectedFiles
                                              .contains(path[index])) {
                                            selectedFiles.remove(path[index]);
                                          } else if (selectedFiles.length <
                                              10) {
                                            indexx = index;
                                            selectedFiles.add(path[index]);
                                          } else if ((selectedFiles.length +
                                                  1) >
                                              10) {
                                            selectedFiles.remove(path[index]);
                                          }
                                        });
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.all(10),
                                        child: Container(
                                          decoration: BoxDecoration(
                                            color: selectedFiles
                                                    .contains(path[index])
                                                ? Colors.blue
                                                : Colors.transparent,
                                            shape: BoxShape.circle,
                                            border: Border.all(
                                              color: Colors.white,
                                              width: 1.5,
                                            ),
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.all(10),
                                            child: Text(
                                              "${selectedFiles.indexOf(path[index]) + 1}",
                                              style: TextStyle(
                                                color: selectedFiles
                                                        .contains(path[index])
                                                    ? Colors.white
                                                    : Colors.transparent,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      }),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class VideoWidget extends StatefulWidget {
  final AssetEntity asset;

  VideoWidget(this.asset);

  @override
  _VideoWidgetState createState() => _VideoWidgetState();
}

class _VideoWidgetState extends State<VideoWidget>
    with AutomaticKeepAliveClientMixin {
  late VideoPlayerController _controller;
  bool _isControllerInitialized = false;
  String videoDuration = '';
  @override
  void initState() {
    super.initState();
    _loadVideo();
  }

  void _loadVideo() async {
    final file = await widget.asset.file;
    if (file != null) {
      _controller = VideoPlayerController.file(File(file.path));
      await _controller.initialize();
      _controller.play(); // Bắt đầu phát video
      _controller.addListener(() {
        if (_controller.value.isInitialized &&
            _controller.value.duration != null) {
          setState(() {
            videoDuration = _formatDuration(_controller.value.position);
          });
        }
      });

      setState(() {
        _isControllerInitialized = true;
      });
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }


  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return "$twoDigitMinutes:$twoDigitSeconds";
  }

  void _handleTap() {

  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return GestureDetector(
      onTap: _handleTap,
      child: _isControllerInitialized
          ? AspectRatio(
        aspectRatio: 10 / 10,
        child: Stack(
          children: [
            Positioned.fill(
              child: VideoPlayer(_controller),
            ),
            Align(
              alignment: Alignment.bottomRight,
              child: Container(
                margin: EdgeInsets.all(2),
                padding:
                EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Khoảng cách giữa biểu tượng và thời lượng
                    Text(
                      videoDuration,
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      )
          : Container(),
    );
  }

  @override
  bool get wantKeepAlive => true; // Giữ lại trạng thái của widget khi scroll
}
