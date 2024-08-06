//{"id":1,"pic":"/background/bg_1.jpg","status":1}
import 'dart:convert';

class PostBackgroundModel{
  final int id;
  final String pic;
  final int status;

  const PostBackgroundModel({
    required this.id,
    required this.pic,
    required this.status
  });

  factory PostBackgroundModel.fromMap(Map<String, dynamic> map){
    return PostBackgroundModel(
      id: map['id'] as int? ?? 0,
      pic: map['pic'] as String? ?? '',
      status: map['status'] as int? ?? 0
    );
  }

  factory PostBackgroundModel.fromJson(String source) => PostBackgroundModel.fromMap(json.decode(source));

  Map<String, dynamic> toMap(){
    return {
      'id': id,
      'pic': pic,
      'status': status
    };
  }
}