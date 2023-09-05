import 'package:flutter/material.dart';
class MyClipperClass extends CustomClipper<Rect>{
  @override
  getClip(Size size) {
    return Rect.fromLTWH(2, 2, 200, 200);
  }

  @override
  bool shouldReclip(covariant CustomClipper oldClipper) {
    return false;
  }
}
