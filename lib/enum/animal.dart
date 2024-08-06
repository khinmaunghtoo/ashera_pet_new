enum AnimalGender{
  he,
  she
}

enum AnimalType{
  dog,
  cat
}

enum AnimalHealthStatus{
  good,
  sick,
  recuperate
}

extension AnimalGenderExt on AnimalGender{
  static List<String> zhs = [
    '男',
    '女'
  ];
  String get zh => zhs[index];
}


extension AnimalTypeExt on AnimalType{
  static List<String> zhs = [
    '狗',
    '貓'
  ];

  String get zh => zhs[index];
}

extension AnimalHealthStatusExt on AnimalHealthStatus{
  static List<String> zhs = [
    '健康',
    '生病',
    '走失'
  ];
  String get zh => zhs[index];
}