import 'package:flutter/material.dart';
import '../core/pick_image.dart';

class EncodePage extends StatefulWidget {
  const EncodePage({super.key, required this.jumpTo});
  final void Function(int)? jumpTo;

  @override
  State<EncodePage> createState() => _EncodePageState();
}

class _EncodePageState extends State<EncodePage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  bool isloading = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.sizeOf(context).height;
    final width = MediaQuery.sizeOf(context).width;
    return Column(
      children: [
        SizedBox(height: height / 10),
        if (!isloading)
          Text(
            'Tap to Encode',
            style: TextStyle(
              fontSize: 20,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        AnimatedContainer(
          height: !isloading ? height / 4 : height / 10,
          duration: const Duration(milliseconds: 500),
        ),
        Row(
          children: [
            SizedBox(width: width / 35),
            GestureDetector(
              onTap: () {
                widget.jumpTo!(0);
              },
              child: Stack(
                children: [
                  CircleAvatar(
                    radius: 25,
                    backgroundColor: const Color.fromARGB(255, 45, 45, 45),
                  ),
                  Positioned(
                      left: width / 25,
                      top: height / 75,
                      child: Icon(Icons.arrow_back_ios,
                          color: Colors.white, size: 30))
                ],
              ),
            ),
            SizedBox(width: width / 4.3),
            AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                return GestureDetector(
                  onTap: () async {
                    setState(() {
                      isloading = !isloading;
                    });
                    final image = await Pick.pickImage();

                    if (image != null) {
                      Navigator.pushNamed(context, '/hideMsg',
                          arguments: image);
                    }
                    setState(() {
                      isloading = !isloading;
                    });
                  },
                  child: Transform.scale(
                    scale: _controller.value * 0.5 + 2.5,
                    child: CircleAvatar(
                      radius: 30,
                      backgroundColor: const Color.fromARGB(255, 45, 45, 45),
                      child: Icon(
                        Icons.fingerprint,
                        color: Colors.white,
                        size: 45,
                      ),
                    ),
                  ),
                );
              },
            ),
            SizedBox(width: width / 4.2),
            GestureDetector(
              onTap: () {
                widget.jumpTo!(2);
              },
              child: CircleAvatar(
                radius: 25,
                backgroundColor: const Color.fromARGB(255, 45, 45, 45),
                child: Icon(Icons.arrow_forward_ios,
                    color: Colors.white, size: 30),
              ),
            )
          ],
        ),
        SizedBox(height: height / 4),
        CircleAvatar(
          backgroundColor: const Color.fromARGB(255, 45, 45, 45),
          radius: 30,
          child: IconButton(
              onPressed: () async {
                final image = await Pick.openCamera();
                if (image != null) {
                  Navigator.pushNamed(context, '/hideMsg', arguments: image);
                }
              },
              icon: Icon(Icons.camera_alt_outlined,
                  color: Colors.white, size: 32)),
        ),
      ],
    );
  }
}
