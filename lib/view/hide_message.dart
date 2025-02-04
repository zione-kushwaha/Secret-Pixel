import 'package:flutter/material.dart';
import 'package:v/core/pick_image.dart';

class HideMessage extends StatefulWidget {
  const HideMessage({super.key});

  @override
  _HideMessageState createState() => _HideMessageState();
}

class _HideMessageState extends State<HideMessage> {
  final TextEditingController messageController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  Image? selectedImage;
  bool _isPasswordVisible = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text('Hide Message'),
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
                      SizedBox(height: MediaQuery.of(context).size.height / 3),
                      Center(
                        child: Text(
                          "Add an Image to Start Encoding.",
                          style: TextStyle(fontSize: 24, color: Colors.white),
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
                      child: selectedImage!,
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
                    Align(
                      alignment: Alignment.bottomRight,
                      child: Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                        decoration: BoxDecoration(
                          color: messageController.text.isEmpty
                              ? Colors.grey
                              : Colors.white,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text('Download Image',
                            style: TextStyle(color: Colors.black)),
                      ),
                    ),
                    SizedBox(height: 20),
                    Row(
                      children: [
                        Expanded(child: Divider(color: Colors.white)),
                        Text('  OR  ', style: TextStyle(color: Colors.white)),
                        Expanded(child: Divider(color: Colors.white)),
                      ],
                    ),
                    SizedBox(height: 20),
                    GestureDetector(
                      onTap: () {
                        if (selectedImage != null) {
                          Navigator.pushNamed(context, '/hideFile');
                        }
                      },
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
            });
          }
        },
        child: const Icon(Icons.camera_alt, color: Colors.black),
      ),
    );
  }
}
