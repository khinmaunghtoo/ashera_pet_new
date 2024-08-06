import 'dart:math' as math;

import 'package:flutter/material.dart';

class WaterRipplePainter extends CustomPainter{
  final double progress;
  final int count;
  final Color color;

  final Paint _paint = Paint()..style = PaintingStyle.fill;

  WaterRipplePainter(this.progress, {this.count = 5, this.color = Colors.white});

  @override
  void paint (Canvas canvas, Size size){
    double radius = math.min(size.width / 2, size.height / 2);
    for(int i = count; i >= 0; i--){
      final double opacity = (1.0 - ((i + progress) / (count + 1)));

      if(opacity >= 0.0 && opacity <= 1.0){
        final Color _color = color.withOpacity(opacity);
        _paint.color = _color;
      }

      double radius0 = radius * ((i + progress) / (count + 1));

      canvas.drawCircle(Offset(size.width / 2, size.height / 2), radius0, _paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }


}