enum TabBarEnum{
  //辨識過我的
  identifiedMe,
  //我辨識過的
  meIdentified
}

extension TabBarEnumExtension on TabBarEnum{
  static List<String> zhs = [
    '看過我的',
    '我看過的'
  ];

  String get zh => zhs[index];
}

enum FollowerTabBarEnum{
  //跟隨中
  followerMe,
  //追隨中
  myFollower
}

extension FollowTabBarEnumExtension on FollowerTabBarEnum{
  static List<String> zhs = [
    '粉絲',
    '追蹤中'
  ];
  String get zh => zhs[index];
}