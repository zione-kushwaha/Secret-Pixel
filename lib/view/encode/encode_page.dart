import 'dart:io';

import '/core/pick_image_file.dart';
import '/theme/theme_color.dart';
import 'package:flutter/material.dart';
import 'package:gif/gif.dart';
import '../widgets/center_animation.dart';

class EncodePage extends StatefulWidget {
  const EncodePage({super.key, required this.jumpTo});
  final void Function(int)? jumpTo;

  @override
  State<EncodePage> createState() => _EncodePageState();
}

class _EncodePageState extends State<EncodePage>
    with SingleTickerProviderStateMixin {
  late GifController _controller;
  bool isloading = false;
  File? image;

  @override
  void initState() {
    super.initState();
    _controller = GifController(vsync: this);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void toggleLoading() {
    setState(() {
      isloading = !isloading;
    });
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    return Column(
      children: [
        SizedBox(height: height / 15),
        if (!isloading)
          Text(
            'Tap to Encode',
            style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: GetColor.textColor(context)),
          ),
        AnimatedContainer(
          height: !isloading ? height / 20 : height / 1000,
          duration: const Duration(milliseconds: 500),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildBackButtom(height, width, Icons.arrow_back_ios, 0),
            centerAnimation(context, _controller, toggleLoading, '/encode'),
            _buildBackButtom(height, width, Icons.arrow_forward_ios, 2)
          ],
        ),
        _buildOpenCameraButton(height, width),
        SizedBox(height: height / 20),
      ],
    );
  }

  Widget _buildOpenCameraButton(double high, double width) {
    return InkWell(
      borderRadius: BorderRadius.circular(100),
      onTap: () async {
        setState(() {
          isloading = true;
        });
        image = await Pick.openCamera();
        setState(() {
          isloading = false;
        });
        if (image != null) {
          _controller.reset();
          _controller.forward();
          //Navigate to Encode page
          Navigator.pushNamed(context, '/encode', arguments: image);
        }
      },
      child: Padding(
        padding: EdgeInsets.all(width / 30),
        child: CircleAvatar(
          backgroundColor: const Color.fromARGB(255, 45, 45, 45),
          radius: width / 11,
          child: Icon(
            Icons.camera_alt_outlined,
            size: width / 13,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  Widget _buildBackButtom(double high, double width, IconData icon, int index) {
    return InkWell(
      borderRadius: BorderRadius.circular(width / 2),
      onTap: () {
        widget.jumpTo!(index);
      },
      child: Padding(
        padding: EdgeInsets.all(width / 30),
        child: CircleAvatar(
            backgroundColor: const Color.fromARGB(255, 45, 45, 45),
            radius: width / 15,
            child: Icon(
              icon,
              size: width / 20,
              color: Colors.white,
            )),
      ),
    );
  }
}
