import 'package:flutter/material.dart';

enum MeBar{
  newPost,
  menu
}

extension MeBarExtension on MeBar{
  static List<IconData> icons = [
    Icons.add_circle_outline,
    Icons.settings_outlined
  ];

  IconData get icon => icons[index];
}