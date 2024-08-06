import 'dart:convert';

class AboutUsModel{
  final int id;
  final String about;


  const AboutUsModel({
    required this.id,
    required this.about,
  });

  factory AboutUsModel.fromMap(Map<String, dynamic> map){
    return AboutUsModel(
        id: map['id'] as int? ?? 0,
        about: map['about'] as String? ?? '',
        );
  }

  factory AboutUsModel.fromJson(String source) => AboutUsModel.fromMap(json.decode(source) as Map<String, dynamic>);

  Map<String, dynamic> toMap(){
    return {
      'id': id,
      'about': about
    };
  }

}