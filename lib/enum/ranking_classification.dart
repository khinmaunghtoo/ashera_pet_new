enum RankingClassificationEnum{
  //留言
  message,
  //粉絲
  fan,
  //按讚
  like,
  //收藏
  collection
}

extension RankingClassificationExtension on RankingClassificationEnum{
  static List<String> zhs = [
    '最多留言',
    '最多關注',
    '最多愛心',
    '最多收藏'
  ];

  String get zh => zhs[index];
}