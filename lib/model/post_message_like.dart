import 'dart:convert';

import 'package:ashera_pet_new/enum/like_type.dart';

class PostMessageLikeModel {
  final int id;
  final int memberId;
  final LikeType likeType;
  final int postId;
  final int postMessageId;
  final int postMemberId;
  final int status;
  final String createdAt;
  final String updatedAt;

  const PostMessageLikeModel(
      {this.id = 0,
      required this.memberId,
      required this.likeType,
      required this.postId,
      this.postMessageId = 0,
      required this.postMemberId,
      this.status = 1,
      this.createdAt = '',
      this.updatedAt = ''});

  factory PostMessageLikeModel.fromMap(Map<String, dynamic> map) {
    return PostMessageLikeModel(
        id: map['id'] as int? ?? 0,
        memberId: map['memberId'] as int? ?? 0,
        likeType: LikeType.values[map['likeType'] as int? ?? 0],
        postId: map['postId'] as int? ?? 0,
        postMessageId: map['postMessageId'] as int? ?? 0,
        postMemberId: map['postMemberId'] as int? ?? 0,
        status: map['status'] as int? ?? 0,
        createdAt: map['createdAt'] as String? ?? '',
        updatedAt: map['updatedAt'] as String? ?? '');
  }

  factory PostMessageLikeModel.fromJson(String source) =>
      PostMessageLikeModel.fromMap(json.decode(source) as Map<String, dynamic>);

  PostMessageLikeModel copyWith(
      {int? id,
      int? memberId,
      LikeType? likeType,
      int? postId,
      int? postMessageId,
      int? postMemberId,
      int? status,
      String? createdAt,
      String? updatedAt}) {
    return PostMessageLikeModel(
        id: id ?? this.id,
        memberId: memberId ?? this.memberId,
        likeType: likeType ?? this.likeType,
        postId: postId ?? this.postId,
        postMessageId: postMessageId ?? this.postMessageId,
        postMemberId: postMemberId ?? this.postMemberId,
        status: status ?? this.status,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt);
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'memberId': memberId,
      'likeType': likeType.name,
      'postId': postId,
      'postMessageId': postMessageId,
      'status': status,
      'createdAt': createdAt,
      'updatedAt': updatedAt
    };
  }

  Map<String, dynamic> addMessageLike() {
    return {
      'memberId': memberId,
      'likeType': likeType.index,
      'postId': postId,
      'postMessageId': postMessageId,
      'postMemberId': postMemberId,
      'status': status
    };
  }

  String toJson() => json.encode(toMap());

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is PostMessageLikeModel &&
        other.id == id &&
        other.memberId == memberId &&
        other.likeType == likeType &&
        other.postId == postId &&
        other.postMessageId == postMessageId &&
        other.postMemberId == postMemberId &&
        other.status == status &&
        other.createdAt == createdAt &&
        other.updatedAt == updatedAt;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        memberId.hashCode ^
        likeType.hashCode ^
        postId.hashCode ^
        postMessageId.hashCode ^
        postMemberId.hashCode ^
        status.hashCode ^
        createdAt.hashCode ^
        updatedAt.hashCode;
  }
}
