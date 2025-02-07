import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:v/core/pick_image.dart';
import 'package:v/network/make_request.dart';

class RevealMessage extends StatefulWidget {
  const RevealMessage({super.key});

  @override
  _RevealMessageState createState() => _RevealMessageState();
}

class _RevealMessageState extends State<RevealMessage> {
  final TextEditingController passwordController = TextEditingController();
  File? selectedImage;
  bool _isPasswordVisible = false;
  bool isReady = false;
  String? revealedMessage;
  String downloadLink = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text('Reveal Message'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              passwordController.clear();
              setState(() {
                selectedImage = null;
                revealedMessage = null;
              });
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (selectedImage == null)
                SizedBox(
                  height:
                      MediaQuery.of(context).size.height - kToolbarHeight - 40,
                  child: Center(
                    child: Text(
                      "Add an Image to Reveal the Message.",
                      style: TextStyle(fontSize: 24, color: Colors.white),
                      textAlign: TextAlign.center,
                    ),
                  ),
                )
              else
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 200,
                      width: double.infinity,
                      child: Image.file(selectedImage!),
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
                        // Logic to reveal the message
                        try {
                          context.loaderOverlay.show();

                          downloadLink = (await MakeRequest().decodeMessage(
                              image: selectedImage ?? File('')))!;
                          context.loaderOverlay.hide();
                        } catch (e) {
                          context.loaderOverlay.hide();
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              behavior: SnackBarBehavior.floating,
                              margin: EdgeInsets.symmetric(
                                  horizontal:
                                      MediaQuery.of(context).size.width / 25),
                              padding: EdgeInsets.all(10),
                              content: Align(
                                alignment: Alignment.center,
                                child: Text(
                                  'Something went wrong in Server',
                                  style: TextStyle(
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                              backgroundColor: Colors.white,
                            ),
                          );
                        }
                        setState(() {});
                      },
                      child: Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                        child: Text('REVEAL MESSAGE',
                            style: TextStyle(color: Colors.black)),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height / 5),
                    downloadLink.length > 2
                        ? Align(
                            alignment: Alignment.center,
                            child: GestureDetector(
                              onTap: () async {
                                context.loaderOverlay.show();
                                // await MakeRequest().downloadFile(downloadLink);
                                await launch(downloadLink);
                                context.loaderOverlay.hide();
                              },
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 5),
                                child: Text('View Message',
                                    style: TextStyle(color: Colors.black)),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                              ),
                            ),
                          )
                        : SizedBox(),
                    if (revealedMessage != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 20.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(10.0),
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.white),
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: SingleChildScrollView(
                                child: Text(
                                  revealedMessage!,
                                  style: TextStyle(
                                      fontSize: 18, color: Colors.white),
                                ),
                              ),
                            ),
                            SizedBox(height: 10),
                            GestureDetector(
                              onTap: () {
                                Clipboard.setData(ClipboardData(
                                    text: revealedMessage.toString()));
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                      content:
                                          Text('Message copied to clipboard')),
                                );
                              },
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 5),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(Icons.copy, color: Colors.black),
                                    Text('Copy',
                                        style: TextStyle(color: Colors.black)),
                                  ],
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.white,
        onPressed: () async {
          final image = await Pick.pickImage();
          if (image != null) {
            setState(() {
              selectedImage = image;
              revealedMessage = null;
            });
          }
        },
        child: const Icon(Icons.camera_alt, color: Colors.black),
      ),
    );
  }
}
