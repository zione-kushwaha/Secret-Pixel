import '/constants/constant.dart';
import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class InformationView extends StatelessWidget {
  const InformationView({super.key, required this.jumpTo});
  final void Function(int)? jumpTo;

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.sizeOf(context).height;
    final width = MediaQuery.sizeOf(context).width;
    return Column(
      children: [
        _headerSeaction(height, width),
        Padding(
          padding: EdgeInsets.only(
              left: width / 50, right: width / 50, top: height / 40),
          child: Column(
            spacing: height / 400,
            children: [
              _buildListTile(height, width, 'Home', Icons.home, () {
                jumpTo!(1);
              }),
              _buildListTile(height, width, 'Email Us', Icons.email, () async {
                launchUrl(Uri.parse('mailto:helpsecretpixel@gmail.com'));
                // launch('mailto:helpsecretpixel@gmail.com');
              }),
              _buildListTile(height, width, 'Share', Icons.share, () {
                Share.shareUri(Uri.parse(
                    'https://play.google.com/store/apps/details?id=com.secretpixel'));
              }),
              _buildListTile(height, width, 'Rate Us', Icons.star, () {
                launchUrl(Uri.parse(
                    'https://play.google.com/store/apps/details?id=com.secretpixel'));
              }),
              _buildListTile(height, width, 'About', Icons.info, () {
                Navigator.pushNamed(context, '/about');
              }),
              _buildListTile(height, width, 'Settings', Icons.settings, () {
                Navigator.pushNamed(context, '/settings');
              }),
              _buildListTile(height, width, 'More Apps', Icons.more, () {
                launchUrl(Uri.parse(
                    'https://play.google.com/store/apps/details?id=com.amibeats'));
              }),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildListTile(double height, double width, String title,
      IconData icon, Function() onTap) {
    return InkWell(
      borderRadius: BorderRadius.circular(width / 10),
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(5.0),
        child: Container(
          height: height / 18,
          width: double.infinity,
          decoration: BoxDecoration(
            color: blackColor,
            borderRadius: BorderRadius.circular(width / 10),
          ),
          child: Padding(
            padding: const EdgeInsets.only(left: 20),
            child: Row(
              children: [
                SizedBox(width: width / 20),
                Icon(icon, color: Colors.white),
                SizedBox(width: width / 30),
                Text(title,
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold)),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _headerSeaction(double? height, double? width) {
    return Container(
      height: height! / 12,
      margin: EdgeInsets.only(
          top: height / 50, left: width! / 50, right: width / 50),
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.grey.shade900,
        borderRadius: BorderRadius.all(Radius.circular(20)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 5,
            offset: Offset(0, 0.5), // changes position of shadow
          ),
        ],
      ),
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 20),
            child: CircleAvatar(
              radius: 20,
              backgroundColor: Colors.white,
              backgroundImage: AssetImage('assets/images/logo.gif'),
            ),
          ),
          SizedBox(
            width: 20,
          ),
          Text(
            'Secret Pixel',
            style: TextStyle(
                color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
          ),
          Spacer(),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: IconButton(
                onPressed: () {
                  jumpTo!(1);
                },
                icon: Icon(Icons.close, color: Colors.white, size: 30)),
          )
        ],
      ),
    );
  }
}
