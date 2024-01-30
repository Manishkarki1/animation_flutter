import 'package:flutter/material.dart';

class WebPainter extends CustomPainter {
  final Offset springOffset;
  final Paint sprintPaint = Paint()
    ..color = Colors.blue
    ..strokeWidth = 2
    ..style = PaintingStyle.stroke;
  WebPainter({this.springOffset = const Offset(0.0, 0.0)});
  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);
    canvas.drawLine(center, center + springOffset, sprintPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    // TODO: implement shouldRepaint
    return false;
  }
}
