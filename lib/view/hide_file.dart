import 'dart:io';

import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:v/network/make_request.dart';

class HideFile extends StatefulWidget {
  const HideFile({super.key, required this.image});
  final File image;

  @override
  _HideFileState createState() => _HideFileState();
}

class _HideFileState extends State<HideFile> {
  final TextEditingController passwordController = TextEditingController();
  File? selectedFile;
  bool _isPasswordVisible = false;
  String? DownloadLink = '';
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    print(widget.image);
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
              setState(() {
                selectedFile = null;
              });
            },
          ),
        ],
      ),
      body: LoaderOverlay(
        overlayColor: Colors.transparent.withOpacity(0.5),
        useDefaultLoading: false,
        overlayWidgetBuilder: (_) {
          return Center(
            child: SpinKitCubeGrid(
              color: Colors.white,
              size: 50.0,
            ),
          );
        },
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (selectedFile == null)
                    SizedBox(
                      height: MediaQuery.of(context).size.height / 1.2,
                      child: Center(
                        child: Text(
                          "Add a File to Start Encoding.",
                          style: TextStyle(fontSize: 24, color: Colors.white),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    )
                  else
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Selected $selectedFile',
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
                            DownloadLink = await MakeRequest().uploadFiles(
                              message: 'Checking the Api',
                              file: selectedFile!,
                              image: File(widget.image.path),
                            );
                            context.loaderOverlay.hide();
                            setState(() {});
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 20, vertical: 5),
                            child: Text('Hide Message In File',
                                style: TextStyle(color: Colors.black)),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                        ),
                        SizedBox(
                            height: MediaQuery.of(context).size.height / 5),
                        DownloadLink!.length > 1
                            ? Align(
                                alignment: Alignment.center,
                                child: GestureDetector(
                                  onTap: () async {
                                    await MakeRequest()
                                        .downloadFile(DownloadLink!);
                                  },
                                  child: Container(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 20, vertical: 5),
                                    child: Text('Download File',
                                        style: TextStyle(color: Colors.black)),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                  ),
                                ),
                              )
                            : Container(),
                      ],
                    ),
                ],
              ),
            ),
            if (context.loaderOverlay.visible)
              Container(
                color: Colors.black.withOpacity(0.5),
              ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.white,
        onPressed: () async {
          FilePickerResult? result = await FilePicker.platform.pickFiles();
          if (result != null) {
            setState(() {
              selectedFile = File(result.files.single.path!);
            });
          } else {
            // User canceled the picker
          }
        },
        child: const Icon(Icons.file_copy, color: Colors.black),
      ),
    );
  }
}
