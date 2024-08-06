import 'package:ashera_pet_new/widget/water_ripple/water_ripple_painter.dart';
import 'package:flutter/material.dart';

class WaterRipple extends StatefulWidget {
  final int count;
  final Color color;

  const WaterRipple({super.key, this.count = 5, this.color = Colors.white});

  @override
  State<StatefulWidget> createState() => _WaterRippleState();
}

class _WaterRippleState extends State<WaterRipple>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    _controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 1500))
      ..repeat();
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return CustomPaint(
            painter: WaterRipplePainter(_controller.value,
                count: widget.count, color: widget.color),
          );
        });
  }
}
