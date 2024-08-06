

enum FilterAnimalType{
  dog,
  cat,
  all,
}

extension AnimalTypeExt on FilterAnimalType{
  static List<String> zhs = [
    '狗狗',
    '貓咪',
    '全部'
  ];

  String get zh => zhs[index];
}

enum FilterHealthStatus{
  //健康
  healthy,
  //走失
  lost,
  //待領養
  toBeAdopted,
  //全部
  all
}

extension HealthStatusExtension on FilterHealthStatus{
  static List<String> zhs = [
    '健康',
    '走失',
    '待領養',
    '全部'
  ];

  String get zh => zhs[index];
}

enum FilterHealthStatusSort{
  //走失
  lost,
  //待領養
  toBeAdopted,
  //健康
  healthy,
}