import 'package:flutter/material.dart';

enum MenuEnum{
  //辨識紀錄
  //identificationRecord,
  //編輯主人資料
  editUserProfile,
  //變更密碼
  changePassword,
  //封鎖名單
  blockList,
  //檢舉紀錄
  report,
  //關於ashera pet
  aboutAsheraPet,
  //意見及問題反饋
  commentsAndFeedback,
  //登出
  signOut,
  //註銷
  logOut
}

extension MenuExtension on MenuEnum{
  static List<String> zhs = [
    //'辨識紀錄',
    '編輯主人資料',
    '變更密碼',
    '封鎖名單',
    '檢舉紀錄',
    '關於ashera pet',
    '意見及問題反饋',
    '登出',
    '註銷'
  ];

  static List<IconData> icons = [
    //Icons.text_snippet_outlined,
    Icons.person_outline,
    Icons.lock_outline,
    Icons.block,
    Icons.report_outlined,
    Icons.info_outline,
    Icons.help_outline,
    Icons.logout_outlined,
    Icons.person_remove_alt_1_outlined,
  ];

  String get zh => zhs[index];
  IconData get icon => icons[index];
}