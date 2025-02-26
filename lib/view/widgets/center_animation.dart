import '/core/pick_image_file.dart';
import 'package:flutter/material.dart';
import 'package:gif/gif.dart';
import '../../theme/theme_color.dart';

Widget centerAnimation(BuildContext context, GifController controller,
    VoidCallback toggleLoading, String navigation) {
  final height = MediaQuery.sizeOf(context).height;
  final width = MediaQuery.sizeOf(context).width;
  return GestureDetector(
    onTap: () async {
      toggleLoading();
      final image = await Pick.pickImage();
      toggleLoading();
      if (image != null) {
        controller.reset();
        controller.forward();
        //Navite to next page
        Navigator.pushNamed(context, navigation, arguments: image);
      }
      return;
    },
    child: Stack(
      children: [
        Gif(
          color: GetColor.textColor(context),
          height: height / 2,
          width: width / 1.7,
          image: AssetImage(
            "assets/animation/secure.gif",
          ),
          controller: controller,
          duration: const Duration(seconds: 10),
          autostart: Autostart.loop,
          placeholder: (context) => SizedBox(
              height: height / 2,
              width: width / 2,
              child: Center(child: const SizedBox())),
          onFetchCompleted: () {
            controller.reset();
            controller.forward();
          },
        ),
        Positioned(
            top: height / 4.9,
            left: width / 5.3,
            child: Icon(
              Icons.fingerprint,
              size: height / 11,
            ))
      ],
    ),
  );
}
