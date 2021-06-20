import 'dart:ui';

import 'package:flutter/material.dart';

class Point {
  final double x;
  final double y;

  Point(this.x, this.y);
}

class BackgroundPainter extends CustomPainter {
  final Paint darkYellow;
  final Paint yellow;
  final Paint lightYellow;

  BackgroundPainter()
      : darkYellow = Paint()
          ..color = Color.fromRGBO(255, 199, 0, 1.0)
          ..style = PaintingStyle.fill,
        yellow = Paint()
          ..color = Color.fromRGBO(255, 228, 132, 1.0)
          ..style = PaintingStyle.fill,
        lightYellow = Paint()
          ..color = Color.fromRGBO(255, 236, 170, 1.0)
          ..style = PaintingStyle.fill;

  @override
  void paint(Canvas canvas, Size size) {
    paintLightYellow(size, canvas);

    paintYellow(size, canvas);
    paintDarkYellow(size, canvas);
  }

  void paintDarkYellow(Size size, Canvas canvas) {
    final path = Path();

    path.moveTo(size.width, 0);
    path.lineTo(0, 0);

    path.lineTo(0, size.height * 0.2);
    _addPointsToPath(path, [
      Point(
        size.width * 0.35,
        size.height * 0.1,
      ),
      Point(
        size.width * 0.90,
        size.height * 0.36,
      ),
      Point(
        size.width,
        size.height * 0.34,
      ),
    ]);

    canvas.drawPath(path, darkYellow);
  }

  void paintYellow(Size size, Canvas canvas) {
    final path = Path();

    path.moveTo(size.width, 0);
    path.lineTo(0, 0);
    path.lineTo(0, size.height * 0.2);

    _addPointsToPath(
      path,
      [
        Point(
          size.width * 0.35,
          size.height * 0.13,
        ),
        Point(size.width * 0.60, size.height * 0.25),
        Point(
          size.width * 0.85,
          size.height * 0.41,
        ),
        Point(
          size.width,
          size.height * 0.40,
        ),
      ],
    );

    canvas.drawPath(path, yellow);
  }

  void paintLightYellow(Size size, Canvas canvas) {
    final path = Path();

    path.moveTo(size.width, 0);
    path.lineTo(0, 0);
    path.lineTo(0, size.height * 0.3);

    _addPointsToPath(path, [
      Point(
        size.width * 0.45,
        size.height * 0.13,
      ),
      Point(
        size.width * 0.85,
        size.height * 0.45,
      ),
      Point(
        size.width,
        size.height * 0.44,
      ),
    ]);

    canvas.drawPath(path, lightYellow);
  }

  void _addPointsToPath(Path path, List<Point> points) {
    if (points.length < 3) {
      throw UnsupportedError('Need 3+ points to create a path.');
    }

    for (var i = 0; i < points.length - 2; i++) {
      final xDiff = (points[i].x + points[i + 1].x) / 2;
      final yDiff = (points[i].y + points[i + 1].y) / 2;
      path.quadraticBezierTo(points[i].x, points[i].y, xDiff, yDiff);
    }

    final secondLastPoint = points[points.length - 2];
    final lastPoint = points[points.length - 1];
    path.quadraticBezierTo(
        secondLastPoint.x, secondLastPoint.y, lastPoint.x, lastPoint.y);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
