enum RegisterButtonState{
  register,
  loading,
  tryAgain,
  error,
  success
}
extension RegisterButtonStateExtension on RegisterButtonState{
  static List<String> zhs = [
    '註冊',
    '讀取中',
    '重試',
    '失敗',
    '成功'
  ];

  String get zh => zhs[index];
}

enum RegMemberResCode{
  //失敗
  FAIL,
  //已綁定過
  LOGIN,
  //綁定成功
  SUCCESS
}