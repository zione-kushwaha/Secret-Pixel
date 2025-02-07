import 'package:flutter/material.dart';
import 'package:flutter_settings_ui/flutter_settings_ui.dart';

class Setting extends StatelessWidget {
  const Setting({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 33, 32, 32),
      ),
      body: SettingsList(
        sections: [
          SettingsSection(
            title: Text('General'),
            tiles: [
              SettingsTile(
                title: Text('Theme'),
                description: Text('Light/Dark'),
                leading: Icon(Icons.dark_mode),
                onPressed: (BuildContext context) {
                  // Handle theme change
                },
              ),
              SettingsTile(
                title: Text('Feedbacks'),
                leading: Icon(Icons.feedback),
                onPressed: (BuildContext context) {
                  // Handle feedback
                },
              ),
            ],
          ),
          SettingsSection(
            title: Text('Legal'),
            tiles: [
              SettingsTile(
                title: Text('Terms & Conditions'),
                leading: Icon(Icons.description),
                onPressed: (BuildContext context) {
                  // Handle terms & conditions
                },
              ),
              SettingsTile(
                title: Text('Privacy Policy'),
                leading: Icon(Icons.privacy_tip),
                onPressed: (BuildContext context) {
                  // Handle privacy policy
                },
              ),
            ],
          ),
          SettingsSection(
            title: Text('About'),
            tiles: [
              SettingsTile(
                title: Text('Version'),
                description: Text('1.0.0+1'),
                leading: Icon(Icons.info),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

  // void _openCamera() async {
  //   ImagePicker imagePicker = ImagePicker();
  //   XFile? pickedImage = await imagePicker.pickImage(
  //     source: ImageSource.camera,
  //   );
  //   if (pickedImage != null) {
  //     File image = File(pickedImage.path);
  //     await saveImage(image);
  //     // Reload images after adding a new one.
  //     setState(() {});
  //   }
  // }

  // Future<void> saveImage(File image) async {
  //   // Implement your save image logic here
  // }

  // void _openGallery() async {
  //   ImagePicker imagePicker = ImagePicker();
  //   XFile? pickedImage = await imagePicker.pickImage(
  //     source: ImageSource.gallery,
  //   );
  //   if (pickedImage != null) {
  //     File image = File(pickedImage.path);
  //     await saveImage(image);
  //     // Reload images after adding a new one.
  //     setState(() {});
  //   }
  // }