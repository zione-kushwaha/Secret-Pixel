import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:v/core/pick_image.dart';

class RevealMessage extends StatefulWidget {
  const RevealMessage({super.key});

  @override
  _RevealMessageState createState() => _RevealMessageState();
}

class _RevealMessageState extends State<RevealMessage> {
  final TextEditingController passwordController = TextEditingController();
  Image? selectedImage;
  bool _isPasswordVisible = false;
  String? revealedMessage;

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
                      child: selectedImage!,
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
                      onTap: () {
                        // Logic to reveal the message
                        setState(() {
                          revealedMessage =
                              '''import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:v/core/pick_image.dart';

class RevealMessage extends StatefulWidget {
  const RevealMessage({super.key});

  @override
  _RevealMessageState createState() => _RevealMessageState();
}

class _RevealMessageState extends State<RevealMessage> {
  final TextEditingController passwordController = TextEditingController();
  Image? selectedImage;
  bool _isPasswordVisible = false;
  String? revealedMessage;

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
                  height: MediaQuery.of(context).size.height - kToolbarHeight - 40,
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
                      child: selectedImage!,
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
        '''; // Replace with actual logic
                        });
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
              selectedImage = Image.file(image);
              revealedMessage = null;
            });
          }
        },
        child: const Icon(Icons.camera_alt, color: Colors.black),
      ),
    );
  }
}
