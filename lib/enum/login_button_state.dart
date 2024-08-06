enum LoginButtonState{
  login,
  loading,
  tryAgain,
  error,
  success
}

extension LoginButtonStateExtension on LoginButtonState{
  static List<String> zhs = [
    '登入',
    '讀取中',
    '重試',
    '失敗',
    '成功'
  ];

  String get zh => zhs[index];
}