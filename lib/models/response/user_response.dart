import 'package:instagram_flutter/models/user.dart';

class UserResponse {
  User? user;
  String? message;
  int? status;

  UserResponse({this.user, this.message, this.status});
  UserResponse.mock(this.user) : message = "";
}
