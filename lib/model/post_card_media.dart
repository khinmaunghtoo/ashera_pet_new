
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';

//媒體
class PostCardMediaModel{
  final String? title;
  final int typeInt;
  final int height;
  final int width;
  final int duration;
  final File? file;
  final Uint8List? thumbnailData;
  final int sharedPostId;

  Size get size => Size(width.toDouble(), height.toDouble());

  AssetType get type => AssetType.values[typeInt];

  Duration get videoDuration => Duration(seconds: duration);

  const PostCardMediaModel({
    required this.title,
    required this.typeInt,
    required this.height,
    required this.width,
    required this.duration,
    required this.file,
    required this.thumbnailData,
    this.sharedPostId = 0
  });

  factory PostCardMediaModel.fromMap(Map<String, dynamic> map){
    return PostCardMediaModel(
        title: map['title'] as String? ?? '',
        typeInt: map['type'] as int? ?? 0,
        height: map['height'] as int? ?? 0,
        width: map['width'] as int? ?? 0,
        duration: map['duration'] as int? ?? 0,
        file: map['file'] as File?,
        thumbnailData: map['thumbnailData'] as Uint8List?,
        sharedPostId: map['sharedPostId'] as int? ?? 0
    );
  }

  factory PostCardMediaModel.fromJson(String source) => PostCardMediaModel.fromMap(json.decode(source) as Map<String, dynamic>);

  PostCardMediaModel copyWith({
    String? title,
    int? typeInt,
    int? height,
    int? width,
    int? duration,
    File? file,
    Uint8List? thumbnailData,
    int? sharedPostId
  }){
    return PostCardMediaModel(
        title: title ?? this.title,
        typeInt: typeInt ?? this.typeInt,
        height: height ?? this.height,
        width: width ?? this.width,
        duration: duration ?? this.duration,
        file: file ?? this.file,
        thumbnailData: thumbnailData ?? this.thumbnailData,
        sharedPostId: sharedPostId ?? this.sharedPostId
    );
  }

  Map<String, dynamic> toMap(){
    return {
      'title': title,
      'typeInt': typeInt,
      'height': height,
      'width': width,
      'duration': duration,
      'file': file,
      'thumbnailData': thumbnailData,
      'sharedPostId': sharedPostId
    };
  }

  String toJson() => json.encode(toMap());

  @override
  String toString() {
    return '''PostCardMediaModel(title: $title, typeInt: $typeInt, height: $height, width: $width, duration: $duration, file: $file, thumbnailData: $thumbnailData)''';
  }

  @override
  bool operator ==(Object other) {
    if(identical(this, other))return true;
    return other is PostCardMediaModel &&
        other.title == title &&
        other.typeInt == typeInt &&
        other.height == height &&
        other.width == width &&
        other.duration == duration &&
        other.file == file &&
        other.thumbnailData == thumbnailData &&
        other.sharedPostId == sharedPostId;
  }

  @override
  int get hashCode {
    return title.hashCode ^
    typeInt.hashCode ^
    height.hashCode ^
    width.hashCode ^
    duration.hashCode ^
    file.hashCode ^
    thumbnailData.hashCode ^
    sharedPostId.hashCode;
  }
}