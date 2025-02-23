import 'dart:io';
import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pincode_input_fields/pincode_input_fields.dart';
import 'package:v/network/make_request.dart';

class HideMessage extends StatefulWidget {
  const HideMessage({super.key, required this.selectedImage});
  final File selectedImage;

  @override
  _HideMessageState createState() => _HideMessageState();
}

class _HideMessageState extends State<HideMessage> {
  final TextEditingController messageController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  File? selectedFile;
  String? downloadlink = '';
  late PincodeInputFieldsController pincodeController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    pincodeController = PincodeInputFieldsController();
  }

  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  //function that check the two file size and return true or false
  bool checkFileSize(File image, File? file) {
    if (file == null) return false;
    return image.lengthSync() / 8 > file.lengthSync();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.sizeOf(context).height;
    final width = MediaQuery.sizeOf(context).width;
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        title: Text('Encode ${_selectedIndex == 0 ? 'Message' : 'File'}'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.close),
            onPressed: () {
              messageController.clear();
              passwordController.clear();
              Navigator.pop(context);
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(left: 20, right: 20, top: 20),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: height / 6,
                  width: double.infinity,
                  child: Image.file(widget.selectedImage),
                ),
                SizedBox(height: 20),
                _selectedIndex == 0
                    ? TextField(
                        cursorColor: Colors.white,
                        controller: messageController,
                        decoration: InputDecoration(
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide:
                                BorderSide(color: Colors.white, width: 1),
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide:
                                BorderSide(color: Colors.white, width: 2),
                          ),
                          labelText: ' Your Secret Message...',
                          alignLabelWithHint: true,
                          hintText: 'Enter your secret message',
                        ),
                        maxLines: 4,
                      )
                    : Container(
                        height: height / 5.54,
                        width: double.infinity,
                        padding:
                            EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              // SizedBox(height: height / 50),
                              !checkFileSize(widget.selectedImage, selectedFile)
                                  ? Text('Select file of less size',
                                      style: TextStyle(
                                          color: Colors.red, fontSize: 12))
                                  : Text('Good to go !!!',
                                      style: TextStyle(
                                          color: Colors.green, fontSize: 12)),
                              SizedBox(height: height / 50),
                              InkWell(
                                borderRadius: BorderRadius.circular(20),
                                onTap: () async {
                                  FilePickerResult? result =
                                      await FilePicker.platform.pickFiles();
                                  if (result != null) {
                                    setState(() {
                                      selectedFile =
                                          File(result.files.single.path!);
                                    });
                                  } else {
                                    // User canceled the picker
                                    return;
                                  }
                                  if (selectedFile != null) {
                                    print(
                                        'Selected Image: ${widget.selectedImage.path}');
                                    print(
                                        'Selected File: ${selectedFile!.path}');
                                    // Navigator.push(
                                    //     context,
                                    //     MaterialPageRoute(
                                    //         builder: (context) => HideFile(
                                    //             selectedImage: widget.selectedImage,
                                    //             selectedFile: selectedFile!)));
                                  }
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      // width: 1,
                                      color: Colors.white,
                                    ),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 20, vertical: 5),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(Icons.file_copy,
                                          color: Colors.white, size: 20),
                                      SizedBox(width: 10),
                                      selectedFile == null
                                          ? Text('Choose File to Hide')
                                          : Row(
                                              children: [
                                                Text('File Selected',
                                                    style: TextStyle(
                                                        color: Colors.white)),
                                                SizedBox(width: 10),
                                                InkWell(
                                                  onTap: () {
                                                    setState(() {
                                                      selectedFile = null;
                                                    });
                                                  },
                                                  child: Icon(Icons.close,
                                                      color: Colors.white),
                                                ),
                                              ],
                                            ),
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: height / 30,
                              ),
                              Text(
                                'For best result choose file less than  ${(widget.selectedImage.lengthSync() / 1024 / 8).toStringAsFixed(2)} KB',
                                style: TextStyle(fontSize: 10),
                              ),
                            ],
                          ),
                        ),
                        decoration: BoxDecoration(
                          border: Border.all(
                            // width: 1,
                            color: Colors.white,
                          ),
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                SizedBox(height: height / 50),
                Text('PIN (optional)',
                    style: TextStyle(color: Colors.grey, fontSize: 16)),
                SizedBox(height: height / 60),
                PincodeInputFields(
                  controller: pincodeController,
                  length: 4,
                  heigth: height / 17,
                  width: width / 7,
                  borderRadius: BorderRadius.circular(9),
                  unfocusBorder: Border.all(
                    width: 1,
                    color: const Color.fromARGB(255, 154, 149, 149),
                  ),
                  focusBorder: Border.all(
                    width: 1,
                    color: Colors.white,
                  ),
                  cursorColor: Colors.white,
                  cursorWidth: 2,
                  focusFieldColor: const Color(0xFF2A2B32),
                  unfocusFieldColor: const Color(0xFF2A2B32),
                  textStyle: const TextStyle(
                    color: Colors.white,
                    fontSize: 21,
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
                                await MakeRequest().downloadFile(downloadlink!);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    behavior: SnackBarBehavior.floating,
                                    margin: EdgeInsets.symmetric(
                                        horizontal:
                                            MediaQuery.of(context).size.width /
                                                10),
                                    content: Align(
                                      alignment: Alignment.center,
                                      child: Text(
                                        'Downloaded Successfully',
                                        style: TextStyle(color: Colors.black),
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
                              downloadlink = await MakeRequest().uploadFiles(
                                  message: messageController.text,
                                  file: messageFile,
                                  image: widget.selectedImage);
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
                          margin: EdgeInsets.only(top: 10),
                          padding:
                              EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                          decoration: BoxDecoration(
                            color: messageController.text.trim().length > 0
                                ? Colors.grey.shade700
                                : Colors.white,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                              'Hide ${_selectedIndex == 0 ? 'Message' : 'File'}',
                              style: TextStyle(color: Colors.black)),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: ConvexAppBar(
        curveSize: height / 10,
        curve: Curves.easeInOut,
        height: height / 12,
        backgroundColor: const Color.fromARGB(255, 31, 31, 31),
        items: [
          TabItem(icon: Icons.message, title: 'Message', isIconBlend: true),
          TabItem(icon: Icons.file_copy, title: 'File', isIconBlend: true),
        ],
        initialActiveIndex: 0,
        onTap: (val) {
          _onItemTapped(val);
        },
      ),
    );
  }

  Future<File> _createMessageFile(String message) async {
    final directory = await getTemporaryDirectory();
    final path = '${directory.path}/message.txt';
    final file = File(path);
    return file.writeAsString(message);
  }
}
