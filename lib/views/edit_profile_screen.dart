import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:instagram_flutter/models/user.dart';
import 'package:instagram_flutter/models/user_edit.dart';
import 'package:instagram_flutter/services/authService.dart';
import 'package:instagram_flutter/services/usersevice.dart';
import 'package:instagram_flutter/utils/global.dart';
import 'package:instagram_flutter/views/add_avatar_screen.dart';
import 'package:intl/intl.dart';

class EditProfileScreen extends StatefulWidget {
  final File? selectedAvatar;

  EditProfileScreen({this.selectedAvatar, Key? key}) : super(key: key);

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final nameController = TextEditingController();
  final usernameController = TextEditingController();
  final bioController = TextEditingController();
  final genderController = TextEditingController();
  final birthdayController = TextEditingController();

  String? _avatar;
  late User globalUser;

  @override
  void initState() {
    super.initState();
    globalUser = Global.user!;
    nameController.text = globalUser.full_name;
    usernameController.text = globalUser.username;
    bioController.text = globalUser.bio;

    String gender = globalUser.gender ? 'Male' : 'Female';
    genderController.text = gender;
    String formattedBirthday =
        DateFormat('yyyy-MM-dd').format(globalUser.birthday);
    birthdayController.text = formattedBirthday;

    if (widget.selectedAvatar != null) {
      _avatar = widget.selectedAvatar!.path;
    } else {
      _avatar = globalUser.avatar.isEmpty
          ? 'https://instagram.fixc1-9.fna.fbcdn.net/v/t51.2885-19/44884218_345707102882519_2446069589734326272_n.jpg?_nc_ht=instagram.fixc1-9.fna.fbcdn.net&_nc_cat=1&_nc_ohc=TokSSzUDPVcQ7kNvgGMF0u_&edm=AJ9x6zYBAAAA&ccb=7-5&ig_cache_key=YW5vbnltb3VzX3Byb2ZpbGVfcGlj.2-ccb7-5&oh=00_AYCetGx_2KnUphpAbrzv_kkxLPaX07mcXeJxPNOXkBSYIg&oe=6648F00F&_nc_sid=65462d'
          : globalUser.avatar;
    }
  }

  DateTime convertDateFormat(String date) {
    try {
      DateFormat inputFormat = DateFormat("yyyy-MM-dd");
      DateTime parsedDate = inputFormat.parse(date);

      DateFormat outputFormat = DateFormat("yyyy-MM-dd'T'HH:mm:ss'Z'");
      String formattedDate = outputFormat.format(parsedDate);

      DateTime result = DateTime.parse(formattedDate);
      return result;
    } catch (e) {
      return DateTime.now();
    }
  }

