import 'package:flutter/material.dart';

class RobotoBoldStyle extends TextStyle {
  final double size;
  final Color fontColor;
  final String fontFam;
  final FontWeight weight;
  final double tHeight;

  const RobotoBoldStyle({
    this.size = 16,
    this.fontColor = Colors.black,
    this.fontFam = 'Roboto',
    this.weight = FontWeight.w700,
    this.tHeight = 1.5,
  }) : super(
          fontSize: size,
          color: fontColor,
          fontFamily: fontFam,
          fontWeight: weight,
          height: tHeight,
        );
}
