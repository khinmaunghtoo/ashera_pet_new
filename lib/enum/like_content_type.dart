enum LikeContentType {
  like,
  beLike
}

extension LikeContentTypeExtension on LikeContentType{
  static final List<String> _zhs = [
    '喜歡',
    '被喜歡'
  ];

  String get zh => _zhs[index];
}