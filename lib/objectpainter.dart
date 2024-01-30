import 'package:flutter/material.dart';

class ObjectPainter extends CustomPainter {
  final Animation animation;
  ObjectPainter({required this.animation}) : super(repaint: animation);
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()..color = Colors.red;

    canvas.translate(0, 10);
    Offset center = Offset(size.width / 2, animation.value);
    canvas.drawRect(
        Rect.fromCenter(center: center, width: 20, height: 20), paint);
  }

  @override
  bool shouldRepaint(ObjectPainter oldDelegate) {
    return true;
  }
}
