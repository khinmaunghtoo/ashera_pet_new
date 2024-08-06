import 'package:flutter/material.dart';

enum HomeBar{
  newPost,
  search,
  notify
}

extension HomeBarExtension on HomeBar {
  static List<IconData> icons = [
    Icons.add_circle_outline,
    Icons.search_outlined,
    Icons.notifications_none_outlined
  ];

  IconData get icon => icons[index];
}