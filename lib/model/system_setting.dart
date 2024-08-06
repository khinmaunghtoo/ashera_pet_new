import 'dart:convert';

class SystemSettingModel{
  final int id;
  final String appVersionNumber;
  final String appleStoreAppUrl;
  final String playStoreAppUrl;

  const SystemSettingModel({
    required this.id,
    required this.appVersionNumber,
    required this.appleStoreAppUrl,
    required this.playStoreAppUrl
  });

  factory SystemSettingModel.fromMap(Map<String, dynamic> map){
    return SystemSettingModel(
        id: map['id'] as int? ?? 0,
        appVersionNumber: map['appVersionNumber'] as String? ?? '',
        appleStoreAppUrl: map['appleStoreAppUrl'] as String? ?? '',
        playStoreAppUrl: map['playStoreAppUrl'] as String? ?? '',
    );
  }

  factory SystemSettingModel.fromJson(String source) => SystemSettingModel.fromMap(json.decode(source) as Map<String, dynamic>);

  Map<String, dynamic> toMap(){
    return {
      'id': id,
      'appVersionNumber': appVersionNumber,
      'appleStoreAppUrl': appleStoreAppUrl,
      'playStoreAppUrl': playStoreAppUrl
    };
  }

  String toJson() => json.encode(toMap());
}