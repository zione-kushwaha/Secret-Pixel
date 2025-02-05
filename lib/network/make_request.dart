import 'dart:io';
import 'package:dio/dio.dart';

class MakeRequest {
  final Dio _dio = Dio();
  final String encodeUrl = "https://visioncrypt.pythonanywhere.com/api/encode/";
  final String decodeUrl = "https://visioncrypt.pythonanywhere.com/api/decode/";

  Future<String?> uploadFiles(
      {required String message,
      required File file,
      required File image}) async {
    print('File path: ${file.path}');
    print('Image path: ${image.path}');

    if (!file.existsSync() || !image.existsSync()) {
      print('One or both files do not exist');
      return null;
    }

    FormData formData = FormData.fromMap({
      'Message': message,
      'File': await MultipartFile.fromFile(file.path,
          filename: file.path.split('/').last),
      'Image': await MultipartFile.fromFile(image.path,
          filename: image.path.split('/').last),
    });

    try {
      Response response = await _dio.post(encodeUrl, data: formData);

      if (response.statusCode == 200) {
        print('Upload successful');
        print('Response data: ${response.data}');
        return response.data['ModifiedImage'];
      } else {
        print('Upload failed with status: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Upload failed with error: $e');
      return null;
    }
  }

  // making the request to decode the message
  Future<String?> decodeMessage({required File image}) async {
    print('Image path: ${image.path}');

    if (!image.existsSync()) {
      print('Image does not exist');
      return null;
    }

    FormData formData = FormData.fromMap({
      'Image': await MultipartFile.fromFile(image.path,
          filename: image.path.split('/').last),
    });

    try {
      Response response = await _dio.post(decodeUrl, data: formData);

      if (response.statusCode == 200) {
        print('Decode successful');
        print('Response data: ${response.data}');
        return response.data['Message'];
      } else {
        print('Decode failed with status: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Decode failed with error: $e');
      return null;
    }
  }

  //functino to download the file
  Future<bool> downloadFile(String url) async {
    try {
      Response response = await _dio.get(url);

      if (response.statusCode == 200) {
        print('Download successful');
        print('Response data: ${response.data}');
        return true;
      } else {
        print('Download failed with status: ${response.statusCode}');
        return false;
      }
    } catch (e) {
      print('Download failed with error: $e');
      return false;
    }
  }
}
