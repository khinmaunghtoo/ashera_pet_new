import 'dart:convert';

import 'package:ashera_pet_new/enum/animal.dart';

class FaceDetectModel {
  final int memberId;
  final AnimalType animalType;
  final String pic;

  const FaceDetectModel(
      {required this.memberId, required this.animalType, required this.pic});

  Map<String, dynamic> toApi() {
    return {'memberId': memberId, 'animalType': animalType.index, 'pic': pic};
  }
}

//[{"pic":"0922018551_pet.jpg","memberPetId":55}]
class FaceDetectResponseModel {
  final int memberPetId;
  final String pic;
  final double similarity;

  const FaceDetectResponseModel(
      {required this.memberPetId, required this.pic, required this.similarity});

  factory FaceDetectResponseModel.fromMap(Map<String, dynamic> map) {
    return FaceDetectResponseModel(
        memberPetId: map['memberPetId'] as int? ?? 0,
        pic: map['pic'] as String? ?? '',
        similarity: map['similarity'] as double? ?? 0.0);
  }

  factory FaceDetectResponseModel.fromJson(String source) =>
      FaceDetectResponseModel.fromMap(
          json.decode(source) as Map<String, dynamic>);

  FaceDetectResponseModel copyWith(
      {int? memberPetId, String? pic, double? similarity}) {
    return FaceDetectResponseModel(
        memberPetId: memberPetId ?? this.memberPetId,
        pic: pic ?? this.pic,
        similarity: similarity ?? this.similarity);
  }

  Map<String, dynamic> toMap() {
    return {
      'memberPetId': memberPetId,
      'pic': pic,
      'similarity': similarity,
    };
  }

  String toJson() => json.encode(toMap());

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is FaceDetectResponseModel &&
        other.memberPetId == memberPetId &&
        other.pic == pic &&
        other.similarity == similarity;
  }

  @override
  int get hashCode {
    return memberPetId.hashCode ^ pic.hashCode ^ similarity.hashCode;
  }
}
