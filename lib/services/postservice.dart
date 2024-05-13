import 'dart:convert';
import 'package:instagram_flutter/models/post.dart';
import 'package:http/http.dart' as http;
import 'package:instagram_flutter/models/response/responsedata.dart';
import '../utils/const.dart';
import 'package:http_parser/http_parser.dart';
import 'package:mime/mime.dart';

class PostService {
  Future<ResponseData> post(Post post) async {

    ResponseData responsesData = ResponseData(message: '');

    List<String> fileNamesList = post.files;
    String token =
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJleHAiOjE3MTU1OTUyNDMsInV1aWQiOiIxMWZmMTUwNC0yODU0LTQ5Y2EtODhlNi1iYzI5OGEwM2FjZWMifQ.OQu65DXJFD10bM9Hu46wS8AuJMtyf4Vwydzo-Nvqiak';
    List<String> acceptedTypes = [
      'image/jpeg',
      'image/png',
      'image/jpg',
      'video/mp4'
    ];
    var request = http.MultipartRequest('POST', Uri.parse('$urlBase/posts'));

    for (var fileName in fileNamesList) {
      if (fileName.isNotEmpty) {
        // Check if file type is accepted
        String? contentType = lookupMimeType(fileName);
        if (contentType != null && acceptedTypes.contains(contentType)) {
          request.files.add(
            await http.MultipartFile.fromPath(
              'files',
              fileName,
              contentType: MediaType.parse(contentType),
            ),
          );
        } else {
          print('File type not supported: $fileName');
        }
      }
    }

    request.fields.addAll({
      'caption': post.caption,
    });

    request.headers.addAll({
      'Authorization': 'Bearer $token',
    });

    try {
      var response = await request.send();

      var responseData = await response.stream.transform(utf8.decoder).join();
      var jsonData = jsonDecode(responseData);
      var code = jsonData['code'];
      var message = jsonData['message'];
      var data = jsonData['data'];

      if(code == 201) {
        responsesData.status = code;
        responsesData.message = message;
        responsesData.data = data;
      } else {
        responsesData.message = message;
        responsesData.data = data;
      }
    } catch (e) {
      responsesData.message = e.toString();
    }

    return responsesData;
  }
}
