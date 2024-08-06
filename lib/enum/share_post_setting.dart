enum SharePostSetting {
  //轉發
  //forward,
  //分享
  share,
  //取消
  cancel
}

extension SharePostSettingExtension on SharePostSetting{
  static List<String> zhs = [
    //'轉發',
    '分享',
    '取消'
  ];

  String get zh => zhs[index];
}