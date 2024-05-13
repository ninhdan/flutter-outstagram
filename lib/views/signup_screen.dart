import 'package:email_validator/email_validator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:instagram_flutter/models/user_register.dart';
import 'package:instagram_flutter/views/login_screen.dart';
import 'package:instagram_flutter/views/signup_password_screen.dart';

class SignupScreen extends StatefulWidget {
  final VoidCallback show;
  const SignupScreen(this.show, {Key? key}) : super(key: key);

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final email = TextEditingController();
  FocusNode email_F = FocusNode();

  final phone = TextEditingController();
  FocusNode phone_F = FocusNode();

  final username = TextEditingController();
  FocusNode username_F = FocusNode();
  UserRegister _user = UserRegister(
      email: '',
      password: '',
      username: '',
      name: '',
      phone: '',
      birthday: DateTime.now());

  bool nextClickedUsername = false;
  bool nextClickedEmail = false;
  bool nextClickedPhone = false;

  void HanldeRegister() async {
    bool isValid = ValidateInput(email.text, 'Email').isEmpty &&
        ValidateInput(phone.text, 'Mobile Phone').isEmpty &&
        ValidateInput(username.text, 'Username').isEmpty;

    if (isValid) {
      _user.email = email.text;
      _user.username = username.text;
      _user.phone = phone.text;
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => SignupPasswordScreen(_user)));
    } else {
      setState(() {
        nextClickedEmail = ValidateInput(email.text, 'Email').isNotEmpty;
        nextClickedPhone = ValidateInput(phone.text, 'Mobile Phone').isNotEmpty;
        nextClickedUsername = ValidateInput(username.text, 'Username').isNotEmpty;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset : false,
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
                      child: Image.asset(
                        'assets/images/instagramnamelogo.png',
                        width: 160.w,
                        height: 50.h,
                      ),
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
                        ),
                      ),
                    ),
                    SizedBox(height: 10.h),
                    LoginFacebook(),
                    SizedBox(height: 20.h),
                    DividerOR(),
                    SizedBox(height: 20.h),
                    TextfieldEmail(email, 'Email', email_F),
                    SizedBox(height: 15.h),
                    TextfieldPhone(phone, 'Mobile Phone', phone_F),
                    SizedBox(height: 15.h),
                    TextfieldUsername(username, 'Username', username_F),
                    SizedBox(height: 20.h),
                    Next(onTap: HanldeRegister),
                  ],
                ),
              ),
            ),
            Positioned(
              bottom: 20,
              left: 0,
              right: 0,
              child: Container(
                alignment: Alignment.bottomCenter,
                child: Have(),
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

  Widget Next({required VoidCallback onTap}) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 15.w),
      child: GestureDetector(
        onTap: () {
          // Kiểm tra xem có thông báo lỗi nào hiển thị không
          bool hasError = email_F.hasFocus &&
                  ValidateInput(email.text, 'Email').isNotEmpty ||
              phone_F.hasFocus &&
                  ValidateInput(phone.text, 'Phone Mobile').isNotEmpty ||
              username_F.hasFocus &&
                  ValidateInput(username.text, 'Username').isNotEmpty;
          // Nếu không có lỗi nào hiển thị, thực hiện hành động tiếp theo
          if (!hasError) {
            onTap();
          }
        },
        child: Container(
          alignment: Alignment.center,
          width: double.infinity,
          height: 44.h,
          decoration: BoxDecoration(
            color: Color(0xFF0000F6),
            borderRadius: BorderRadius.circular(20.r),
          ),
          child: Text(
            'Next',
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

  bool isPhoneNumber(String value) {
    // Kiểm tra độ dài của chuỗi số điện thoại
    if (value.length < 10 || value.length > 12) {
      return false;
    }
    // Kiểm tra xem giá trị có chứa ký tự khác số không
    if (!RegExp(
            r'^\s*(?:\+?(\d{1,3}))?[-. (]*(\d{3})[-. )]*(\d{3})[-. ]*(\d{4})(?: *x(\d+))?\s*$')
        .hasMatch(value)) {
      return false;
    }
    // Nếu tất cả các điều kiện trên đều đúng, giá trị được xem là số điện thoại hợp lệ
    return true;
  }

  String ValidateInput(String value, String type) {
    if (value.isEmpty) {
      return 'Please enter $type';
    }
    if (type == 'Email' && !EmailValidator.validate(value)) {
      return 'Please enter a valid email';
    }
    if (type == 'Mobile Phone' && !isPhoneNumber(value)) {
      return 'Please enter a valid phone number';
    }

    if (type == 'Username' && value.length < 6 && value.length < 21 ) {
      return 'Username must be at least 6 characters';
    }
    return '';
  }

  Widget TextfieldEmail(
      TextEditingController controller, String type, FocusNode focusNode) {
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
                  nextClickedEmail = false;
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
          if (nextClickedEmail) // Conditionally display the validation message
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

  Widget TextfieldUsername(
      TextEditingController controller, String type, FocusNode focusNode) {
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
                  nextClickedUsername = false;
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
          if (nextClickedUsername) // Conditionally display the validation message
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

  Widget TextfieldPhone(
      TextEditingController controller, String type, FocusNode focusNode) {
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
                  nextClickedPhone = false;
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
          if (nextClickedPhone)
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
}