  void handleSaveProfile() async {
    DateTime fomttedBirthday = convertDateFormat(birthdayController.text);
    String covert = genderController.text == 'Male' ? 'true' : 'false';
    bool formattedGender = bool.parse(covert);

    UserEdit userEdit = UserEdit(
        name: nameController.text,
        username: usernameController.text,
        bio: bioController.text,
        avatar: _avatar!,
        birthday: fomttedBirthday,
        gender: formattedGender);

    bool result = await UserService().editUser(userEdit);
    if (result) {
      print('Edit success');
    } else {
      print('Edit fail');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Edit Profile',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: <Widget>[
          GestureDetector(
            onTap: handleSaveProfile,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Icon(
                Icons.check,
                size: 30,
                color: Colors.blue,
              ),
            ),
          ),
        ],
      ),
      body: Container(
        padding: EdgeInsets.only(left: 15, top: 20, right: 15),
        child: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: ListView(
            children: [
              Center(
                child: Stack(
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => AddAvatarScreen(),
                          ),
                        );
                      },
                      child: Container(
                        width: 130,
                        height: 130,
                        decoration: BoxDecoration(
                          border: Border.all(
                            width: 4,
                            color: Colors.white,
                          ),
                          boxShadow: [
                            BoxShadow(
                              spreadRadius: 2,
                              blurRadius: 10,
                              color: Colors.black.withOpacity(0.1),
                            ),
                          ],
                          shape: BoxShape.circle,
                          image: DecorationImage(
                            fit: BoxFit.cover,
                            image: _avatar != null
                                ? _avatar!.startsWith('http')
                                    ? NetworkImage(_avatar!)
                                    : FileImage(File(_avatar!))
                                        as ImageProvider<Object>
                                : AssetImage('assets/default_avatar.jpg'),
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                        height: 40,
                        width: 40,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            width: 4,
                            color: Colors.white,
                          ),
                          color: Colors.blue,
                        ),
                        child: Icon(
                          Icons.edit,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 30,
              ),
              buildTextField('Name', 'Name', nameController),
              buildTextField('Username', 'Username', usernameController),
              buildTextField('Bio', 'Bio', bioController),
              buildCheckField('Male', genderController),
              buildSelectTime('Birthday', birthdayController),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildTextField(
      String labelText, String placeholder, TextEditingController controller) {
    return Padding(
      padding: EdgeInsets.only(bottom: 30),
      child: TextField(
        controller: controller,
        style: TextStyle(
            fontSize: 16, fontWeight: FontWeight.w400, color: Colors.black87),
        decoration: InputDecoration(
          contentPadding: EdgeInsets.only(bottom: 5),
          labelText: labelText,
          labelStyle: TextStyle(
              color: Colors.grey, fontSize: 15, fontWeight: FontWeight.bold),
          floatingLabelBehavior: FloatingLabelBehavior.always,
          hintText: placeholder,
          hintStyle: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w400,
            color: Colors.grey,
          ),
          border: UnderlineInputBorder(
            // Set border to underline
            borderSide: BorderSide(color: Colors.grey),
          ),
          focusedBorder: UnderlineInputBorder(
            // Set focused border to underline
            borderSide: BorderSide(color: Colors.grey),
          ),
        ),
      ),
    );
  }

  Widget buildCheckField(String labelText, TextEditingController controller) {
    return Container(
      child: Padding(
        padding: EdgeInsets.only(bottom: 30),
        child: GestureDetector(
          onTap: () {
            // Hiển thị showDialog khi người dùng nhấp vào TextField
            showDialog(
              context: context,
              builder: (BuildContext context) {
                // Return the AlertDialog
                return AlertDialog(
                  title: Text(labelText),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            controller.text = "Male";
                          });
                          Navigator.of(context).pop();
                        },
                        child: Text("Male"),
                      ),
                      // Tạo nút cho lựa chọn "false"
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            controller.text = "Female";
                          });
                          // Đóng dialog
                          Navigator.of(context).pop();
                        },
                        child: Text("Female"),
                      ),
                    ],
                  ),
                );
              },
            );
          },
          child: AbsorbPointer(
            child: TextFormField(
              controller: controller,
              readOnly: true, // Thiết lập TextFormField chỉ đọc
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w400,
                color: Colors.black87,
              ),
              decoration: InputDecoration(
                contentPadding: EdgeInsets.only(bottom: 5),
                labelText: labelText,
                labelStyle: TextStyle(
                  color: Colors.grey,
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
                floatingLabelBehavior: FloatingLabelBehavior.always,
                hintStyle: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  color: Colors.grey,
                ),
                border: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey),
                ),
                suffixIcon: Icon(
                    Icons.keyboard_arrow_down), // Thêm icon cho phép nhấp vào
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildSelectTime(String labelText, TextEditingController controller) {
    return Container(
      child: Padding(
        padding: EdgeInsets.only(bottom: 30),
        child: TextFormField(
          controller: controller,
          readOnly: true, // Thiết lập TextFormField chỉ đọc
          onTap: () async {
            // Hiển thị DatePicker khi người dùng nhấp vào TextField
            final selectedDate = await showDatePicker(
              context: context,
              initialDate: DateTime.now(), // Ngày ban đầu sẽ là ngày hiện tại
              firstDate:
                  DateTime(1900), // Ngày đầu tiên mà người dùng có thể chọn
              lastDate: DateTime
                  .now(), // Ngày cuối cùng mà người dùng có thể chọn (ngày hiện tại)
              builder: (BuildContext context, Widget? child) {
                return Theme(
                  // Sử dụng theme của ứng dụng
                  data: ThemeData.light().copyWith(
                    // Đặt màu nền cho DatePicker
                    colorScheme: ColorScheme.light(
                      primary: Colors.blue, // Màu chính
                      onPrimary: Colors.white, // Màu chữ trên màu chính
                    ),
                    // Đặt màu chữ cho ngày trong DatePicker
                    textTheme: TextTheme(
                      bodyText1: TextStyle(color: Colors.black),
                    ),
                  ),
                  child: child!,
                );
              },
            );

            // Nếu người dùng chọn một ngày, cập nhật giá trị của controller
            if (selectedDate != null) {
              setState(() {
                // Format ngày để hiển thị trong TextField
                final formattedDate =
                    DateFormat('yyyy-MM-dd').format(selectedDate);
                controller.text = formattedDate;
              });
            }
          },
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w400,
            color: Colors.black87,
          ),
          decoration: InputDecoration(
            contentPadding: EdgeInsets.only(bottom: 5),
            labelText: labelText,
            labelStyle: TextStyle(
              color: Colors.grey,
              fontSize: 15,
              fontWeight: FontWeight.bold,
            ),
            floatingLabelBehavior: FloatingLabelBehavior.always,
            hintStyle: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w400,
              color: Colors.grey,
            ),
            border: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.grey),
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.grey),
            ),
            suffixIcon: Icon(Icons.calendar_today),
          ),
        ),
      ),
    );
  }
}
