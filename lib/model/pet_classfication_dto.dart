import 'dart:convert';

import '../enum/animal.dart';

class PetClassficationReqDTO{
  final String pic;

  const PetClassficationReqDTO({
    required this.pic
  });

  Map<String, dynamic> toMap() => {
    'pic': pic
  };
}

class PetClassficationResDTO{
  final AnimalType? animalType;
  final double score;

  const PetClassficationResDTO({
    required this.animalType,
    required this.score
  });

  factory PetClassficationResDTO.fromMap(Map<String, dynamic> map){
    return PetClassficationResDTO(
        animalType: map['animalType'] != 'none' ? AnimalType.values.byName(map['animalType']) : null,
        score: map['score'] as double? ?? 0.0);
  }

  factory PetClassficationResDTO.fromJson(String source) => PetClassficationResDTO.fromMap(json.decode(source) as Map<String, dynamic>);

  Map<String, dynamic> toMap() => {
    'animalType': animalType,
    'score': score
  };
}