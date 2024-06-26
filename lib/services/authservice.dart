import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:instagram_flutter/models/response/user_response.dart';
import 'package:instagram_flutter/models/user.dart';
import 'package:instagram_flutter/models/user_edit.dart';
import 'package:instagram_flutter/models/user_login.dart';
import 'package:instagram_flutter/models/user_register.dart';
import 'package:instagram_flutter/utils/const.dart';
import 'package:instagram_flutter/utils/global.dart';
import 'package:mime/mime.dart';
import '../models/response/responsedata.dart';

class AuthService {
  //AuthService();

  Future<UserResponse> login(UserLogin userLogin) async {
    UserResponse userResponse = UserResponse();

    Map<String, String> param = {
      'username': userLogin.username,
      'password': userLogin.password,
      'platform': 'Flutter',
    };

    try {
      final url = Uri.parse('$urlBase/auth/login');
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(param),
      );

      if (response.statusCode == 200) {
        final user = User.fromJson(jsonDecode(response.body)['data']);
        userResponse.user = user;
        userResponse.status = jsonDecode(response.body)['code'];
      } else {
        userResponse.message = jsonDecode(response.body)['message'];
        return userResponse;
      }
    } catch (e) {
      userResponse.message = e.toString();
    }

    return userResponse;
  }

  Future<ResponseData> register(UserRegister userRegister) async {
    ResponseData result = ResponseData(message: '');

    Map<String, String> param = {
      'username': userRegister.username,
      'email': userRegister.email,
      'password': userRegister.password,
      'full_name': userRegister.name,
      'phone': userRegister.phone,
      'birthday': userRegister.birthday.toIso8601String(),
      'platform': 'Flutter',
    };

    try {
      final url = Uri.parse('$urlBase/auth/register');
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(param),
      );

      final jsonData = jsonDecode(response.body);
      int code = jsonData['code'];
      String message = jsonData['message'];
      dynamic data = jsonData['data'];
      if (code == 201) {
        String? authToken = data['token'];
        if (authToken != null) {
          result.status = 201;
          result.message = message;
          result.data = authToken;
        } else {
          result.message = 'Missing authentication token';
        }
      } else {
        result.status = code;
        result.message = message;
      }
    } catch (e) {
      result.message = e.toString();
    }
    return result;
  }


  Future<bool> verify(String token) async {
    bool result = false;
    try {
      final url = Uri.parse('$urlBase/auth/verify');
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization' : 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        result = true;
      } else {
        result = false;
      }
    } catch (e) {
      print('Error during verification: $e');
      result = false;
    }
    return result;
  }


}
