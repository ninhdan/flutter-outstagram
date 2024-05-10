import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:instagram_flutter/models/user_login.dart';
import 'package:instagram_flutter/models/user_register.dart';
import 'package:instagram_flutter/utils/const.dart';

import '../models/response/responsedata.dart';

class AuthService {
  Future<ResponseData> login(UserLogin userLogin) async {
    ResponseData responseData = ResponseData();

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
        final jsonData = jsonDecode(response.body);
        int code = jsonData['code'];
        String message = jsonData['message'];
        dynamic data = jsonData['data'];

        print('Code: $jsonData');

        if (code == 200) {
          String? authToken = data['token'];
          if (authToken != null) {
            responseData.status = 200;
            responseData.message = message;
            responseData.data = authToken;
          } else {
            // Handle missing token
            responseData.message = 'Missing authentication token';
          }
        } else {
          responseData.status = code;
          responseData.message = message;
        }
      } else {
        responseData.message = '${response.statusCode} ${response.body}';
      }
    } catch (e) {
      print(e);
      responseData.message = e.toString();
    }

    return responseData;
  }

  Future<ResponseData> register(UserRegister userRegister) async {
    ResponseData responseData = ResponseData();

    Map<String, String> param = {
      'username': userRegister.username,
      'email': userRegister.email,
      'password': userRegister.password,
      'full_name': userRegister.name,
      'phone': userRegister.phone,
      'birthdate': userRegister.birthdate.toIso8601String(),
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

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        int code = jsonData['code'];
        String message = jsonData['message'];

        if (code == 200) {
          responseData.status = 200;
          responseData.message = message;
        } else {
          responseData.status = code;
          responseData.message = message;
        }
      } else {
        responseData.message = '${response.statusCode} ${response.body}';
      }
    } catch (e) {
      print(e);
      responseData.message = e.toString();
    }
    return responseData;
  }
}
