import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';


class CachedImage extends StatelessWidget {
  String? imageURL;
  CachedImage(this.imageURL, {super.key});

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      fit: BoxFit.cover,
      imageUrl: imageURL!,
      progressIndicatorBuilder: (context, url, progress) {
        return Container(
          child: Padding(
            padding: EdgeInsets.all(100.h),
            child: SpinKitFadingCircle(
              // value: progress.progress,
              color: Colors.blueAccent,
              size: 100.0,
            ),
          ),
        );
      },
      errorWidget: (context, url, error) => Container(
        color: Colors.amber,
      ),
    );
  }
}