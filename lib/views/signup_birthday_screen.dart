import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_rounded_date_picker/flutter_rounded_date_picker.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
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
  final birthday = TextEditingController(
      text: DateFormat('yyyy-MM-dd').format(DateTime.now()));
  FocusNode birthday_F = FocusNode();
  String ageLabel = 'Birthday (0 years old)';

  bool? isChecked = false;
  UserRegister _user = UserRegister(
      email: '',
      password: '',
      username: '',
      name: '',
      phone: '',
      birthday: DateTime.now());
  DateTime convertDateFormat(String date) {
    try {
      DateFormat inputFormat = DateFormat("yyyy-MM-dd");
      DateTime parsedDate = inputFormat.parse(date);

      DateFormat outputFormat = DateFormat("yyyy-MM-dd'T'HH:mm:ss'Z'");
      String formattedDate = outputFormat.format(parsedDate);

      DateTime result = DateTime.parse(formattedDate);
      return result;
    } catch (e) {
      print("Error converting date: $e");
      return DateTime.now(); // Return current date as fallback
    }
  }

  void HanldeRegister() async {
    _user.email = widget.userRegister.email;
    _user.username = widget.userRegister.username;
    _user.phone = widget.userRegister.phone;
    _user.name = widget.userRegister.name;
    _user.birthday = convertDateFormat(birthday.text);
    _user.password = widget.userRegister.password;

    ResponseData responseData = await AuthService().register(_user);

    if (responseData.status == 201) {
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => LoginScreen(onSignedIn: () {})));
    } else {
      print(responseData.message);
      print(responseData.status);
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
                    contentBirthday(),
                    SizedBox(height: 30.h),
                    Textfield(birthday, ageLabel, birthday_F),
                    SizedBox(height: 10.h),
                   agree(),
                    SizedBox(height: 10.h),
                    Login(onTap: HanldeRegister),
                    SizedBox(height: 400.h),
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

  Widget Title() {
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: Text(
          'What\'s your birthday?',
          style: TextStyle(
            fontSize: 23.sp,
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget agree(){
    return  Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Checkbox(
            value: isChecked,
            onChanged: (bool? value) {
              setState(() {
                isChecked = value ?? false;
              });
            },
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(4), // Set the border radius to zero
            ),
            fillColor: MaterialStateProperty.resolveWith<Color>(
                  (Set<MaterialState> states) {
                if (states.contains(MaterialState.selected)) {
                  return Color(0xFF0030EF); // Set the background color when the checkbox is selected
                }
                return Colors.transparent; // Set the background color when the checkbox is not selected
              },
            ),
          ),
          Text(
            'I agree to outstagram\'s terms and policies',
            style: TextStyle(
              fontSize: 13.sp,
              fontWeight: FontWeight.normal,
              color: Color(0xFF0030EF),
            ),
          ),
        ],
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

  Widget contentBirthday() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          'Use your own birthday, even if this account is for a business, a pet, or something else. No one will see this unless you share it.',
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
            _selectDate(context, controller);
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

  Future<void> _selectDate(
      BuildContext context, TextEditingController controller) async {
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
    if (picked != null) {
      setState(() {
        final formattedDate = _getDisplayDate(picked); // Format the picked date
        controller.text = formattedDate;
        DateTime now = DateTime.now();
        int age = now.year - picked.year;
        if (now.month < picked.month ||
            (now.month == picked.month && now.day < picked.day)) {
          age--;
        }

        // Update the age label
        ageLabel = 'Birthday ($age years old)';
      });
    }
  }

  String _getDisplayDate(DateTime date) {
    return DateFormat("yyyy-MM-dd").format(date);
  }
}
