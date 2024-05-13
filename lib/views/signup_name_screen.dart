import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:instagram_flutter/models/user_register.dart';
import 'package:instagram_flutter/views/login_screen.dart';
import 'package:instagram_flutter/views/signup_birthday_screen.dart';

class SignupNameScreen extends StatefulWidget {
  final UserRegister userRegister;
  const SignupNameScreen(this.userRegister, {Key? key}) : super(key: key);

  @override
  State<SignupNameScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupNameScreen> {
  final fullname = TextEditingController();
  FocusNode fullname_F = FocusNode();

  UserRegister _user = UserRegister(
      email: '',
      password: '',
      username: '',
      name: '',
      phone: '',
      birthday: DateTime.now());
  bool fullnameClicked = false;

  void HanldeRegister() async {
    bool isValid = ValidateInput(fullname.text, 'Full name').isEmpty;

    if (isValid) {
      _user.email = widget.userRegister.email;
      _user.username = widget.userRegister.username;
      _user.phone = widget.userRegister.phone;
      _user.name = fullname.text;
      _user.birthday = widget.userRegister.birthday;
      _user.password = widget.userRegister.password;

      Navigator.push(context,
          MaterialPageRoute(builder: (context) => SignupBirthdayScreen(_user)));
    } else {
      setState(() {
        fullnameClicked = ValidateInput(fullname.text, 'Full name').isNotEmpty;
      });
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
                    iconBackArrow(),
                    Title(),
                    SizedBox(height: 25.h),
                    Textfield(fullname, Icons.email, 'Full name', fullname_F),
                    SizedBox(height: 20.h),
                    Next(onTap: HanldeRegister),
                    SizedBox(height: 510.h),
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

  Widget Next({required VoidCallback onTap}) {
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

  Widget Title() {
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: Text(
          'What\'s your name ?',
          style: TextStyle(
            fontSize: 23.sp,
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget iconBackArrow() {
    return AppBar(
      backgroundColor: Colors.transparent, // Make the app bar transparent
      elevation: 0, // Remove shadow
      leading: IconButton(
        icon: Icon(FontAwesomeIcons.arrowLeft,
            color: Colors.black87, size: 18), // FontAwesome icon
        onPressed: () {
          Navigator.of(context).pop(); // Navigate back
        },
        color: Colors.black, // Set icon color
      ),
    );
  }

  String ValidateInput(String value, String type) {
    if (value.isEmpty) {
      return 'Please enter $type';
    }
    if (type == 'Full name' && (value.length < 3 || value.length > 50)) {
      return 'Full name must be between 3 and 50 characters long';
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
                  fullnameClicked = false;
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
          if (fullnameClicked) // Conditionally display the validation message
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
