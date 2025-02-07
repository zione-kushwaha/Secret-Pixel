import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:v/network/make_request.dart';

class HideFile extends StatefulWidget {
  const HideFile(
      {super.key, required this.selectedImage, required this.selectedFile});
  final File selectedImage;
  final File selectedFile;

  @override
  _HideFileState createState() => _HideFileState();
}

class _HideFileState extends State<HideFile> {
  final TextEditingController passwordController = TextEditingController();

  bool _isPasswordVisible = false;
  String downloadLink = '';
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text('Hide File'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              passwordController.clear();
              Navigator.pop(context);
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Selected ${widget.selectedFile}',
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
                SizedBox(height: 20),
                TextField(
                  controller: passwordController,
                  obscureText: !_isPasswordVisible,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                    labelText: 'Password (Optional)',
                    hintText: 'Enter a password',
                    suffixIcon: IconButton(
                      icon: Icon(
                        _isPasswordVisible
                            ? Icons.visibility
                            : Icons.visibility_off,
                      ),
                      onPressed: () {
                        setState(() {
                          _isPasswordVisible = !_isPasswordVisible;
                        });
                      },
                    ),
                  ),
                ),
                SizedBox(height: 20),
                GestureDetector(
                  onTap: () async {
                    context.loaderOverlay.show();
                    print('we are uploading the file to server to encode');
                    downloadLink = await MakeRequest().uploadFiles(
                          message: 'Checking the Api',
                          file: widget.selectedFile,
                          image: widget.selectedImage,
                        ) ??
                        '';
                    print('downloadLink: $downloadLink');
                    print(downloadLink);
                    context.loaderOverlay.hide();
                    setState(() {});
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                    child: Text('Hide Message In File',
                        style: TextStyle(color: Colors.black)),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                ),
                SizedBox(height: MediaQuery.of(context).size.height / 5),
                downloadLink.length > 1
                    ? Align(
                        alignment: Alignment.center,
                        child: GestureDetector(
                          onTap: () async {
                            context.loaderOverlay.show();
                            await MakeRequest().downloadFile(downloadLink!);
                            context.loaderOverlay.hide();
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 20, vertical: 5),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text('Download File',
                                style: TextStyle(color: Colors.black)),
                          ),
                        ),
                      )
                    : Container(),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
