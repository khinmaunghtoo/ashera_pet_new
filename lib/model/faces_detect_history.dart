import 'dart:convert';

import 'package:ashera_pet_new/model/member.dart';

class FacesDetectHistoryModel {
  final int id;
  final int fromMemberId;
  final String fromMemberName;
  final String fromMemberNickname;
  final int fromMemberGender;
  final MemberModel fromMember;
  final int targetMemberId;
  final String targetMemberName;
  final String targetMemberNickname;
  final int targetMemberGender;
  final MemberModel targetMember;
  final double latitude;
  final double longitude;
  final String address;
  final int detectType;
  final int status;
  final double createdAt;
  final double updatedAt;

  const FacesDetectHistoryModel(
      {required this.id,
      required this.fromMemberId,
      required this.fromMemberName,
      required this.fromMemberNickname,
      required this.fromMemberGender,
      required this.fromMember,
      required this.targetMemberId,
      required this.targetMemberName,
      required this.targetMemberNickname,
      required this.targetMemberGender,
      required this.targetMember,
      required this.latitude,
      required this.longitude,
      required this.address,
      required this.detectType,
      required this.status,
      required this.createdAt,
      required this.updatedAt});

  factory FacesDetectHistoryModel.fromMap(Map<String, dynamic> map) {
    return FacesDetectHistoryModel(
        id: map['id'] as int? ?? 0,
        fromMemberId: map['fromMemberId'] as int? ?? 0,
        fromMemberName: map['fromMemberName'] as String? ?? '',
        fromMemberNickname: map['fromMemberNickname'] as String? ?? '',
        fromMemberGender: map['fromMemberGender'] as int? ?? 0,
        fromMember: MemberModel.fromMap(map['fromMember']),
        targetMemberId: map['targetMemberId'] as int? ?? 0,
        targetMemberName: map['targetMemberName'] as String? ?? '',
        targetMemberNickname: map['targetMemberNickname'] as String? ?? '',
        targetMemberGender: map['targetMemberGender'] as int? ?? 0,
        targetMember: MemberModel.fromMap(map['targetMember']),
        latitude: map['latitude'] as double? ?? 0.0,
        longitude: map['longitude'] as double? ?? 0.0,
        address: map['address'] as String? ?? '',
        detectType: map['detectType'] as int? ?? 0,
        status: map['status'] as int? ?? 0,
        createdAt: map['createdAt'] as double? ?? 0.0,
        updatedAt: map['updatedAt'] as double? ?? 0.0);
  }

  factory FacesDetectHistoryModel.fromJson(String source) =>
      FacesDetectHistoryModel.fromMap(
          json.decode(source) as Map<String, dynamic>);

  FacesDetectHistoryModel copyWith({
    int? id,
    int? fromMemberId,
    String? fromMemberName,
    String? fromMemberNickname,
    int? fromMemberGender,
    MemberModel? fromMember,
    int? targetMemberId,
    String? targetMemberName,
    String? targetMemberNickname,
    int? targetMemberGender,
    MemberModel? targetMember,
    double? latitude,
    double? longitude,
    String? address,
    int? detectType,
    int? status,
    double? createdAt,
    double? updatedAt,
  }) {
    return FacesDetectHistoryModel(
        id: id ?? this.id,
        fromMemberId: fromMemberId ?? this.fromMemberId,
        fromMemberName: fromMemberName ?? this.fromMemberName,
        fromMemberNickname: fromMemberNickname ?? this.fromMemberNickname,
        fromMemberGender: fromMemberGender ?? this.fromMemberGender,
        fromMember: fromMember ?? this.fromMember,
        targetMemberId: targetMemberId ?? this.targetMemberId,
        targetMemberName: targetMemberName ?? this.targetMemberName,
        targetMemberNickname: targetMemberNickname ?? this.targetMemberNickname,
        targetMemberGender: targetMemberGender ?? this.targetMemberGender,
        targetMember: targetMember ?? this.targetMember,
        latitude: latitude ?? this.latitude,
        longitude: longitude ?? this.longitude,
        address: address ?? this.address,
        detectType: detectType ?? this.detectType,
        status: status ?? this.status,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt);
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'fromMemberId': fromMemberId,
      'fromMemberName': fromMemberName,
      'fromMemberNickname': fromMemberNickname,
      'fromMemberGender': fromMemberGender,
      'fromMember': fromMember,
      'targetMemberId': targetMemberId,
      'targetMemberName': targetMemberName,
      'targetMemberNickname': targetMemberNickname,
      'targetMemberGender': targetMemberGender,
      'targetMember': targetMember,
      'latitude': latitude,
      'longitude': longitude,
      'address': address,
      'detectType': detectType,
      'status': status,
      'createdAt': createdAt,
      'updatedAt': updatedAt
    };
  }

  String toJson() => json.encode(toMap());

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is FacesDetectHistoryModel &&
        other.id == id &&
        other.fromMemberId == fromMemberId &&
        other.fromMemberName == fromMemberName &&
        other.fromMemberNickname == fromMemberNickname &&
        other.fromMemberGender == fromMemberGender &&
        other.fromMember == fromMember &&
        other.targetMemberId == targetMemberId &&
        other.targetMemberName == targetMemberName &&
        other.targetMemberNickname == targetMemberNickname &&
        other.targetMemberGender == targetMemberGender &&
        other.targetMember == targetMember &&
        other.latitude == latitude &&
        other.longitude == longitude &&
        other.address == address &&
        other.detectType == detectType &&
        other.status == status &&
        other.createdAt == createdAt &&
        other.updatedAt == updatedAt;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        fromMemberId.hashCode ^
        fromMemberName.hashCode ^
        fromMemberNickname.hashCode ^
        fromMemberGender.hashCode ^
        fromMember.hashCode ^
        targetMemberId.hashCode ^
        targetMemberName.hashCode ^
        targetMemberNickname.hashCode ^
        targetMemberGender.hashCode ^
        targetMember.hashCode ^
        latitude.hashCode ^
        longitude.hashCode ^
        address.hashCode ^
        detectType.hashCode ^
        status.hashCode ^
        createdAt.hashCode ^
        updatedAt.hashCode;
  }
}
