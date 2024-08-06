import 'dart:convert';

import 'package:ashera_pet_new/enum/tab_bar.dart';

class AddFollowerRequestDTO {
  final int followerId;
  final int memberId;

  const AddFollowerRequestDTO(
      {required this.followerId, required this.memberId});

  factory AddFollowerRequestDTO.fromMap(Map<String, dynamic> map) {
    return AddFollowerRequestDTO(
        followerId: map['followerId'] as int? ?? 0,
        memberId: map['memberId'] as int? ?? 0);
  }

  factory AddFollowerRequestDTO.fromJson(String source) =>
      AddFollowerRequestDTO.fromMap(
          json.decode(source) as Map<String, dynamic>);

  Map<String, dynamic> toMap() {
    return {'followerId': followerId, 'memberId': memberId};
  }

  String toJson() => json.encode(toMap());
}

class AcceptFollowerRequestDTO {
  final int followerId;
  final int memberId;
  final bool approve;

  const AcceptFollowerRequestDTO(
      {required this.followerId,
      required this.memberId,
      required this.approve});

  factory AcceptFollowerRequestDTO.fromMap(Map<String, dynamic> map) {
    return AcceptFollowerRequestDTO(
        followerId: map['followerId'] as int? ?? 0,
        memberId: map['memberId'] as int? ?? 0,
        approve: map['approve'] as bool? ?? false);
  }

  factory AcceptFollowerRequestDTO.fromJson(String source) =>
      AcceptFollowerRequestDTO.fromMap(
          json.decode(source) as Map<String, dynamic>);

  Map<String, dynamic> toMap() {
    return {'followerId': followerId, 'memberId': memberId, 'approve': approve};
  }

  String toJson() => json.encode(toMap());
}

class FollowerRequestModel {
  final int id;
  final int memberId;
  final int followerId;
  final int createTime;
  final int acceptTime;
  final bool read;

  const FollowerRequestModel(
      {required this.id,
      required this.memberId,
      required this.followerId,
      required this.createTime,
      required this.acceptTime,
      required this.read});

  factory FollowerRequestModel.fromMap(Map<String, dynamic> map) {
    return FollowerRequestModel(
        id: map['id'] as int? ?? 0,
        memberId: map['memberId'] as int? ?? 0,
        followerId: map['followerId'] as int? ?? 0,
        createTime: map['createTime'] as int? ?? 0,
        acceptTime: map['acceptTime'] as int? ?? 0,
        read: map['read'] as bool? ?? true);
  }

  factory FollowerRequestModel.fromJson(String source) =>
      FollowerRequestModel.fromMap(json.decode(source) as Map<String, dynamic>);

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'memberId': memberId,
      'followerId': followerId,
      'createTime': createTime,
      'acceptTime': acceptTime,
      'read': read
    };
  }

  String toJson() => json.encode(toMap());

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is FollowerRequestModel &&
        other.id == id &&
        other.memberId == memberId &&
        other.followerId == followerId &&
        other.createTime == createTime &&
        other.acceptTime == acceptTime &&
        other.read == read;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        memberId.hashCode ^
        followerId.hashCode ^
        createTime.hashCode ^
        acceptTime.hashCode ^
        read.hashCode;
  }
}

class DeleteFollowerRequestDTO {
  final int memberId;
  final int followerRequestId;

  const DeleteFollowerRequestDTO(
      {required this.memberId, required this.followerRequestId});

  Map<String, dynamic> toMap() {
    return {'memberId': memberId, 'followerRequestId': followerRequestId};
  }

  String toJson() => json.encode(toMap());
}

class OtherPetFollowerModel {
  final FollowerTabBarEnum type;
  final List<FollowerRequestModel> followerMeList;
  final List<FollowerRequestModel> myFollowerList;

  const OtherPetFollowerModel(
      {required this.type,
      required this.followerMeList,
      required this.myFollowerList});

  Map<String, dynamic> toMap() {
    return {
      'type': type,
      'followerMeList': followerMeList,
      'myFollowerList': myFollowerList
    };
  }
}

class FriendDataCntDTO {
  final int memberId;
  final int postCnt;
  final int myFollowCnt;
  final int followMeCnt;

  const FriendDataCntDTO(
      {required this.memberId,
      required this.postCnt,
      required this.myFollowCnt,
      required this.followMeCnt});

  factory FriendDataCntDTO.fromMap(Map<String, dynamic> map) {
    return FriendDataCntDTO(
        memberId: map['memberId'] as int? ?? 0,
        postCnt: map['postCnt'] as int? ?? 0,
        myFollowCnt: map['myFollowCnt'] as int? ?? 0,
        followMeCnt: map['followMeCnt'] as int? ?? 0);
  }

  factory FriendDataCntDTO.fromJson(String source) =>
      FriendDataCntDTO.fromMap(json.decode(source) as Map<String, dynamic>);

  FriendDataCntDTO copyWith(
      {int? memberId, int? postCnt, int? myFollowCnt, int? followMeCnt}) {
    return FriendDataCntDTO(
        memberId: memberId ?? this.memberId,
        postCnt: postCnt ?? this.postCnt,
        myFollowCnt: myFollowCnt ?? this.myFollowCnt,
        followMeCnt: followMeCnt ?? this.followMeCnt);
  }

  Map<String, dynamic> toMap() {
    return {
      'memberId': memberId,
      'postCnt': postCnt,
      'myFollowCnt': myFollowCnt,
      'followMeCnt': followMeCnt
    };
  }

  String toJson() => json.encode(toMap());

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is FriendDataCntDTO &&
        other.memberId == memberId &&
        other.postCnt == postCnt &&
        other.myFollowCnt == myFollowCnt &&
        other.followMeCnt == followMeCnt;
  }

  @override
  int get hashCode {
    return memberId.hashCode ^
        postCnt.hashCode ^
        myFollowCnt.hashCode ^
        followMeCnt.hashCode;
  }
}
