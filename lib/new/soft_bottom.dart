import 'package:flutter/material.dart';

// ignore: must_be_immutable
class CircularSoftButton extends StatelessWidget {
  double? radius;
  final Widget? icon;
  final Color lightColor;
  final double? padding;
  final double? circularRadius;
  CircularSoftButton(
      {super.key,
      this.radius,
      this.icon,
      this.lightColor = Colors.white,
      this.padding,
      this.circularRadius}) {
    if (radius == null || radius! <= 0) radius = 32;
  }
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(padding ?? radius! / 2),
      child: Stack(
        children: <Widget>[
          Container(
            width: radius! * 2,
            height: radius! * 2,
            decoration: BoxDecoration(
              color: Colors.grey,
              borderRadius: BorderRadius.circular(circularRadius ?? radius!),
              boxShadow: [
                BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    offset: Offset(8, 6),
                    blurRadius: 12),
                BoxShadow(
                    color: lightColor, offset: Offset(-3, -1), blurRadius: 5),
              ],
            ),
          ),
          Positioned.fill(child: icon ?? Container()),
        ],
      ),
    );
  }
}
