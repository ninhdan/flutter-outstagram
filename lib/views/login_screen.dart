import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:email_validator/email_validator.dart';
import 'package:instagram_flutter/models/response/user_response.dart';
import 'package:instagram_flutter/models/user_login.dart';
import 'package:instagram_flutter/services/authService.dart';
import 'package:instagram_flutter/utils/global.dart';
import 'package:instagram_flutter/views/signup_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  final VoidCallback onSignedIn;

  LoginScreen({Key? key, required this.onSignedIn}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _obscureTextPassword = true;

  final username = TextEditingController();
  FocusNode username_F = FocusNode();
  final password = TextEditingController();
  FocusNode password_F = FocusNode();
  final UserLogin _user = UserLogin(username: '', password: '');

  bool loginUsernameClicked = false;
  bool loginPasswordClicked = false;

  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  void _togglePasswordVisibility() {
    setState(() {
      _obscureTextPassword = !_obscureTextPassword;
    });
  }

  void handleLogin() async {
    setState(() {
      if (username.text.isEmpty) {
        loginUsernameClicked = true;
      } else {
        loginUsernameClicked = false;
      }

      if (password.text.isEmpty) {
        loginPasswordClicked = true;
      } else {
        loginPasswordClicked = false;
      }
    });

    _user.username = username.text;
    _user.password = password.text;


    if (!loginUsernameClicked && !loginPasswordClicked) {
      UserResponse userResponse = await AuthService().login(_user);

      if (userResponse.status == 200) {
        Global.user = userResponse.user;
        widget.onSignedIn();
        final SharedPreferences prefs = await _prefs;
        final json = jsonEncode(userResponse.user!.toJson());
        final _counter = prefs.setString('user', json).then((bool success) {
          return 0;
        });

      } else {
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text('Login Error',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              content: const Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Divider(
                    height: 1,
                    thickness: 1,
                    color: Color(0xFFD4D9DF),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Username, Email, mobile phone or Password is incorrect, Please check again!',
                    style: TextStyle(
                        fontWeight: FontWeight.normal, color: Colors.red),
                  ),
                ],
              ),
              actions: [
                const Divider(
                  height: 1,
                  thickness: 1,
                  color: Color(0xFFD4D9DF),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text(
                    'Cancel',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                      color: Colors.grey,
                    ),
                  ),
                ),
              ],
            );
          },
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Stack(
          children: [
            Container(
              width: double.infinity,
              height: double.infinity,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topRight,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color(0xFFFAF7F2),
                    Color(0xFFF2FBF6),
                    Color(0xFFEDF4FE),
                  ],
                ),
              ),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    SizedBox(
                      width: 96.w,
                      height: 110.h,
                    ),
                    Center(
                      child:
                          Image.asset('assets/images/instagramlogosplash.png'),
                    ),
                    SizedBox(height: 90.h),
                    Textfield(username, Icons.email,
                        'Username, email or mobile number', username_F),
                    SizedBox(height: 15.h),
                    passwordField(password, Icons.lock, 'Password', password_F,
                        _obscureTextPassword, _togglePasswordVisibility),
                    SizedBox(height: 10.h),
                    Login(onTap: handleLogin),
                    SizedBox(height: 10.h),
                    Forgot(),
                    SizedBox(height: 220.h),
                    Have(),
                    SizedBox(height: 10.h),
                    FacebookMeta(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget Login({required VoidCallback onTap}) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 15.w),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          alignment: Alignment.center,
          width: double.infinity,
          height: 44.h,
          decoration: BoxDecoration(
            color: Color(0xFF0000F6),
            borderRadius: BorderRadius.circular(20.r),
          ),
          child: Text(
            'Log In',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18.sp,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ),
    );
  }

  Widget FacebookMeta() {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            FontAwesomeIcons.meta,
            color: Color(0xFF374856),
            size: 15,
          ),
          SizedBox(width: 7), // Khoảng cách giữa văn bản và biểu tượng
          Text(
            'Meta',
            style: TextStyle(
              fontSize: 15,
              color: Color(0xFF374856),
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget Have() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 15.w),
      child: GestureDetector(
        onTap: () {
          Navigator.pushReplacement(
            context,
            PageRouteBuilder(
              pageBuilder: (context, animation, secondaryAnimation) =>
                  SignupScreen(widget.onSignedIn),
              transitionsBuilder:
                  (context, animation, secondaryAnimation, child) {
                var begin = Offset(1.0, 0.0);
                var end = Offset.zero;
                var curve = Curves.ease;
                var tween = Tween(begin: begin, end: end)
                    .chain(CurveTween(curve: curve));
                var offsetAnimation = animation.drive(tween);
                return SlideTransition(
                  position: offsetAnimation,
                  child: child,
                );
              },
            ),
          );
        },
        child: Container(
          alignment: Alignment.center,
          width: double.infinity,
          height: 44.h,
          decoration: BoxDecoration(
            color: Colors.transparent,
            border: Border.all(color: const Color(0xFF0000F6), width: 1.3),
            borderRadius: BorderRadius.circular(20.r),
          ),
          child: Text(
            'Create new account',
            style: TextStyle(
              color: Color(0xFF0000F6),
              fontSize: 15.sp,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }

  Widget Forgot() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Forgot password?',
            style: TextStyle(
              fontSize: 14.sp,
              color: const Color(0xFF485458),
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  bool isPhoneNumber(String value) {
    if (value.isEmpty) {
      return false;
    }
    if (value.length < 10 || value.length > 12) {
      return false;
    }
    if (!RegExp(
            r'^\s*(?:\+?(\d{1,3}))?[-. (]*(\d{3})[-. )]*(\d{3})[-. ]*(\d{4})(?: *x(\d+))?\s*$')
        .hasMatch(value)) {
      return false;
    }
    return true;
  }

  String ValidateInput(String value, String type) {
    if (value.isEmpty) {
      return 'Please enter $type';
    }
    if (type == 'Email' && !EmailValidator.validate(value)) {
      return 'Please enter a valid email';
    }
    if (type == 'Phone' && !isPhoneNumber(value)) {
      return 'Please enter a valid phone number';
    }

    if (type == 'Password' && value.length < 8) {
      return 'Password must be at least 8 characters long';
    }
    return '';
  }

  Widget Textfield(TextEditingController controller, IconData icon, String type,
      FocusNode focusNode) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 50.h,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(5.r),
            ),
            child: TextField(
              controller: controller,
              focusNode: focusNode,
              onChanged: (value) {
                setState(() {
                  loginUsernameClicked = false;
                });
              },
              style: TextStyle(
                fontSize: 15.sp,
                fontWeight: FontWeight.w600,
              ),
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: type,
                labelStyle: TextStyle(
                    fontSize: 15.sp, // Thiết lập kích thước của nhãn
                    fontWeight: FontWeight.w600, // Thiết lập độ dày của nhãn
                    color: Colors.black45 // Màu của nhãn
                    ),
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 15.w, vertical: 15.h),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: Color(0xFFD4D9DF), width: 1.w),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: Colors.black45, width: 1.w),
                ),
              ),
            ),
          ),
          if (loginUsernameClicked) // Conditionally display the validation message
            Padding(
              padding: EdgeInsets.only(
                  left: 20.w, top: 5.h), // Adjust padding as needed
              child: Text(
                ValidateInput(controller.text, type),
                style: TextStyle(
                  fontSize: 11.sp,
                  color: Colors.red,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget passwordField(
    TextEditingController controller,
    IconData icon,
    String hintText,
    FocusNode focusNode,
    bool obscureTextLocal,
    VoidCallback? toggleVisibility,
  ) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 50.h,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(5.r),
            ),
            child: TextField(
              controller: controller,
              focusNode: focusNode,
              obscureText: obscureTextLocal,
              onChanged: (value) {
                setState(() {
                  loginPasswordClicked = false;
                });
              },
              style: TextStyle(
                fontSize: 15.sp,
                fontWeight: FontWeight.w600,
              ),
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: hintText,
                labelStyle: TextStyle(
                    fontSize: 15.sp, // Thiết lập kích thước của nhãn
                    fontWeight: FontWeight.w600, // Thiết lập độ dày của nhãn
                    color: Colors.black45 // Màu của nhãn
                    ),
                suffixIcon: IconButton(
                  icon: Icon(obscureTextLocal
                      ? Icons.visibility
                      : Icons.visibility_off),
                  onPressed: toggleVisibility,
                ),
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 15.w, vertical: 15.h),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: Color(0xFFD4D9DF), width: 1.w),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: Colors.black45, width: 1.w),
                ),
              ),
            ),
          ),
          if (loginPasswordClicked)
            Padding(
              padding: EdgeInsets.only(left: 20.w, top: 5.h),
              child: Text(
                ValidateInput(controller.text, hintText),
                style: TextStyle(
                  fontSize: 11.sp,
                  color: Colors.red,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
