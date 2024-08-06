enum NotifyTimeType{
  thisWeek,
  thisMonth,
  earlier
}

extension NotifyTimeTypeExtension on NotifyTimeType{

  static List<String> zhs = [
    '本週',
    '本月',
    '更早之前'
  ];

  String get zh => zhs[index];
}