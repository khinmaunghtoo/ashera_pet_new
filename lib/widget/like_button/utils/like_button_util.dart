import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../../utils/app_color.dart';

num degToRad(num deg) => deg * (math.pi / 180.0);

num radToDeg(num rad) => rad * (180.0 / math.pi);

double mapValueFromRangeToRange(double value, double fromLow, double fromHigh,
    double toLow, double toHigh) {
  return toLow + ((value - fromLow) / (fromHigh - fromLow) * (toHigh - toLow));
}

double clamp(double value, double low, double high) {
  return math.min(math.max(value, low), high);
}

Widget defaultWidgetBuilder(bool isLiked, double size) {
  return Icon(
    isLiked ? Icons.favorite : Icons.favorite_outline,
    color: isLiked ? AppColor.like : AppColor.textFieldTitle,
    size: size,
  );
}