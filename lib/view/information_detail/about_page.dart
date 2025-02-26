import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class About extends StatelessWidget {
  const About({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(Icons.arrow_back_ios, color: Colors.white)),
        title: const Text('About',
            style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 18)),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 10),
            Text(
              'This app is built by us for our minor project. The project aims to provide a secure way to hide and reveal messages and files within images.',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 20),
            Text(
              'Team Members',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            ListTile(
              onTap: () async {
                await launch(
                    "https://www.linkedin.com/in/debendra-shekhar-gupta-112353343?utm_source=share&utm_campaign=share_via&utm_content=profile&utm_medium=android_app");
              },
              leading: CircleAvatar(
                backgroundImage: AssetImage('assets/profile/debendra.jpg'),
              ),
              title: Text('Debendra Shekhar Gupta'),
            ),
            ListTile(
              onTap: () async {
                await launch(
                    "https://www.linkedin.com/in/dipesh-acharya-4a5ab7273/");
              },
              leading: CircleAvatar(
                backgroundImage: AssetImage('assets/profile/dipesh.jpg'),
              ),
              title: Text('Dipesh Prasad Acharya'),
            ),
            ListTile(
              onTap: () => launch("https://www.linkedin.com/in/zi-one"),
              leading: CircleAvatar(
                backgroundImage: AssetImage('assets/profile/jeevan.jpg'),
              ),
              title: Text('Jeevan Kumar Kushwaha'),
            ),
            ListTile(
              onTap: () async {
                await launch(
                    "https://www.linkedin.com/in/priyanka-mishra-911a3a34a?utm_source=share&utm_campaign=share_via&utm_content=profile&utm_medium=android_app");
              },
              leading: CircleAvatar(
                backgroundImage: AssetImage('assets/profile/priyanka.jpg'),
              ),
              title: Text('Priyanka Kumari Mishra'),
            ),
            SizedBox(height: 20),
            Text(
              'Other Information',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              'This app takes your privacy very seriously. We do not store any of your data on our servers. All the data is stored locally on your device.',
              style: TextStyle(fontSize: 16),
            ),
            Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                    onPressed: () async {
                      await launch("https://secretpixel.tech");
                    },
                    icon: Icon(FontAwesomeIcons.globe)),
                IconButton(onPressed: () {}, icon: Icon(Icons.api)),
                IconButton(
                    onPressed: () async {
                      await launch(
                          "https://www.facebook.com/share/18as3zZes8/");
                    },
                    icon: Icon(Icons.facebook)),
                IconButton(
                    onPressed: () async {
                      await launch(
                          "https://www.instagram.com/secretpixel_?igsh=MWc0MDdkMGQ5MnlucQ==");
                    },
                    icon: Icon(FontAwesomeIcons.instagram)),
                IconButton(
                    onPressed: () async {
                      await launch(
                          "https://x.com/secret_pixel_?t=2Z7Lawvglsk9yc2iCM5kMQ&s=08");
                    },
                    icon: Icon(FontAwesomeIcons.twitter)),
              ],
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Text(
                '@2025 Copyright',
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 14,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
