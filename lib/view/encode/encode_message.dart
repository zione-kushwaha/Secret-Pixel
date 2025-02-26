import 'dart:io';
import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import '/constants/constant.dart';
import '/core/showsnackbar.dart';
import '/theme/theme_color.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:pincode_input_fields/pincode_input_fields.dart';
import '../../controller/make_request.dart';
import '../../core/pincode_field.dart';
import '../../providers/theme_provider.dart';

class EncodeMessage extends ConsumerStatefulWidget {
  const EncodeMessage({super.key, required this.selectedImage});
  final File selectedImage;

  @override
  _EncodeMessageState createState() => _EncodeMessageState();
}

class _EncodeMessageState extends ConsumerState<EncodeMessage> {
  final TextEditingController messageController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  File? selectedFile;
  String? downloadlink = '';
  late PincodeInputFieldsController pincodeController;

  @override
  void initState() {
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
    print('image size ${image.lengthSync() / 8}');
    print('file size ${file.lengthSync()}');
    return image.lengthSync() / 8 < file.lengthSync();
  }

  // function to show the alert dialog
  Future<void> showAlertDialogDownload(
      BuildContext context, String link) async {
    bool isloading = false;

    print('download link $link');
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        final width = MediaQuery.sizeOf(context).width;
        final height = MediaQuery.sizeOf(context).height;
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              backgroundColor: GetColor.backgroundColor(context),
              title: Text('Download'),
              content: Text('Download the Encoded Image'),
              actions: [
                InkWell(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Container(
                      height: height / 20,
                      width: width / 5,
                      padding: EdgeInsets.all(10.0),
                      decoration: BoxDecoration(
                        color: GetColor.textColor(context).withOpacity(0.9),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: Center(
                        child: Text('Close',
                            style: TextStyle(
                                color: GetColor.backgroundColor(context))),
                      )),
                ),
                SizedBox(width: width / 15),
                InkWell(
                    onTap: () async {
                      setState(() {
                        isloading = true;
                      });
                      await MakeRequest().downloadFile(link);
                      setState(() {
                        isloading = false;
                      });
                      Navigator.pop(context);
                      show_snackbar(context, 'Image saved to gallery');
                    },
                    child: Container(
                      height: height / 20,
                      width: width / 5,
                      padding: EdgeInsets.all(10.0),
                      decoration: BoxDecoration(
                        color: GetColor.textColor(context).withOpacity(0.9),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: Center(
                        child: !isloading
                            ? Text('  Save',
                                style: TextStyle(
                                    color: GetColor.backgroundColor(context)))
                            : CircularProgressIndicator(
                                color: GetColor.backgroundColor(context),
                              ),
                      ),
                    )),
              ],
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.sizeOf(context).height;
    final width = MediaQuery.sizeOf(context).width;
    final Color textColor = GetColor.textColor(context);
    final Color backgroundColor = GetColor.backgroundColor(context);
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: whiteColor),
        backgroundColor:
            ref.read(themeProvider.notifier).getTheme == ThemeMode.dark
                ? backgroundColor
                : blackColor,
        title: Text('Encode ${_selectedIndex == 0 ? 'Message' : 'File'}',
            style: TextStyle(color: Colors.white)),
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
          padding: EdgeInsets.only(
              left: width / 30, right: width / 30, top: height / 50),
          child: ListView(
            children: [
              SizedBox(
                height: height / 6,
                width: double.infinity,
                child: Image.file(widget.selectedImage),
              ),
              SizedBox(height: height / 40),
              _selectedIndex == 0
                  ? _buildTextfield(textColor, width)
                  : _buildChooseFile(textColor, height, width),
              SizedBox(height: height / 40),
              Text('PIN (optional)',
                  style: TextStyle(color: Colors.grey, fontSize: 16)),
              SizedBox(height: height / 45),
              buildPincode(height, width, context, pincodeController),
              SizedBox(height: height / 40),
              _buildDownloadButton(textColor, width)
            ],
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

  Widget _buildTextfield(Color textColor, double width) {
    return TextField(
      cursorColor: textColor,
      controller: messageController,
      decoration: InputDecoration(
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(width / 20),
          borderSide: BorderSide(color: GetColor.textColor(context), width: 1),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(width / 30),
          borderSide: BorderSide(color: textColor, width: 1),
        ),
        labelText: ' Your Secret Message...',
        labelStyle: TextStyle(color: textColor),
        alignLabelWithHint: true,
        hintText: 'Enter your secret message',
        hintStyle: TextStyle(color: textColor),
      ),
      maxLines: 4,
    );
  }

  Widget _buildChooseFile(Color textColor, double height, double width) {
    return Container(
      height: height / 5.54,
      width: double.infinity,
      padding:
          EdgeInsets.symmetric(horizontal: width / 40, vertical: height / 90),
      decoration: BoxDecoration(
        border: Border.all(
          color: GetColor.textColor(context),
        ),
        borderRadius: BorderRadius.circular(width / 20),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            selectedFile == null
                ? Text('File not Selected',
                    style: TextStyle(color: Colors.red, fontSize: 12))
                : Text('File Selected',
                    style: TextStyle(color: Colors.green, fontSize: 12)),
            SizedBox(height: height / 60),
            InkWell(
              borderRadius: BorderRadius.circular(width / 20),
              onTap: () async {
                FilePickerResult? result =
                    await FilePicker.platform.pickFiles();
                if (result != null) {
                  setState(() {
                    selectedFile = File(result.files.single.path!);
                  });
                } else {
                  return;
                }
              },
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: GetColor.textColor(context),
                  ),
                  borderRadius: BorderRadius.circular(width / 20),
                ),
                padding: EdgeInsets.symmetric(
                    horizontal: width / 20, vertical: height / 120),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.file_copy, color: textColor, size: 20),
                    SizedBox(width: width / 40),
                    selectedFile == null
                        ? Text('Choose File to Hide')
                        : Row(
                            children: [
                              Text('File Selected',
                                  style: TextStyle(color: textColor)),
                              SizedBox(width: width / 30),
                              InkWell(
                                onTap: () {
                                  setState(() {
                                    selectedFile = null;
                                  });
                                },
                                child: Icon(Icons.close,
                                    color: Colors.red, size: 20),
                              ),
                            ],
                          ),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: height / 40,
            ),
            Text(
              'For best result choose file less than  ${(widget.selectedImage.lengthSync() / 1024 / 8).toStringAsFixed(2)} KB',
              style: TextStyle(fontSize: 10),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDownloadButton(Color textColor, double width) {
    return ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: GetColor.textColor(context),
        ),
        onPressed: () async {
          context.loaderOverlay.show();

          try {
            if (_selectedIndex == 0) {
              if (messageController.text.trim().isEmpty) {
                show_snackbar(context, 'Please enter a message to hide');
                context.loaderOverlay.hide();
                return;
              }
              downloadlink = await MakeRequest().encodeMessage(
                  message: messageController.text,
                  pin: pincodeController.text,
                  image: widget.selectedImage);
              context.loaderOverlay.hide();
              await showAlertDialogDownload(context, downloadlink!);
            } else {
              if (selectedFile == null) {
                show_snackbar(context, 'Please select a file to hide');
                context.loaderOverlay.hide();
                return;
              }
              if (checkFileSize(widget.selectedImage, selectedFile)) {
                show_snackbar(context, 'File size is too large');
                context.loaderOverlay.hide();
                return;
              }

              downloadlink = await MakeRequest().encodeFile(
                  file: selectedFile!,
                  pin: pincodeController.text,
                  image: widget.selectedImage);
              context.loaderOverlay.hide();
              await showAlertDialogDownload(context, downloadlink!);
            }
          } catch (e) {
            show_snackbar(context, e.toString());
          } finally {
            if (!mounted) return;
            context.loaderOverlay.hide();
          }

          messageController.clear();
          passwordController.clear();
          pincodeController.clear();
          selectedFile = null;
          setState(() {});
        },
        child: Text('Hide ${_selectedIndex == 0 ? 'Message' : 'File'}',
            style: TextStyle(color: GetColor.backgroundColor(context))));
  }
}
