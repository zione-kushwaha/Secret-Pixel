import 'dart:convert';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:path_provider/path_provider.dart';
import 'package:v/core/pick_image.dart';
import 'package:v/network/make_request.dart';
import 'hide_file.dart';

class HideMessage extends StatefulWidget {
  const HideMessage({super.key});

  @override
  _HideMessageState createState() => _HideMessageState();
}

class _HideMessageState extends State<HideMessage> {
  final TextEditingController messageController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  File? selectedImage;
  bool _isPasswordVisible = false;
  File? selectedFile;
  String? downloadlink = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text('Encode Message'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              messageController.clear();
              passwordController.clear();
              setState(() {
                selectedImage = null;
              });
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: selectedImage == null
              ? SizedBox(
                  height:
                      MediaQuery.of(context).size.height - kToolbarHeight - 40,
                  child: Column(
                    children: [
                      SizedBox(height: MediaQuery.of(context).size.height / 5),
                      Icon(Icons.lock, size: 100, color: Colors.white),
                      SizedBox(height: MediaQuery.of(context).size.height / 20),
                      Center(
                        child: Text(
                          "Add an Image to Start Encoding.",
                          style: TextStyle(
                              fontSize: 24,
                              color: Colors.white,
                              fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                )
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 200,
                      width: double.infinity,
                      child: Image.file(selectedImage!),
                    ),
                    SizedBox(height: 20),
                    TextField(
                      controller: messageController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
                        labelText: 'Secret Message',
                        hintText: 'Enter your secret message',
                      ),
                      maxLines: 4,
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        downloadlink!.length > 1
                            ? GestureDetector(
                                onTap: () async {
                                  if (!mounted) return;
                                  context.loaderOverlay.show();
                                  try {
                                    await MakeRequest()
                                        .downloadFile(downloadlink!);
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        behavior: SnackBarBehavior.floating,
                                        margin: EdgeInsets.symmetric(
                                            horizontal: MediaQuery.of(context)
                                                    .size
                                                    .width /
                                                10),
                                        content: Align(
                                          alignment: Alignment.center,
                                          child: Text(
                                            'Downloaded Successfully',
                                            style:
                                                TextStyle(color: Colors.black),
                                          ),
                                        ),
                                      ),
                                    );
                                  } catch (e) {
                                    print(e);
                                  } finally {
                                    if (!mounted) return;
                                    context.loaderOverlay.hide();
                                  }
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
                              )
                            : SizedBox(
                                height: 20,
                              ),
                        Align(
                          alignment: Alignment.bottomRight,
                          child: GestureDetector(
                            onTap: () async {
                              if (messageController.text.trim().isNotEmpty) {
                                if (!mounted) return;
                                context.loaderOverlay.show();
                                try {
                                  File messageFile = await _createMessageFile(
                                      messageController.text);
                                  downloadlink = await MakeRequest()
                                      .uploadFiles(
                                          message: messageController.text,
                                          file: messageFile,
                                          image: selectedImage!);
                                } catch (e) {
                                  print(e);
                                } finally {
                                  if (!mounted) return;
                                  context.loaderOverlay.hide();
                                }

                                messageController.clear();
                                passwordController.clear();
                                setState(() {});
                              }
                            },
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 5),
                              decoration: BoxDecoration(
                                color: messageController.text.isEmpty
                                    ? Colors.grey.shade700
                                    : Colors.white,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text('Hide Message',
                                  style: TextStyle(color: Colors.black)),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                    Row(
                      children: [
                        Expanded(child: Divider(color: Colors.white)),
                        Text('  OR  ', style: TextStyle(color: Colors.white)),
                        Expanded(child: Divider(color: Colors.white)),
                      ],
                    ),
                    SizedBox(height: 40),
                    GestureDetector(
                      onTap: () async {
                        FilePickerResult? result =
                            await FilePicker.platform.pickFiles();
                        if (result != null) {
                          setState(() {
                            selectedFile = File(result.files.single.path!);
                          });
                        } else {
                          // User canceled the picker
                          return;
                        }
                        if (selectedImage != null && selectedFile != null) {
                          print('Selected Image: ${selectedImage!.path}');
                          print('Selected File: ${selectedFile!.path}');
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => HideFile(
                                      selectedImage: selectedImage!,
                                      selectedFile: selectedFile!)));
                        }
                      },
                      child: Align(
                        alignment: Alignment.center,
                        child: Container(
                          padding:
                              EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                          child: Text('Hide File',
                              style: TextStyle(color: Colors.black)),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
        ),
      ),
      floatingActionButton: selectedImage == null
          ? SpeedDial(
              icon: Icons.add,
              iconTheme: IconThemeData(color: Colors.black),
              animatedIconTheme: IconThemeData(color: Colors.black),
              curve: Curves.bounceIn,
              backgroundColor: Colors.white,
              children: [
                SpeedDialChild(
                  child: Icon(Icons.camera_alt),
                  onTap: () async {
                    final image = await Pick.openCamera();
                    if (image != null) {
                      setState(() {
                        selectedImage = image;
                      });
                    }
                  },
                  label: 'Open Camera',
                  labelStyle: TextStyle(color: Colors.black),
                  labelBackgroundColor: Colors.white,
                ),
                SpeedDialChild(
                  child: Icon(FontAwesomeIcons.image),
                  onTap: () async {
                    final image = await Pick.pickImage();
                    if (image != null) {
                      setState(() {
                        selectedImage = image;
                      });
                    }
                  },
                  label: 'Select Image',
                  labelStyle: TextStyle(color: Colors.black),
                  labelBackgroundColor: Colors.white,
                ),
              ],
            )
          : null,
    );
  }

  Future<File> _createMessageFile(String message) async {
    final directory = await getTemporaryDirectory();
    final path = '${directory.path}/message.txt';
    final file = File(path);
    return file.writeAsString(message);
  }
}
