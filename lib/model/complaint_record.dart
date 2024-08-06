import 'dart:convert';

import 'package:ashera_pet_new/enum/ranking_list_type.dart';

class ComplaintRecordModel {
  final int id;
  final int dataId;
  final int fromMemberId;
  final int targetMemberId;
  final String targetMember;
  final RankingListType type;
  final String pic;
  final String reason;
  final String reply;
  final double updatedAt;
  final double createdAt;
  final int status;

  const ComplaintRecordModel(
      {this.id = 0,
      this.dataId = 0,
      required this.fromMemberId,
      required this.targetMemberId,
      required this.targetMember,
      required this.type,
      required this.pic,
      required this.reason,
      this.reply = '',
      this.updatedAt = 0.0,
      this.createdAt = 0.0,
      this.status = 1});

  factory ComplaintRecordModel.fromMap(Map<String, dynamic> map) {
    return ComplaintRecordModel(
      id: map['id'] as int? ?? 0,
      dataId: map['dataId'] as int? ?? 0,
      fromMemberId: map['fromMemberId'] as int? ?? 0,
      targetMemberId: map['targetMemberId'] as int? ?? 0,
      targetMember: map['targetMember'] as String? ?? '',
      type: RankingListType.values[map['type'] as int? ?? 0],
      pic: map['pic'] as String? ?? '',
      reason: map['reason'] as String? ?? '',
      reply: map['reply'] as String? ?? '',
      updatedAt: map['updatedAt'] as double? ?? 0.0,
      createdAt: map['createdAt'] as double? ?? 0.0,
      status: map['status'] as int? ?? 0,
    );
  }

  factory ComplaintRecordModel.fromJson(String source) =>
      ComplaintRecordModel.fromMap(json.decode(source) as Map<String, dynamic>);

  ComplaintRecordModel copyWith(
      {int? id,
      int? dataId,
      int? fromMemberId,
      int? targetMemberId,
      String? targetMember,
      RankingListType? type,
      String? pic,
      String? reason,
      String? reply,
      double? updatedAt,
      double? createdAt,
      int? status}) {
    return ComplaintRecordModel(
        id: id ?? this.id,
        dataId: dataId ?? this.dataId,
        fromMemberId: fromMemberId ?? this.fromMemberId,
        targetMemberId: targetMemberId ?? this.targetMemberId,
        targetMember: targetMember ?? this.targetMember,
        type: type ?? this.type,
        pic: pic ?? this.pic,
        reason: reason ?? this.reason,
        reply: reply ?? this.reply,
        updatedAt: updatedAt ?? this.updatedAt,
        createdAt: createdAt ?? this.createdAt,
        status: status ?? this.status);
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'dataId': dataId,
      'fromMemberId': fromMemberId,
      'targetMemberId': targetMemberId,
      'targetMember': targetMember,
      'type': type.name,
      'pic': pic,
      'reason': reason,
      'reply': reply,
      'updatedAt': updatedAt,
      'createdAt': createdAt,
      'status': status
    };
  }

  Map<String, dynamic> addRecord() {
    return {
      'dataId': dataId,
      'fromMemberId': fromMemberId,
      'targetMemberId': targetMemberId,
      'targetMember': targetMember,
      'type': type.index,
      'pic': pic,
      'reason': reason,
      'status': status
    };
  }

  String toJson() => json.encode(toMap());

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ComplaintRecordModel &&
        other.id == id &&
        other.dataId == dataId &&
        other.fromMemberId == fromMemberId &&
        other.targetMemberId == targetMemberId &&
        other.targetMember == targetMember &&
        other.pic == pic &&
        other.reason == reason &&
        other.reply == reply &&
        other.updatedAt == updatedAt &&
        other.createdAt == createdAt &&
        other.status == status;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        dataId.hashCode ^
        fromMemberId.hashCode ^
        targetMemberId.hashCode ^
        targetMember.hashCode ^
        pic.hashCode ^
        reason.hashCode ^
        reply.hashCode ^
        updatedAt.hashCode ^
        createdAt.hashCode ^
        status.hashCode;
  }
}
