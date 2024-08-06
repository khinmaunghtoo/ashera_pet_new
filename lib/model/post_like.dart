import 'dart:convert';

import 'member.dart';

class PostLikeModel{
  final int id;
  final int likeType;
  final int memberId;
  final int postMemberId;
  final int postId;
  final int status;
  final MemberModel member;

  const PostLikeModel({
    this.id = 0,
    required this.likeType,
    required this.memberId,
    required this.postMemberId,
    required this.postId,
    this.status = 1,
    required this.member,
  });

  factory PostLikeModel.fromMap(Map<String, dynamic> map){
    return PostLikeModel(
        id: map['id'] as int? ?? 0,
        likeType: map['likeType'] as int? ?? 0,
        memberId: map['memberId'] as int? ?? 0,
        postMemberId: map['postMemberId'] as int? ?? 0,
        postId: map['postId'] as int? ?? 0,
        status: map['status'] as int? ?? 0,
        member: MemberModel.fromMap(map['member']),
    );
  }

  factory PostLikeModel.fromJson(String source) => PostLikeModel.fromMap(json.decode(source) as Map<String, dynamic>);

  PostLikeModel copyWith({
    int? id,
    int? likeType,
    int? memberId,
    int? postMemberId,
    int? postId,
    int? status,
    MemberModel? member,
  }){
    return PostLikeModel(
        id: id ?? this.id,
        likeType: likeType ?? this.likeType,
        memberId: memberId ?? this.memberId,
        postMemberId: postMemberId ?? this.postMemberId,
        postId: postId ?? this.postId,
        status: status ?? this.status,
        member: member ?? this.member,
    );
  }

  Map<String, dynamic> toMap(){
    return {
      'id': id,
      'likeType': likeType,
      'memberId': memberId,
      'postMemberId': postMemberId,
      'postId': postId,
      'status': status,
      'member': member.toMap(),
    };
  }

  Map<String, dynamic> addLike(){
    return {
      'likeType': likeType,
      'memberId': memberId,
      'postMemberId': postMemberId,
      'postId': postId,
      'status': status
    };
  }

  String toJson() => json.encode(toMap());

  @override
  bool operator ==(Object other) {
    if(identical(this, other)) return true;

    return other is PostLikeModel &&
      other.id == id &&
      other.likeType == likeType &&
      other.memberId == memberId &&
      other.postMemberId == postMemberId &&
      other.postId == postId &&
      other.status == status &&
      other.member == member;
  }

  @override
  int get hashCode {
    return id.hashCode ^
    likeType.hashCode ^
    memberId.hashCode ^
    postMemberId.hashCode ^
    postId.hashCode ^
    status.hashCode ^
    member.hashCode;
  }
}