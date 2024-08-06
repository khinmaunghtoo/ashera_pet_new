import 'package:flutter/material.dart';

enum ComplaintRecordStatus {
  APPROVAL_WAIT,
  APPROVAL_OK,
  REJECT,
  WAITING_REPLY,
}

extension ComplaintRecordStatusExtension on ComplaintRecordStatus{
  static final List<String> _zhs = [
    "待審核",
    "成立",
    "不成立",
    "等待回覆",
  ];

  static final List<Color> _colors = [
    Colors.amber,
    Colors.green,
    Colors.red,
    Colors.amber
  ];

  String get zh => _zhs[index];
  Color get color => _colors[index];
}