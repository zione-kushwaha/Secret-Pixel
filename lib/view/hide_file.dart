import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';

class HideFile extends StatefulWidget {
  const HideFile({super.key});

  @override
  _HideFileState createState() => _HideFileState();
}

class _HideFileState extends State<HideFile> {
  final TextEditingController messageController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  String? selectedFile;
  bool _isPasswordVisible = false;

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
              messageController.clear();
              passwordController.clear();
              setState(() {
                selectedFile = null;
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
              if (selectedFile == null)
                SizedBox(
                  height:
                      MediaQuery.of(context).size.height - kToolbarHeight - 40,
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
                      'Selected File: $selectedFile',
                      style: TextStyle(fontSize: 18, color: Colors.white),
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
                    ElevatedButton(
                      onPressed: () {
                        // Logic to hide the message in the file
                      },
                      child: Text('Hide Message in File'),
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
          FilePickerResult? result = await FilePicker.platform.pickFiles();
          if (result != null) {
            setState(() {
              selectedFile = result.files.single.name;
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
