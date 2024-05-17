import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:instagram_flutter/models/user.dart';
import 'package:instagram_flutter/utils/global.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Slide extends StatelessWidget {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  User user;
  Slide(this.user);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          UserAccountsDrawerHeader(
            decoration: BoxDecoration(color: const Color(0xfffff)),
            accountName: Text(
              user.username,
              style:
                  TextStyle(fontWeight: FontWeight.w400, color: Colors.black),
            ),
            accountEmail: Text(
              user.email,
              style: const TextStyle(
                  fontWeight: FontWeight.w400, color: Colors.black),
            ),
            currentAccountPicture:
                Image.asset("assets/images/instagramlogosplash.png"),
          ),
          InkWell(
            onTap: () {
              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: const Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Center(
                          child: Text(
                            'Log out \n of your account?',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        SizedBox(height: 15),
                        Divider(
                          height: 1,
                          thickness: 1,
                          color: Color(0xFFD4D9DF),
                        ),
                      ],
                    ),
                    content: GestureDetector(
                      onTap: () async {
                        final SharedPreferences prefs = await _prefs;
                        final success = await prefs.remove('user');
                        Global.myStream!.signOut();
                        Navigator.pop(context);
                      },
                      child: const Text(
                        'Logout',
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 18,
                          color: Color(0xFF0C92127),
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    actions: <Widget>[
                      const Divider(
                        height: 1,
                        thickness: 1,
                        color: Color(0xFFD4D9DF),
                      ),
                      Center(
                        child: TextButton(
                          onPressed: () => Navigator.pop(context, 'Cancel'),
                          child: const Text(
                            'Cancel',
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 19,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                      )
                    ],
                  );
                },
              );
            },
            child: Column(
              children: [
                ListTile(
                  leading: Icon(
                    FontAwesomeIcons.signOutAlt,
                    size: 25,
                    color: Color(0xFF0C92127),
                  ),
                  title: Text(
                    'Logout',
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 18,
                      color: Color(0xFF0C92127),
                    ),
                  ),
                ),
                if (user.role)
                  ListTile(
                    leading: Icon(
                      FontAwesomeIcons.lock,
                      size: 25,
                      color: user.active ? Colors.red : Colors.grey,
                    ),
                    title: user.active
                        ? Text(
                            'Deactivate Account',
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 18,
                              color: Colors.grey,
                            ),
                          )
                        : Text(
                            'Activate Account',
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 18,
                              color: Colors.grey,
                            ),
                          ),
                    onTap: () {
                      if (user.active) {

                      } else {

                      }
                    },
                  ),

                if(user.role)
                  ListTile(
                    leading: Icon(
                      FontAwesomeIcons.trash,
                      size: 25,
                      color: Colors.red, // Màu đỏ cho biểu tượng xóa tài khoản
                    ),
                    title: Text(
                      'Delete Account',
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 18,
                        color: Colors.red, // Màu đỏ cho tiêu đề
                      ),
                    ),
                    onTap: () {
                      // Xử lý khi người dùng nhấn vào tùy chọn xóa tài khoản
                    },
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
