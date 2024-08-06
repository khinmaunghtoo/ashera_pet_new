import 'dart:convert';

import 'package:ashera_pet_new/model/post.dart';

import '../enum/messag_notify_type.dart';
import 'member.dart';

class NotifyModel {
  final int id;
  final int fromMemberId;
  final MemberModel fromMember;
  final int targetMemberId;
  final String data;
  final String message;
  final MessageNotifyType messageNotifyType;
  final bool systemMessage;
  final String updatedAt;
  final String createdAt;
  final int status;

  const NotifyModel(
      {required this.id,
      required this.fromMemberId,
      required this.fromMember,
      required this.targetMemberId,
      required this.data,
      required this.message,
      required this.messageNotifyType,
      required this.systemMessage,
      required this.updatedAt,
      required this.createdAt,
      required this.status});

  factory NotifyModel.fromMap(Map<String, dynamic> map) {
    return NotifyModel(
        id: map['id'] as int? ?? 0,
        fromMemberId: map['fromMemberId'] as int? ?? 0,
        fromMember: MemberModel.fromMap(map['fromMember'] ?? {}),
        targetMemberId: map['targetMemberId'] as int? ?? 0,
        data: map['data'] as String? ?? '',
        message: map['message'] as String? ?? '',
        messageNotifyType:
            MessageNotifyType.values[map['messageNotifyType'] as int? ?? 0],
        systemMessage: map['systemMessage'] as bool? ?? false,
        updatedAt: map['updatedAt'] as String? ?? '',
        createdAt: map['createdAt'] as String? ?? '',
        status: map['status'] as int? ?? 0);
  }

  factory NotifyModel.fromJson(String source) =>
      NotifyModel.fromMap(json.decode(source) as Map<String, dynamic>);

  NotifyModel copyWith({
    int? id,
    int? fromMemberId,
    MemberModel? fromMember,
    int? targetMemberId,
    String? data,
    String? message,
    MessageNotifyType? messageNotifyType,
    bool? systemMessage,
    String? updatedAt,
    String? createdAt,
    int? status,
  }) {
    return NotifyModel(
        id: id ?? this.id,
        fromMemberId: fromMemberId ?? this.fromMemberId,
        fromMember: fromMember ?? this.fromMember,
        targetMemberId: targetMemberId ?? this.targetMemberId,
        data: data ?? this.data,
        message: message ?? this.message,
        messageNotifyType: messageNotifyType ?? this.messageNotifyType,
        systemMessage: systemMessage ?? this.systemMessage,
        updatedAt: updatedAt ?? this.updatedAt,
        createdAt: createdAt ?? this.createdAt,
        status: status ?? this.status);
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'fromMemberId': fromMemberId,
      'fromMember': fromMember,
      'targetMemberId': targetMemberId,
      'data': data,
      'message': message,
      'messageNotifyType': messageNotifyType.name,
      'systemMessage': systemMessage,
      'updatedAt': updatedAt,
      'createdAt': createdAt,
      'status': status
    };
  }

  String toJson() => json.encode(toMap());

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is NotifyModel &&
        other.id == id &&
        other.fromMemberId == fromMemberId &&
        other.fromMember == fromMember &&
        other.targetMemberId == targetMemberId &&
        other.data == data &&
        other.message == message &&
        other.messageNotifyType == messageNotifyType &&
        other.systemMessage == systemMessage &&
        other.updatedAt == updatedAt &&
        other.createdAt == createdAt &&
        other.status == status;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        fromMemberId.hashCode ^
        fromMember.hashCode ^
        targetMemberId.hashCode ^
        data.hashCode ^
        message.hashCode ^
        messageNotifyType.hashCode ^
        systemMessage.hashCode ^
        updatedAt.hashCode ^
        createdAt.hashCode ^
        status.hashCode;
  }
}

class GetMessageNotifyByTargetMemberDTO {
  final int memberId;
  final int page;
  final int size;
  final String sortBy;

