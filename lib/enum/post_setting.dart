enum PostSetting{
  //編輯
  edit,
  //刪除
  delete,
  //檢舉
  report,
  //取消
  cancel
}

extension PostSettingExtension on PostSetting{
  static List<String> zhs = [
    '編輯',
    '刪除',
    '檢舉',
    '取消'
  ];

  String get zh => zhs[index];
}