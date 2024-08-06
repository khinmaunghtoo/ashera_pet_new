class MemberPetLikeModel{
  final int id;
  final bool iKeep;
  final bool iLike;
  final int memberId;
  final int memberPetId;
  final int likeAt;
  final int keepAt;
  final int petMemberId;

  const MemberPetLikeModel({
    this.id = 0,
    this.iKeep = false,
    this.iLike = false,
    required this.memberId,
    required this.memberPetId,
    this.likeAt = 0,
    this.keepAt = 0,
    this.petMemberId = 0
  });

  factory MemberPetLikeModel.fromMap(Map<String, dynamic> map){
    return MemberPetLikeModel(
        id: map['id'] as int? ?? 0,
        iKeep: map['ikeep'] as bool? ?? false,
        iLike: map['ilike'] as bool? ?? false,
        memberId: map['memberId'] as int? ?? 0,
        memberPetId: map['memberPetId'] as int? ?? 0,
        likeAt: map['likeAt'] as int? ?? 0,
        keepAt: map['keepAt'] as int? ?? 0
    );
  }

  MemberPetLikeModel copyWith({
    int? id,
    bool? iKeep,
    bool? iLike,
    int? memberId,
    int? memberPetId,
    int? likeAt,
    int? keepAt,
    int? petMemberId
  }){
    return MemberPetLikeModel(
        id: id ?? this.id,
        iKeep: iKeep ?? this.iKeep,
        iLike: iLike ?? this.iLike,
        memberId: memberId ?? this.memberId,
        memberPetId: memberPetId ?? this.memberPetId,
        likeAt: likeAt ?? this.likeAt,
        keepAt: keepAt ?? this.keepAt,
        petMemberId: petMemberId ?? this.petMemberId
    );
  }

  Map<String, dynamic> toMap(){
    return {
      'id': id,
      'ikeep': iKeep,
      'ilike': iLike,
      'memberId': memberId,
      'memberPetId': memberPetId,
      'likeAt': likeAt,
      'keepAt': keepAt,
      'petMemberId': petMemberId
    };
  }

  Map<String, dynamic> toPut(){
    return {
      'id': id,
      'ikeep': iKeep,
      'ilike': iLike,
      'memberId': memberId,
      'memberPetId': memberPetId,
    };
  }
}