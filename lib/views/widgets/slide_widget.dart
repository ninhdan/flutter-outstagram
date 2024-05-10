import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:instagram_flutter/utils/global.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Slide extends StatelessWidget {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          UserAccountsDrawerHeader(
            decoration: BoxDecoration(color: const Color(0xfffff)),
            accountName: Text(
              "Pinkesh Darji",
              style:
                  TextStyle(fontWeight: FontWeight.w400, color: Colors.black),
            ),
            accountEmail: Text(
              "pinkesh.earth@gmail.com",
              style:
                  TextStyle(fontWeight: FontWeight.w400, color: Colors.black),
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
                    title: Column(
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
                          height: 1, // Độ dày của đường ngang
                          thickness: 1, // Độ dày của đường ngang
                          color: Color(0xFFD4D9DF),

                        ),
                      ],
                    ),



                    content: GestureDetector(
                      onTap: () async {
                        final SharedPreferences prefs = await _prefs;
                        //remove data
                        final success = await prefs.remove('auth_token');
                        Global.myStream!.signOut();
                        //Global.cleanData();
                        Navigator.pop(context);

                        //render login
                      },
                      child: Text(
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
                      Divider(
                        height: 1, // Độ dày của đường ngang
                        thickness: 1, // Độ dày của đường ngang
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


            child: ListTile(
              leading: Icon(
                FontAwesomeIcons.signOutAlt,
                size: 25,
                color: Color(0xFF0C92127), // Đặt màu cho biểu tượng
              ),
              title: Text(
                'Logout',
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 18,
                  color: Color(0xFF0C92127), // Đặt màu cho văn bản
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
