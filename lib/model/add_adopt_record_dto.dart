import 'dart:convert';

import 'package:ashera_pet_new/model/member_view.dart';

import '../enum/adopt_status.dart';
import '../enum/ranking_list_type.dart';

class AdoptRecordModel {
  final int id;
  final int fromMemberId;
  final MemberView fromMemberView;
  final String fromMember;
  final int targetMemberId;
  final String targetMember;
  final MemberView targetMemberView;
  final String pic;
  final String reason;
  final String reply;
  final String replyAt;
  final String replyPics;
  final ComplaintRecordStatus status;
  final RankingListType type;
  final bool pass;
  final String passAt;
  final String approveAt;
  final String createdAt;
  final String updatedAt;

  const AdoptRecordModel(
      {this.id = 0,
      required this.fromMemberId,
      this.fromMember = '',
      this.fromMemberView = const MemberView(),
      required this.targetMemberId,
      this.targetMember = '',
      this.targetMemberView = const MemberView(),
      required this.pic,
      required this.reason,
      this.reply = '',
      this.replyAt = '',
      this.replyPics = '',
      this.status = ComplaintRecordStatus.APPROVAL_WAIT,
      this.type = RankingListType.POST,
      this.pass = false,
      this.passAt = '',
      this.approveAt = '',
      this.createdAt = '',
      this.updatedAt = ''});

  factory AdoptRecordModel.fromMap(Map<String, dynamic> map) {
    return AdoptRecordModel(
        id: map['id'] as int? ?? 0,
        fromMemberId: map['fromMemberId'] as int? ?? 0,
        fromMemberView: MemberView.fromMap(map['fromMemberView'] ?? {}),
        targetMemberId: map['targetMemberId'] as int? ?? 0,
        targetMember: map['targetMember'] as String? ?? '',
        targetMemberView: MemberView.fromMap(map['targetMemberView'] ?? {}),
        pic: map['pic'] as String? ?? '',
        reason: map['reason'] as String? ?? '',
        reply: map['reply'] as String? ?? '',
        replyAt: map['replyAt'] as String? ?? '',
        replyPics: map['replyPics'] as String? ?? '',
        status: ComplaintRecordStatus.values[map['status'] as int? ?? 0],
        type: RankingListType.values[map['type'] as int? ?? 0],
        pass: map['pass'] as bool? ?? false,
        passAt: map['passAt'] as String? ?? '',
        approveAt: map['approveAt'] as String? ?? '',
        createdAt: map['createdAt'] as String? ?? '',
        updatedAt: map['updatedAt'] as String? ?? '');
  }

  factory AdoptRecordModel.fromJson(String source) =>
      AdoptRecordModel.fromMap(json.decode(source) as Map<String, dynamic>);

  AdoptRecordModel copyWith(
      {int? id,
      int? fromMemberId,
      MemberView? fromMemberView,
      int? targetMemberId,
      String? targetMember,
      MemberView? targetMemberView,
      String? pic,
      String? reason,
      String? reply,
      String? replyAt,
      String? replyPics,
      ComplaintRecordStatus? status,
      RankingListType? type,
      bool? pass,
      String? passAt,
      String? approveAt,
      String? createdAt,
      String? updatedAt}) {
    return AdoptRecordModel(
        id: id ?? this.id,
        fromMemberId: fromMemberId ?? this.fromMemberId,
        fromMemberView: fromMemberView ?? this.fromMemberView,
        targetMemberId: targetMemberId ?? this.targetMemberId,
        targetMember: targetMember ?? this.targetMember,
        targetMemberView: targetMemberView ?? this.targetMemberView,
        pic: pic ?? this.pic,
        reason: reason ?? this.reason,
        reply: reply ?? this.reply,
        replyAt: replyAt ?? this.replyAt,
        replyPics: replyPics ?? this.replyPics,
        status: status ?? this.status,
        type: type ?? this.type,
        pass: pass ?? this.pass,
        passAt: passAt ?? this.passAt,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt);
  }

  Map<String, dynamic> addMap() {
    return {
      'fromMemberId': fromMemberId,
      'targetMemberId': targetMemberId,
      'targetMember': targetMember,
      'pic': pic,
      'reason': reason,
      'type': type
    };
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'fromMemberId': fromMemberId,
      'fromMemberView': fromMemberView.toMap(),
      'targetMemberId': targetMemberId,
      'targetMember': targetMember,
      'targetMemberView': targetMemberView.toMap(),
      'pic': pic,
      'reason': reason,
      'reply': reply,
      'replyAt': replyAt,
      'replyPics': replyPics,
      'status': status,
      'type': type,
      'pass': pass,
      'passAt': passAt,
      'approveAt': approveAt,
      'createdAt': createdAt,
      'updatedAt': updatedAt
    };
  }
}
