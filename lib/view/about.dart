import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class About extends StatelessWidget {
  const About({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('About'),
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
              title: Text('Dipesh prasad Acharya'),
            ),
            ListTile(
              onTap: () => launch("https://www.linkedin.com/in/zi-one"),
              leading: CircleAvatar(
                backgroundImage: AssetImage('assets/profile/jeevan.jpg'),
              ),
              title: Text('Jeevan Kumar Kushwaha'),
            ),
            ListTile(
              leading: CircleAvatar(
                backgroundImage: AssetImage('assets/images/logo.png'),
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
                    onPressed: () {}, icon: Icon(FontAwesomeIcons.globe)),
                IconButton(onPressed: () {}, icon: Icon(Icons.api)),
                IconButton(onPressed: () {}, icon: Icon(Icons.facebook)),
                IconButton(
                    onPressed: () {}, icon: Icon(FontAwesomeIcons.instagram)),
                IconButton(
                    onPressed: () {}, icon: Icon(FontAwesomeIcons.twitter)),
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
