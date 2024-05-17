import 'package:http_parser/http_parser.dart';
import 'package:instagram_flutter/models/user_edit.dart';
import 'package:instagram_flutter/utils/const.dart';
import 'package:instagram_flutter/utils/global.dart';
import 'package:mime/mime.dart';
import 'package:http/http.dart' as http;

class UserService {

  Future<bool> editUser(UserEdit userEdit) async {
    String fileAvatar = userEdit.avatar;
    String token = Global.user!.token;

    List<String> acceptedTypes = [
      'image/jpeg',
      'image/png',
      'image/jpg',
      'image/webp',
    ];

    var request = http.MultipartRequest(
      'PUT',
      Uri.parse('$urlBase/users/me/update'),
    );

    if (userEdit.avatar.isNotEmpty && !userEdit.avatar.startsWith('http')) {
      String? contentType = lookupMimeType(userEdit.avatar);
      if (contentType != null && acceptedTypes.contains(contentType)) {
        request.files.add(await http.MultipartFile.fromPath(
          'avatar',
          userEdit.avatar,
          contentType: MediaType.parse(contentType),
        ));
      }
    }

    request.fields.addAll({
      'full_name': userEdit.name,
      'birthday': userEdit.birthday.toIso8601String(),
      'username': userEdit.username,
      'gender': userEdit.gender.toString(),
      'bio': userEdit.bio,
    });

    request.headers.addAll({
      'Authorization': 'Bearer $token',
    });

    try {
      var response = await request.send();
      if (response.statusCode == 200) {
        print('User edited successfully');
        return true;
      } else {
        print('Failed to edit user');
        return false;
      }
    } catch (e) {
      print('Error during edit user: $e');
      return false;
    }
  }


}
