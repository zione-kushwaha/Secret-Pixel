import 'dart:io';
import 'package:dio/dio.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:path_provider/path_provider.dart';

class MakeRequest {
  final Dio _dio = Dio();
  final String encodeUrl = "https://secretpixel.tech/api/encode/";
  final String decodeUrl = "https://secretpixel.tech/api/decode/";

  Future<String?> uploadFiles(
      {required String message,
      required File file,
      required File image}) async {
    print('File path: ${file.path}');
    print('Image path: ${image.path}');

    print('file is being uploaded');

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
    print(formData.fields);
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
      // Get the temporary directory to save the file
      Directory tempDir = await getTemporaryDirectory();
      String tempPath = '${tempDir.path}/downloaded_file.jpg';

      // Download the file
      Response response = await _dio.download(url, tempPath);

      if (response.statusCode == 200) {
        print('Download successful');
        print('File saved to: $tempPath');

        // Save the file to the gallery
        bool? result = await GallerySaver.saveImage(tempPath, albumName: 'Amu');
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
