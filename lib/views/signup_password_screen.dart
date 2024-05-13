import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:instagram_flutter/models/user_register.dart';
import 'package:instagram_flutter/views/login_screen.dart';
import 'package:instagram_flutter/views/signup_name_screen.dart';

class SignupPasswordScreen extends StatefulWidget {
  final UserRegister userRegister;
  const SignupPasswordScreen(this.userRegister, {Key? key}) : super(key: key);

  @override
  State<SignupPasswordScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupPasswordScreen> {
  bool _obscureTextPassword = true;

  void _togglePasswordVisibility() {
    setState(() {
      _obscureTextPassword = !_obscureTextPassword;
    });
  }

  bool passwordClicked = false;

  final password = TextEditingController();
  FocusNode password_F = FocusNode();

  final passwordConfirm = TextEditingController();
  FocusNode passwordConfirm_F = FocusNode();

  UserRegister _user = UserRegister( email: '', password: '', username: '', name: '', phone: '', birthday: DateTime.now());


  void HanldeRegister  () async {

    bool isValid = ValidateInput(password.text, 'Password').isEmpty;

    if(isValid) {
      _user.email = widget.userRegister.email;
      _user.username = widget.userRegister.username;
      _user.phone = widget.userRegister.phone;
      _user.name = widget.userRegister.name;
      _user.birthday = widget.userRegister.birthday;
      _user.password = password.text;

      Navigator.push(context,
          MaterialPageRoute(builder: (context) => SignupNameScreen(_user)));
    }else{
      setState(() {
        passwordClicked = ValidateInput(password.text, 'Password').isNotEmpty;
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
                    SizedBox(height: 15.h),
                    contentCreateAPassword(),
                    SizedBox(height: 30.h),
                    passwordField(password, Icons.lock, 'Password', password_F,
                        _obscureTextPassword, _togglePasswordVisibility),

                    SizedBox(height: 20.h),
                    Next(onTap: HanldeRegister),
                    SizedBox(height: 440.h),
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
        child:Text(
          'Create a Password',
          style: TextStyle(
            fontSize: 23.sp,
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }


  Widget iconBackArrow(){
    return AppBar(
      backgroundColor: Colors.transparent, // Make the app bar transparent
      elevation: 0, // Remove shadow
      leading: IconButton(
        icon: Icon(FontAwesomeIcons.arrowLeft, color: Colors.black87, size: 18), // FontAwesome icon
        onPressed: () {
          Navigator.of(context).pop(); // Navigate back
        },
        color: Colors.black, // Set icon color
      ),
    );
  }

  Widget contentCreateAPassword(){
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          'Create a password with at least 6 letters or numbers. It should be something others cant guess.',
          textAlign: TextAlign.left, // Align the text to the left
          style: TextStyle(
            fontSize: 13.sp,
            color: Colors.black87,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  String ValidateInput(String value, String type) {
    if (value.isEmpty) {
      return 'Please enter $type';
    }
    if (type == 'Password' && value.length < 8 && value.length > 21 ) {
      return 'Username must be at least 8 characters';
    }

    if (!RegExp(r'[A-Z]').hasMatch(value)) {
      return 'Password must contain at least 1 uppercase letter';
    }
    if (!RegExp(r'[a-z]').hasMatch(value)) {
      return 'Password must contain at least 1 lowercase letter';
    }
    if (!RegExp(r'[0-9]').hasMatch(value)) {
      return 'Password must contain at least 1 number';
    }
    if (!RegExp(r'[!@#\$&*~]').hasMatch(value)) {
      return 'Password must contain at least 1 special character';
    }
    return '';
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
                  passwordClicked = false;
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
          if (passwordClicked)
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
