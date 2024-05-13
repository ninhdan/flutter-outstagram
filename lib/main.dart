import 'package:flutter/material.dart';
import 'package:instagram_flutter/auth/auth_screen.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:instagram_flutter/stream/mystream.dart';
import 'package:instagram_flutter/utils/global.dart';

void main() {
  Global.myStream = MyStream();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {

    final ThemeData customTheme = ThemeData(
      fontFamily: 'Roboto',
    );

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: customTheme,
      home: const ScreenUtilInit(designSize: Size(375,812),child: AuthPage()),
    );
  }
}
