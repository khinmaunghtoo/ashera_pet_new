import 'dart:convert';

class RankingLikeKeepModel{
  final int count;
  final int memberPetId;

  const RankingLikeKeepModel({
    required this.count,
    required this.memberPetId
  });

  factory RankingLikeKeepModel.fromMap(Map<String, dynamic> map){
    return RankingLikeKeepModel(
        count: map['count'] as int? ?? 0,
        memberPetId: map['memberPetId'] as int? ?? 0
    );
  }

  factory RankingLikeKeepModel.fromJson(String source) => RankingLikeKeepModel.fromMap(json.decode(source) as Map<String, dynamic>);

  RankingLikeKeepModel copyWith({
    int? count,
    int? memberPetId,
  }){
    return RankingLikeKeepModel(
        count: count ?? this.count,
        memberPetId: memberPetId ?? this.memberPetId
    );
  }

  Map<String, dynamic> toMap(){
    return {
      'count': count,
      'memberPetId': memberPetId
    };
  }

  String toJson() => json.encode(toMap());

  @override
  bool operator ==(Object other) {
    if(identical(this, other)) return true;

    return other is RankingLikeKeepModel &&
    other.count == count &&
    other.memberPetId == memberPetId;
  }

  @override
  int get hashCode {
    return count.hashCode ^
    memberPetId.hashCode;
  }
}