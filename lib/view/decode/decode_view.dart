import '/view/widgets/center_animation.dart';
import 'package:flutter/material.dart';
import 'package:gif/gif.dart';
import '../../theme/theme_color.dart';

class DecodePage extends StatefulWidget {
  const DecodePage({super.key, required this.jumpTo});
  final void Function(int)? jumpTo;

  @override
  State<DecodePage> createState() => _DecodePageState();
}

class _DecodePageState extends State<DecodePage>
    with SingleTickerProviderStateMixin {
  late GifController _controller;
  bool isloading = false;

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
    final height = MediaQuery.sizeOf(context).height;
    final width = MediaQuery.sizeOf(context).width;

    return SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(height: height / 15),
          if (!isloading)
            Text(
              'Tap to Decode',
              style: TextStyle(
                  fontSize: 21,
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
              _buildBackButtom(height, width, Icons.arrow_back_ios, 1),

              // showing the animation
              centerAnimation(context, _controller, toggleLoading, '/decode'),
              _buildBackButtom(height, width, Icons.arrow_forward_ios, 0)
            ],
          ),
        ],
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
