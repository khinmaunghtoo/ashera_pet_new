import 'package:flutter/material.dart';

import '../utils/app_color.dart';

enum HealthStatus{
  //健康
  healthy,
  //走失
  lost,
  //待領養
  toBeAdopted
}

extension HealthStatusExtension on HealthStatus{
  static List<String> zhs = [
    '健康',
    '走失',
    '待領養'
  ];

  static List<Color> colors = [
    AppColor.healthy,
    AppColor.lost,
    AppColor.toBeAdopted
  ];

  static List<int> sortIndexs = [
    1,
    0,
    2
  ];

  String get zh => zhs[index];
  Color get color => colors[index];
  int get sortIndex => sortIndexs[index];
}