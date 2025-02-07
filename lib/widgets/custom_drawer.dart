import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          DrawerHeader(
              decoration: BoxDecoration(
                image: DecorationImage(
                  opacity: 0.07,
                  image: AssetImage('assets/images/logo.png'),
                  fit: BoxFit.cover,
                ),
              ),
              child: Container(
                alignment: Alignment.topLeft,
              )),
          ListTile(
            leading: Icon(Icons.home, color: Colors.white),
            title: Text('Home', style: TextStyle(color: Colors.white)),
            onTap: () {
              // Handle the tap
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: Icon(Icons.email, color: Colors.white),
            title: Text('Email', style: TextStyle(color: Colors.white)),
            onTap: () {
              // Handle the tap
              Navigator.pop(context);
              launch('mailto:help.secretpixel@gmail.com');
            },
          ),
          ListTile(
            leading: Icon(Icons.share, color: Colors.white),
            title: Text('Share', style: TextStyle(color: Colors.white)),
            onTap: () {
              // Handle the tap
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: Icon(Icons.star, color: Colors.white),
            title: Text('Rate', style: TextStyle(color: Colors.white)),
            onTap: () {
              // Handle the tap
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: Icon(FontAwesomeIcons.crown, color: Colors.white),
            title: Text('Subscription', style: TextStyle(color: Colors.white)),
            onTap: () {
              // Handle the tap
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  behavior: SnackBarBehavior.floating,
                  margin: EdgeInsets.symmetric(
                      horizontal: MediaQuery.of(context).size.width / 3.4),
                  padding: EdgeInsets.only(
                    left: 20,
                    right: 20,
                    top: 10,
                    bottom: 10,
                  ),
                  content: Align(
                      alignment: Alignment.center, child: Text('Coming Soon')),
                ),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.info, color: Colors.white),
            title: Text('About', style: TextStyle(color: Colors.white)),
            onTap: () {
              // Handle the tap
              Navigator.pop(context);
              Navigator.pushNamed(context, '/about');
            },
          ),
          ListTile(
            leading: Icon(Icons.settings, color: Colors.white),
            title: Text('Settings', style: TextStyle(color: Colors.white)),
            onTap: () {
              // Handle the tap
              Navigator.pop(context);
              Navigator.pushNamed(context, '/setting');
            },
          ),
        ],
      ),
    );
  }
}
