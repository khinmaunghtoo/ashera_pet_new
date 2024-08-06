enum AdoptReportType{
  adoptReport,
  adoptReported,
}

extension AdoptReportTypeExtension on AdoptReportType{
  static final List<String> _zhs = [
    '檢舉內容',
    '違規內容'
  ];

  String get zh => _zhs[index];
}