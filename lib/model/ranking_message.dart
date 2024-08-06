import 'dart:convert';

import 'package:ashera_pet_new/model/member.dart';
import 'package:ashera_pet_new/model/post.dart';

import 'member_pet.dart';

class RankingMessageModel {
  final int id;
  final int memberId;
  final int memberPetId;
  final int postId;
  final int sortIndex;
  final MemberModel? member;
  final String firstMessage;
  final int sharePostCnt;
  final int followerCnt;
  final int likeCnt;
  final int messageCnt;
  final String pics;
  final String uuid;
  final int status;
  final String createdAt;
  final String updatedAt;
  final int count;
  final PostModel? post;

  const RankingMessageModel(
      {required this.id,
      required this.memberId,
      required this.memberPetId,
      required this.postId,
      required this.sortIndex,
      required this.member,
      required this.firstMessage,
      required this.sharePostCnt,
      required this.followerCnt,
      required this.likeCnt,
      required this.messageCnt,
      required this.pics,
      required this.uuid,
      required this.status,
      required this.createdAt,
      required this.updatedAt,
      required this.post,
      this.count = 0});

  factory RankingMessageModel.fromMap(Map<String, dynamic> map) {
    return RankingMessageModel(
        id: map['id'] as int? ?? 0,
        memberId: map['memberId'] as int? ?? 0,
        memberPetId: map['memberPetId'] as int? ?? 0,
        postId: map['postId'] as int? ?? 0,
        sortIndex: map['sortIndex'] as int? ?? 0,
        member:
            map['member'] != null ? MemberModel.fromMap(map['member']) : null,
        firstMessage: map['firstMessage'] as String? ?? '',
        sharePostCnt: map['sharePostCnt'] as int? ?? 0,
        followerCnt: map['followerCnt'] as int? ?? 0,
        likeCnt: map['likeCnt'] as int? ?? 0,
        messageCnt: map['messageCnt'] as int? ?? 0,
        pics: map['pics'] as String? ?? '',
        uuid: map['uuid'] as String? ?? '',
        status: map['status'] as int? ?? 0,
        createdAt: map['createdAt'] as String? ?? '',
        updatedAt: map['updatedAt'] as String? ?? '',
        post: map['post'] != null ? PostModel.fromMap(map['post']) : null,
        count: map['count'] as int? ?? 0);
  }

  factory RankingMessageModel.fromJson(String source) =>
      RankingMessageModel.fromMap(json.decode(source) as Map<String, dynamic>);

  RankingMessageModel copyWith({
    int? id,
    int? memberId,
    int? memberPetId,
    int? postId,
    int? sortIndex,
    MemberPetModel? fromMemberPet,
    MemberModel? member,
    String? firstMessage,
    int? sharePostCnt,
    int? followerCnt,
    int? likeCnt,
    int? messageCnt,
    String? pics,
    String? uuid,
    int? status,
    String? createdAt,
    String? updatedAt,
    PostModel? post,
    int? count,
  }) {
    return RankingMessageModel(
        id: id ?? this.id,
        memberId: memberId ?? this.memberId,
        memberPetId: memberPetId ?? this.memberPetId,
        postId: postId ?? this.postId,
        sortIndex: sortIndex ?? this.sortIndex,
        member: member ?? this.member,
        firstMessage: firstMessage ?? this.firstMessage,
        sharePostCnt: sharePostCnt ?? this.sharePostCnt,
        followerCnt: followerCnt ?? this.followerCnt,
        likeCnt: likeCnt ?? this.likeCnt,
        messageCnt: messageCnt ?? this.messageCnt,
        pics: pics ?? this.pics,
        uuid: uuid ?? this.uuid,
        status: status ?? this.status,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        post: post ?? this.post,
        count: count ?? this.count);
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'memberId': memberId,
      'memberPetId': memberPetId,
      'postId': postId,
      'sortIndex': sortIndex,
      'member': member?.toMap(),
      'firstMessage': firstMessage,
      'sharePostCnt': sharePostCnt,
      'followerCnt': followerCnt,
      'likeCnt': likeCnt,
      'messageCnt': messageCnt,
      'pics': pics,
      'uuid': uuid,
      'status': status,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'post': post?.toJson(),
      'count': count
    };
  }

  String toJson() => json.encode(toMap());

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is RankingMessageModel &&
        other.id == id &&
        other.memberId == memberId &&
        other.memberPetId == memberPetId &&
        other.postId == postId &&
        other.sortIndex == sortIndex &&
        other.member == member &&
        other.firstMessage == firstMessage &&
        other.sharePostCnt == sharePostCnt &&
        other.followerCnt == followerCnt &&
        other.likeCnt == likeCnt &&
        other.messageCnt == messageCnt &&
        other.pics == pics &&
        other.uuid == uuid &&
        other.status == status &&
        other.createdAt == createdAt &&
        other.updatedAt == updatedAt &&
        other.post == post;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        memberId.hashCode ^
        memberPetId.hashCode ^
        postId.hashCode ^
        sortIndex.hashCode ^
        member.hashCode ^
        firstMessage.hashCode ^
        sharePostCnt.hashCode ^
        followerCnt.hashCode ^
        likeCnt.hashCode ^
        messageCnt.hashCode ^
        pics.hashCode ^
        uuid.hashCode ^
        status.hashCode ^
        createdAt.hashCode ^
        updatedAt.hashCode ^
        post.hashCode;
  }
}
