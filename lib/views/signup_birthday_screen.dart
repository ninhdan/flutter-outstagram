import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rounded_date_picker/flutter_rounded_date_picker.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:instagram_flutter/models/response/responsedata.dart';
import 'package:instagram_flutter/models/user_register.dart';
import 'package:instagram_flutter/services/authService.dart';
import 'package:instagram_flutter/views/login_screen.dart';
import 'package:intl/intl.dart';

class SignupBirthdayScreen extends StatefulWidget {
  final UserRegister userRegister;
  const SignupBirthdayScreen(this.userRegister, {Key? key}) : super(key: key);

  @override
  State<SignupBirthdayScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupBirthdayScreen> {
  final birthday = TextEditingController();
  FocusNode birthday_F = FocusNode();

  UserRegister _user = UserRegister(
      email: '',
      password: '',
      username: '',
      name: '',
      phone: '',
      birthdate: DateTime.now());

  void HanldeRegister() async {
    _user.email = widget.userRegister.email;
    _user.username = widget.userRegister.username;
    _user.phone = widget.userRegister.phone;
    _user.name = widget.userRegister.name;
    _user.birthdate = DateTime.parse(birthday.text);
    _user.password = widget.userRegister.password;

    ResponseData responseData = await AuthService().register(_user);
    if (responseData.status == 200) {
      //Navigator.push(context, MaterialPageRoute(builder: (context) => LoginScreen(onSignedIn: (){}));

      print(responseData.message);
    } else {
      //ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(responseData.message)));
      print(responseData.message);
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
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color(0xFFFAF7F2), // Màu #FAF7F2 ở giữa
                    Color(0xFFF2FBF6), // Màu #F2FBF6 ở dưới
                    Color(0xFFEDF4FE), // Màu #EDF4FE ở trên
                  ],
                ),
              ),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    SizedBox(
                      width: 96.w,
                      height: 30.h,
                    ),
                    Center(
                      child: Image.asset('assets/images/instagramnamelogo.png',
                          width: 160.w, height: 50.h),
                    ),
                    SizedBox(height: 25.h),
                    Center(
                      child: Text(
                          'Sign up to see photos and videos \nfrom your friends.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 15.sp,
                            color: Colors.black45,
                            fontWeight: FontWeight.bold,
                          )),
                    ),
                    SizedBox(height: 10.h),
                    LoginFacebook(),
                    SizedBox(height: 20.h),
                    DividerOR(),
                    SizedBox(height: 20.h),
                    Textfield(birthday, 'Birthday', birthday_F),
                    SizedBox(height: 20.h),
                    Login(onTap: HanldeRegister),
                    SizedBox(height: 150.h),
                    Have(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget Have() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 15.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          GestureDetector(
            onTap: () {
              Navigator.of(context).pushReplacement(PageRouteBuilder(
                pageBuilder: (context, animation, secondaryAnimation) =>
                    LoginScreen(onSignedIn: () {}),
                transitionsBuilder:
                    (context, animation, secondaryAnimation, child) {
                  var begin = Offset(-1.0, 0.0);
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
              ));
            },
            child: Text(
              "Already have account",
              style: TextStyle(
                fontSize: 13.sp,
                color: Color(0xFF0165E2),
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget DividerOR() {
    return Row(
      children: [
        Expanded(
          child: Divider(
            height: 1, // Độ dày của đường ngang
            thickness: 1, // Độ dày của đường ngang
            color: Color(0xFFD4D9DF),
            indent: 20, // Khoảng cách từ lề trái
            endIndent: 20, // Khoảng cách từ lề phải
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Text(
            'OR',
            style: TextStyle(
              fontSize: 15.sp,
              color: Colors.black54,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Expanded(
          child: Divider(
            height: 1, // Độ dày của đường ngang
            thickness: 1, // Độ dày của đường ngang
            color: Color(0xFFD4D9DF),
            indent: 20, // Khoảng cách từ lề trái
            endIndent: 20, // Khoảng cách từ lề phải
          ),
        ),
      ],
    );
  }

  Widget LoginFacebook() {
    return Padding(
        padding: EdgeInsets.symmetric(horizontal: 15.w),
        child: Container(
          alignment: Alignment.center,
          width: double.infinity,
          height: 44.h,
          decoration: BoxDecoration(
            color: Color(0xFF0165E2),
            borderRadius: BorderRadius.circular(10.r),
          ),
          child: Text('Login with Facebook',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18.sp,
                fontWeight: FontWeight.w600,
              )),
        ));
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
            color: Color(0xFF0165E2),
            borderRadius: BorderRadius.circular(20.r),
          ),
          child: Text(
            'Sign Up',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }

  Widget Textfield(
      TextEditingController controller, String type, FocusNode focusNode) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Container(
        height: 50.h,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(5.r),
        ),
        child: TextField(
          controller: controller,
          focusNode: focusNode,
          onTap: () {
            _selectDate(context);
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
              borderSide: BorderSide(color: Color(0xFF9FA7B6), width: 1.w),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showRoundedDatePicker(
      context: context,
      theme: ThemeData(primarySwatch: Colors.blue),
      styleDatePicker: MaterialRoundedDatePickerStyle(
        textStyleDayHeader: TextStyle(
          fontSize: 24,
          color: Colors.white,
        ),
      ),
      imageHeader: AssetImage("assets/images/cfhgyu2.jpeg"),
      description:
          "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.",
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(DateTime.now().year + 1),
      height: 300,
    );
    if (picked != null && picked != _user.birthdate)
      setState(() {
        _user.birthdate = picked;
        print(_user.birthdate);
        birthday.text = _user.birthdate.toString();
        print(birthday.text);
      });
  }
}
