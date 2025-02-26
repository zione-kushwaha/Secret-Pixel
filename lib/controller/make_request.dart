import 'dart:io';
import 'package:dio/dio.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MakeRequest {
  final Dio _dio = Dio();
  final String encodeUrl = "https://secretpixel.tech/api/encode_message/";
  final String encodeFileUrl = "https://secretpixel.tech/api/encode_file/";
  final String decodemessage = "https://secretpixel.tech/api/decode_message/";
  final String decodeFileUrl = "https://secretpixel.tech/api/decode_file/";

  Future<String?> encodeMessage(
      {required String message, String? pin, required File image}) async {
    print('Image path: ${image.path}');

    print('file is being uploaded');

    if (!image.existsSync()) {
      print('One or both files do not exist');
      return null;
    }

    if (pin == '') {
      SharedPreferences.getInstance().then((prefs) {
        pin = prefs.getString('password') ?? '0000';
      });
    }

    FormData formData = FormData.fromMap({
      'Message': message,
      'pin': pin,
      'Image': await MultipartFile.fromFile(image.path,
          filename: image.path.split('/').last),
    });
    try {
      Response response = await _dio.post(encodeUrl, data: formData);
      print(response);

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
  Future<String?> decodeMessage({required File image, String? pin}) async {
    print('Image path: ${image.path}');
    print('file is being uploaded');

    if (!image.existsSync()) {
      print('Image does not exist');
      return null;
    }

    if (pin == '') {
      SharedPreferences.getInstance().then((prefs) {
        pin = prefs.getString('password') ?? '0000';
      });
    }

    FormData formData = FormData.fromMap({
      'Image': await MultipartFile.fromFile(image.path,
          filename: image.path.split('/').last),
      'pin': pin
    });

    try {
      Response response = await _dio.post(decodemessage, data: formData);

      if (response.statusCode == 200) {
        print('Decode successful');
        print('Response data: ${response.data}');
        return response.data['DecodedMessage'];
      } else {
        print('Decode failed with status: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Decode failed with error: $e');
      return null;
    }
  }

  // Encode File
  Future<String?> encodeFile(
      {required File file, String? pin, required File image}) async {
    print('File path: ${file.path}');
    print('Image path: ${image.path}');

    if (!file.existsSync() && !image.existsSync()) {
      print('File does not exist');
      return null;
    }
    if (pin == '') {
      SharedPreferences.getInstance().then((prefs) {
        pin = prefs.getString('password') ?? '0000';
      });
    }

    FormData formData = FormData.fromMap({
      'pin': pin,
      'Image': await MultipartFile.fromFile(image.path,
          filename: image.path.split('/').last),
      'File': await MultipartFile.fromFile(file.path,
          filename: file.path.split('/').last),
    });

    try {
      Response response = await _dio.post(encodeFileUrl, data: formData);

      if (response.statusCode == 200) {
        print('Encode successful');
        print('Response data: ${response.data}');
        return response.data['ModifiedImage'];
      } else {
        print('Encode failed with status: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Encode failed with error: $e');
      return null;
    }
  }

  // Making request to decode the file
  Future<String?> decodeFile({required File image, String? pin}) async {
    print('Image path: ${image.path}');

    if (!image.existsSync()) {
      print('Image does not exist');
      return null;
    }
    if (pin == '') {
      SharedPreferences.getInstance().then((prefs) {
        pin = prefs.getString('password') ?? '0000';
      });
    }

    FormData formData = FormData.fromMap({
      'Image': await MultipartFile.fromFile(image.path,
          filename: image.path.split('/').last),
      'pin': pin
    });

    try {
      Response response = await _dio.post(decodeFileUrl, data: formData);

      if (response.statusCode == 200) {
        print('Decode successful');
        print('Response data: ${response.data}');
        return response.data['DecodedFile'];
      } else {
        print('Decode failed with status: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Decode failed with error: $e');
      return null;
    }
  }

  Future<bool> downloadFile(String url) async {
    try {
      Directory tempDir = await getTemporaryDirectory();
      String tempPath = '${tempDir.path}/downloaded_file.jpg';

      Response response = await _dio.download(url, tempPath);

      if (response.statusCode == 200) {
        print('Download successful');
        print('File saved to: $tempPath');

        bool? result =
            await GallerySaver.saveImage(tempPath, albumName: 'Jeevan');
        if (result == true) {
          print('File saved to gallery');

          // Delete the temporary file
          File(tempPath).deleteSync();
          print('Temporary file deleted');

          return true;
        } else {
          print('Failed to save file to gallery');
          return false;
        }
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
