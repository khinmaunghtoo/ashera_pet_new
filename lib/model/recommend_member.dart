import 'dart:convert';

class RecommendMemberModel{
  final int id;
  final int memberId;
  final int recommendMemberId;
  final int recommendMemberPetId;

  const RecommendMemberModel({
    required this.id,
    required this.memberId,
    required this.recommendMemberId,
    required this.recommendMemberPetId
  });

  factory RecommendMemberModel.fromMap(Map<String, dynamic> map){
    return RecommendMemberModel(
        id: map['id'] as int? ?? 0,
        memberId: map['memberId'] as int? ?? 0,
        recommendMemberId: map['recommendMemberId'] as int? ?? 0,
        recommendMemberPetId: map['recommendMemberPetId'] as int? ?? 0
    );
  }

  factory RecommendMemberModel.fromJson(String source) => RecommendMemberModel.fromMap(json.decode(source) as Map<String, dynamic>);

  RecommendMemberModel copyWith({
    int? id,
    int? memberId,
    int? recommendMemberId,
    int? recommendMemberPetId
  }) {
    return RecommendMemberModel(
        id: id ?? this.id,
        memberId: memberId ?? this.memberId,
        recommendMemberId: recommendMemberId ?? this.recommendMemberId,
        recommendMemberPetId: recommendMemberPetId ?? this.recommendMemberPetId
    );
  }

  Map<String, dynamic> toMap(){
    return {
      'id': id,
      'memberId': memberId,
      'recommendMemberId': recommendMemberId,
      'recommendMemberPetId': recommendMemberPetId
    };
  }

  String toJson() => json.encode(toMap());

  @override
  bool operator ==(Object other) {
    if(identical(this, other)) return true;

    return other is RecommendMemberModel &&
    other.id == id &&
    other.memberId == memberId &&
    other.recommendMemberId == recommendMemberId &&
    other.recommendMemberPetId == recommendMemberPetId;
  }

  @override
  int get hashCode {
    return id.hashCode ^
    memberId.hashCode ^
    recommendMemberId.hashCode ^
    recommendMemberPetId.hashCode;
  }
}