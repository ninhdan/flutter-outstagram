
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:instagram_flutter/models/user.dart';
import 'package:instagram_flutter/utils/global.dart';
import 'package:instagram_flutter/views/login_screen.dart';
import 'package:instagram_flutter/views/widgets/navigation.dart';
import 'package:shared_preferences/shared_preferences.dart';
enum AuthStatus {
  notSignedIn,
  signedIn,
}

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  AuthStatus authStatus = AuthStatus.notSignedIn;
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  @override
  void initState() {
    Global.myStream!.counterStream.listen((event) {
      if(event){
        _updateAuthStatus(AuthStatus.notSignedIn);
      }
    });

    //read from local storages
    final user = _prefs.then((SharedPreferences prefs) {
      var json = prefs.getString('user');
      if(json == null){
        _updateAuthStatus(AuthStatus.notSignedIn);
        return null;
      }
      Map<String, dynamic> userJson = jsonDecode(json);
     final tempUser = User.formJsonMap(userJson);
      Global.user = tempUser;
      _updateAuthStatus(AuthStatus.signedIn);

      return tempUser;
    });
    super.initState();
  }



  void _updateAuthStatus(AuthStatus status) {
    setState(() {
      authStatus = status;
    });
  }

  @override
  Widget build(BuildContext context) {
    switch (authStatus) {
      case AuthStatus.notSignedIn:
        return LoginScreen(
          onSignedIn: () {
            _updateAuthStatus(AuthStatus.signedIn);
          },
        );
      case AuthStatus.signedIn:
        return const Navigations_Screen();
    }
  }
}
