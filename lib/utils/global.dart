import 'package:instagram_flutter/models/user.dart';
import 'package:instagram_flutter/stream/mystream.dart';

class Global{

  static MyStream? myStream;
  static User? user;

  static void cleanData(){
    user = null;
  }
}