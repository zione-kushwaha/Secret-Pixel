import 'package:flutter/material.dart';

class Setting extends StatelessWidget {
  const Setting({super.key});

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Settings',
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 20),
        child: Column(
          children: [
            ListTile(title: Text('Theme'), trailing: Icon(Icons.dark_mode)),
            ListTile(
              title: Text('Feedbacks'),
            ),
            ListTile(
              title: Text('Terms & Condition'),
            ),
            ListTile(
              title: Text('Private Policy'),
            ),
            ListTile(
              title: Text('Version: 1.0.0+1'),
            ),
          ],
        ),
      ),
    );
  }
}
