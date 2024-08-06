import 'package:bootstrap_icons/bootstrap_icons.dart';
import 'package:flutter/cupertino.dart';

import '../utils/app_color.dart';

enum GenderEnum{
  man,
  woman,
  //other,
}
extension GenderEnumExtension on GenderEnum{
  static List<String> zhs = [
    '男生',
    '女生',
    //'其他',
  ];

  static List<String> petZhs = [
    '公',
    '母'
  ];

  static const List<IconData> icons =[
    BootstrapIcons.gender_male,
    BootstrapIcons.gender_female,
  ];

  static const List<Color> colors = [
    AppColor.male,
    AppColor.female
  ];

  String get zh => zhs[index];
  String get petZh => petZhs[index];
  IconData get icon => icons[index];
  Color get color => colors[index];
}