class HeroViewParamsModel{
  final String tag;
  final dynamic data;
  final int index;
  final int duration;

  const HeroViewParamsModel({
    required this.tag,
    required this.data,
    required this.index,
    this.duration = 0
  });

}