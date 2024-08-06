import 'dart:convert';

class ReportSystemSettingModel{
  final int id;
  final String rankingListMessageUuid;
  final String rankingListFollowerUuid;
  final String rankingListPostLikeUuid;
  final String rankingListWatchUuid;
  final int rankingListMessageLastUpdateAt;
  final int rankingListFollowerLastUpdateAt;
  final int rankingListPostLikeLastUpdateAt;
  final int rankingListWatchLastUpdateAt;
  final int rankingListLimit;

  const ReportSystemSettingModel({
    required this.id,
    required this.rankingListMessageUuid,
    required this.rankingListFollowerUuid,
    required this.rankingListPostLikeUuid,
    required this.rankingListWatchUuid,
    required this.rankingListMessageLastUpdateAt,
    required this.rankingListFollowerLastUpdateAt,
    required this.rankingListPostLikeLastUpdateAt,
    required this.rankingListWatchLastUpdateAt,
    required this.rankingListLimit
  });

  factory ReportSystemSettingModel.fromMap(Map<String, dynamic> map) {
    return ReportSystemSettingModel(
        id: map['id'] as int? ?? 0,
        rankingListMessageUuid: map['rankingListMessageUuid'] as String? ?? '',
        rankingListFollowerUuid: map['rankingListFollowerUuid'] as String? ?? '',
        rankingListPostLikeUuid: map['rankingListPostLikeUuid'] as String? ?? '',
        rankingListWatchUuid: map['rankingListWatchUuid'] as String? ?? '',
        rankingListMessageLastUpdateAt: map['rankingListMessageLastUpdateAt'] as int? ?? 0,
        rankingListFollowerLastUpdateAt: map['rankingListFollowerLastUpdateAt'] as int? ?? 0,
        rankingListPostLikeLastUpdateAt: map['rankingListPostLikeLastUpdateAt'] as int? ?? 0,
        rankingListWatchLastUpdateAt: map['rankingListWatchLastUpdateAt'] as int? ?? 0,
        rankingListLimit: map['rankingListLimit'] as int? ?? 0);
  }

  factory ReportSystemSettingModel.fromJson(String source) => ReportSystemSettingModel.fromMap(json.decode(source) as Map<String, dynamic>);

  ReportSystemSettingModel copyWith({
    int? id,
    String? rankingListMessageUuid,
    String? rankingListFollowerUuid,
    String? rankingListPostLikeUuid,
    String? rankingListWatchUuid,
    int? rankingListMessageLastUpdateAt,
    int? rankingListFollowerLastUpdateAt,
    int? rankingListPostLikeLastUpdateAt,
    int? rankingListWatchLastUpdateAt,
    int? rankingListLimit
  }){
    return ReportSystemSettingModel(
        id: id ?? this.id,
        rankingListMessageUuid: rankingListMessageUuid ?? this.rankingListMessageUuid,
        rankingListFollowerUuid: rankingListFollowerUuid ?? this.rankingListFollowerUuid,
        rankingListPostLikeUuid: rankingListPostLikeUuid ?? this.rankingListPostLikeUuid,
        rankingListWatchUuid: rankingListWatchUuid ?? this.rankingListWatchUuid,
        rankingListMessageLastUpdateAt: rankingListMessageLastUpdateAt ?? this.rankingListMessageLastUpdateAt,
        rankingListFollowerLastUpdateAt: rankingListFollowerLastUpdateAt ?? this.rankingListFollowerLastUpdateAt,
        rankingListPostLikeLastUpdateAt: rankingListPostLikeLastUpdateAt ?? this.rankingListPostLikeLastUpdateAt,
        rankingListWatchLastUpdateAt: rankingListWatchLastUpdateAt ?? this.rankingListWatchLastUpdateAt,
        rankingListLimit: rankingListLimit ?? this.rankingListLimit
    );
  }

  Map<String, dynamic> toMap(){
    return {
      'id': id,
      'rankingListMessageUuid': rankingListMessageUuid,
      'rankingListFollowerUuid': rankingListFollowerUuid,
      'rankingListPostLikeUuid': rankingListPostLikeUuid,
      'rankingListWatchUuid': rankingListWatchUuid,
      'rankingListMessageLastUpdateAt': rankingListMessageLastUpdateAt,
      'rankingListFollowerLastUpdateAt': rankingListFollowerLastUpdateAt,
      'rankingListPostLikeLastUpdateAt': rankingListPostLikeLastUpdateAt,
      'rankingListWatchLastUpdateAt': rankingListWatchLastUpdateAt,
      'rankingListLimit': rankingListLimit
    };
  }

  String toJson() => json.encode(toMap());


}