  const GetMessageNotifyByTargetMemberDTO(
      {required this.memberId,
      this.page = 0,
      this.size = 15,
      this.sortBy = 'created_at'});

  GetMessageNotifyByTargetMemberDTO copyWith(
      {int? memberId, int? page, int? size, String? sortBy}) {
    return GetMessageNotifyByTargetMemberDTO(
        memberId: memberId ?? this.memberId,
        page: page ?? this.page,
        size: size ?? this.size,
        sortBy: sortBy ?? this.sortBy);
  }

  Map<String, dynamic> toMap() {
    return {'memberId': memberId, 'page': page, 'size': size, 'sortBy': sortBy};
  }
}

class PageMessageNotifyModel {
  final List<NotifyModel> content;
  final Pageable pageable;
  final Sort sort;
  final int totalElements;
  final int totalPages;
  final int number;
  final int numberOfElements;
  final int size;
  final bool empty;
  final bool first;
  final bool last;

  const PageMessageNotifyModel(
      {required this.content,
      required this.pageable,
      required this.sort,
      required this.totalElements,
      required this.totalPages,
      required this.number,
      required this.numberOfElements,
      required this.size,
      required this.first,
      required this.last,
      required this.empty});

  factory PageMessageNotifyModel.fromMap(Map<String, dynamic> map) {
    List list = map['content'];
    return PageMessageNotifyModel(
        content: list.map((e) => NotifyModel.fromMap(e)).toList(),
        pageable: Pageable.fromMap(map['pageable']),
        sort: Sort.fromMap(map['sort']),
        totalElements: map['totalElements'] as int? ?? 0,
        totalPages: map['totalPages'] as int? ?? 0,
        number: map['number'] as int? ?? 0,
        numberOfElements: map['numberOfElements'] as int? ?? 0,
        size: map['size'] as int? ?? 0,
        first: map['first'] as bool? ?? false,
        last: map['last'] as bool? ?? false,
        empty: map['empty'] as bool? ?? false);
  }

  factory PageMessageNotifyModel.fromJson(String source) =>
      PageMessageNotifyModel.fromMap(
          json.decode(source) as Map<String, dynamic>);

  PageMessageNotifyModel copyWith(
      {List<NotifyModel>? content,
      Pageable? pageable,
      Sort? sort,
      int? totalElements,
      int? totalPages,
      int? number,
      int? numberOfElements,
      int? size,
      bool? first,
      bool? last,
      bool? empty}) {
    return PageMessageNotifyModel(
        content: content ?? this.content,
        pageable: pageable ?? this.pageable,
        sort: sort ?? this.sort,
        totalElements: totalElements ?? this.totalElements,
        totalPages: totalPages ?? this.totalPages,
        number: number ?? this.number,
        numberOfElements: numberOfElements ?? this.numberOfElements,
        size: size ?? this.size,
        first: first ?? this.first,
        last: last ?? this.last,
        empty: empty ?? this.empty);
  }

  Map<String, dynamic> toMap() {
    return {
      'content': content,
      'pageable': pageable.toMap(),
      'sort': sort.toMap(),
      'totalElements': totalElements,
      'totalPages': totalPages,
      'number': number,
      'numberOfElements': numberOfElements,
      'size': size,
      'first': first,
      'last': last,
      'empty': empty
    };
  }

  String toJson() => json.encode(toMap());

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is PageMessageNotifyModel &&
        other.content == content &&
        other.pageable == pageable &&
        other.sort == sort &&
        other.totalElements == totalElements &&
        other.totalPages == totalPages &&
        other.number == number &&
        other.numberOfElements == numberOfElements &&
        other.size == size &&
        other.first == first &&
        other.last == last &&
        other.empty == empty;
  }

  @override
  int get hashCode {
    return content.hashCode ^
        pageable.hashCode ^
        sort.hashCode ^
        totalElements.hashCode ^
        totalPages.hashCode ^
        number.hashCode ^
        numberOfElements.hashCode ^
        size.hashCode ^
        first.hashCode ^
        last.hashCode ^
        empty.hashCode;
  }
}
