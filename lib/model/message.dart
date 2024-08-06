import 'dart:convert';
import 'package:ashera_pet_new/enum/chat_type.dart';
import 'package:ashera_pet_new/model/member_view.dart';
import 'package:ashera_pet_new/model/post.dart';

import '../data/member.dart';
import '../enum/message_type.dart';

class MessageModel {
  const MessageModel(
      {this.id = 0,
      required this.fromMember,
      required this.fromMemberId,
      this.fromMemberView,
      required this.targetMember,
      required this.targetMemberId,
      this.targetMemberView,
      required this.content,
      required this.type,
      this.unreadCnt = 0,
      this.block = false,
      required this.chatRoomId,
      this.chatType = ChatType.GENERAL,
      this.isRead = 0,
      this.updatedAt = '',
      this.createdAt = '',
      this.status = 0,
      this.memberPetId = 0});
  final int id;
  final String fromMember;
  final int fromMemberId;
  final MemberView? fromMemberView;
  final String targetMember;
  final int targetMemberId;
  final MemberView? targetMemberView;
  final String content;
  final MessageType type;
  final int unreadCnt;
  final bool block;
  final int chatRoomId;
  final ChatType chatType;
  final int isRead;
  final String updatedAt;
  final String createdAt;
  final int status;
  final int memberPetId;

  bool get isMine => fromMemberId == Member.memberModel.id;
  String get fromMemberNickname => Member.memberModel.nickname;

  factory MessageModel.fromMap(Map<String, dynamic> map) {
    return MessageModel(
        id: map['id'] as int? ?? 0,
        fromMember: map['fromMember'] as String? ?? '',
        fromMemberId: map['fromMemberId'] as int? ?? 0,
        fromMemberView: MemberView.fromMap(map['fromMemberView'] ?? {}),
        targetMember: map['targetMember'] as String? ?? '',
        targetMemberId: map['targetMemberId'] as int? ?? 0,
        targetMemberView: MemberView.fromMap(map['targetMemberView'] ?? {}),
        content: map['content'] as String? ?? '',
        type: MessageType.values[map['type']],
        unreadCnt: map['unreadCnt'] as int? ?? 0,
        block: map['block'] as bool? ?? false,
        chatRoomId: map['chatRoomId'] as int? ?? 0,
        chatType:
            ChatType.values.byName(map['chatType'] as String? ?? 'GENERAL'),
        isRead: map['isRead'] as int? ?? 0,
        updatedAt: map['updatedAt'] as String? ?? '',
        createdAt: map['createdAt'] as String? ?? '',
        status: map['status'] as int? ?? 0,
        memberPetId: map['memberPetId'] as int? ?? 0);
  }

  factory MessageModel.fromJson(String source) =>
      MessageModel.fromMap(json.decode(source) as Map<String, dynamic>);

  factory MessageModel.fromDBMap(Map<String, dynamic> map) {
    //log('runtimeType: ${map['fromMemberView']}');
    return MessageModel(
        id: map['id'] as int? ?? 0,
        fromMember: map['fromMember'] as String? ?? '',
        fromMemberId: map['fromMemberId'] as int? ?? 0,
        fromMemberView: MemberView.fromJson(map['fromMemberView']),
        targetMember: map['targetMember'] as String? ?? '',
        targetMemberId: map['targetMemberId'] as int? ?? 0,
        targetMemberView: MemberView.fromJson(map['targetMemberView']),
        content: map['content'] as String? ?? '',
        type: MessageType.values.byName(map['type']),
        unreadCnt: map['unreadCnt'] as int? ?? 0,
        block: map['block'] == 0 ? false : true,
        chatRoomId: map['chatRoomId'] as int? ?? 0,
        chatType: map['chatType'] == null
            ? ChatType.GENERAL
            : ChatType.values.byName(map['chatType'] as String? ?? 'GENERAL'),
        isRead: map['isRead'] as int? ?? 0,
        updatedAt: map['updatedAt'] as String? ?? '',
        createdAt: map['createdAt'] as String? ?? '',
        status: map['status'] as int? ?? 0);
  }

  MessageModel copyWith(
      {int? id,
      String? fromMember,
      int? fromMemberId,
      MemberView? fromMemberView,
      String? targetMember,
      int? targetMemberId,
      MemberView? targetMemberView,
      String? content,
      MessageType? type,
      int? unreadCnt,
      bool? block,
      int? chatRoomId,
      ChatType? chatType,
      int? isRead,
      String? updatedAt,
      String? createdAt,
      int? status}) {
    return MessageModel(
        id: id ?? this.id,
        fromMember: fromMember ?? this.fromMember,
        fromMemberId: fromMemberId ?? this.fromMemberId,
        fromMemberView: fromMemberView ?? this.fromMemberView,
        targetMember: targetMember ?? this.targetMember,
        targetMemberId: targetMemberId ?? this.targetMemberId,
        targetMemberView: targetMemberView ?? this.targetMemberView,
        content: content ?? this.content,
        type: type ?? this.type,
        unreadCnt: unreadCnt ?? this.unreadCnt,
        block: block ?? this.block,
        chatRoomId: chatRoomId ?? this.chatRoomId,
        chatType: chatType ?? this.chatType,
        isRead: isRead ?? this.isRead,
        updatedAt: updatedAt ?? this.updatedAt,
        createdAt: createdAt ?? this.createdAt,
        status: status ?? this.status);
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'fromMember': fromMember,
      'fromMemberId': fromMemberId,
      'fromMemberView': fromMemberView!.toMap(),
      'targetMember': targetMember,
      'targetMemberId': targetMemberId,
      'targetMemberView': targetMemberView!.toMap(),
      'content': content,
      'type': type.name,
      'unreadCnt': unreadCnt,
      'block': block,
      'chatRoomId': chatRoomId,
      'chatType': chatType.name,
      'isRead': isRead,
      'updatedAt': updatedAt,
      'createdAt': createdAt,
      'status': status,
      'memberPetId': memberPetId
    };
  }

  Map<String, dynamic> toDB() {
    return {
      'id': id,
      'fromMember': fromMember,
      'fromMemberId': fromMemberId,
      'fromMemberView': fromMemberView!.toJson(),
      'targetMember': targetMember,
      'targetMemberId': targetMemberId,
      'targetMemberView': targetMemberView!.toJson(),
      'content': content,
      'type': type.name,
      'block': block == false ? 0 : 1,
      'chatRoomId': chatRoomId,
      'chatType': chatType.name,
      'isRead': isRead,
      'updatedAt': updatedAt,
      'createdAt': createdAt,
      'status': status
    };
  }

  Map<String, dynamic> upDateIsRead() {
    return {
      'isRead': isRead,
      'updatedAt': updatedAt,
    };
  }

  Map<String, dynamic> toWs() {
    return {
      'fromMember': fromMember,
      'fromMemberId': fromMemberId,
      'fromMemberNickname': fromMemberNickname,
      'content': content,
      'targetMember': targetMember,
      'targetMemberId': targetMemberId,
      'type': type.name,
      'destination': '',
      'chatRoomId': chatRoomId,
      'chatType': chatType.name,
      'memberPetId': memberPetId
    };
  }

  Map<String, dynamic> toStomp() {
    return {
      'id': id,
      'fromMember': fromMember,
      'fromMemberId': fromMemberId,
      'targetMember': targetMember,
      'targetMemberId': targetMemberId,
      'content': content,
      'type': type.index,
      'unreadCnt': unreadCnt,
      'block': block,
      'chatRoomId': chatRoomId,
      'chatType': chatType.name,
      'isRead': isRead,
      'updatedAt': updatedAt,
      'createdAt': createdAt,
      'status': status,
      'memberPetId': memberPetId
    };
  }

  String toStompString() => json.encode(toStomp());

  String toJson() => json.encode(toMap());

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is MessageModel &&
        other.id == id &&
        other.fromMember == fromMember &&
        other.fromMemberId == fromMemberId &&
        other.fromMemberView == fromMemberView &&
        other.targetMember == targetMember &&
        other.targetMemberId == targetMemberId &&
        other.targetMemberView == targetMemberView &&
        other.content == content &&
        other.type == type &&
        other.isRead == isRead &&
        other.createdAt == createdAt &&
        other.chatType == chatType &&
        other.chatRoomId == chatRoomId;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        fromMember.hashCode ^
        fromMemberId.hashCode ^
        fromMemberView.hashCode ^
        targetMember.hashCode ^
        targetMemberId.hashCode ^
        targetMemberView.hashCode ^
        content.hashCode ^
        type.hashCode ^
        isRead.hashCode ^
        createdAt.hashCode ^
        chatType.hashCode ^
        chatRoomId.hashCode;
  }
}

class GetChatMassageDTO {
  final String fromMember;
  final String targetMember;
  final String date;
  final int page;
  final int size;
  final String sortBy;

  const GetChatMassageDTO(
      {required this.fromMember,
      required this.targetMember,
      this.date = '',
      this.page = 0,
      this.size = 0,
      this.sortBy = ''});

  factory GetChatMassageDTO.fromMap(Map<String, dynamic> map) {
    return GetChatMassageDTO(
        fromMember: map['fromMember'] as String? ?? '',
        targetMember: map['targetMember'] as String? ?? '',
        date: map['date'] as String? ?? '',
        page: map['page'] as int? ?? 0,
        size: map['size'] as int? ?? 0,
        sortBy: map['sortBy'] as String? ?? '');
  }

  factory GetChatMassageDTO.fromJson(String source) =>
      GetChatMassageDTO.fromMap(json.decode(source) as Map<String, dynamic>);

  GetChatMassageDTO copyWith(
      {String? fromMember,
      String? targetMember,
      String? date,
      int? page,
      int? size,
      String? sortBy}) {
    return GetChatMassageDTO(
        fromMember: fromMember ?? this.fromMember,
        targetMember: targetMember ?? this.fromMember,
        date: date ?? this.date,
        page: page ?? this.page,
        size: size ?? this.size,
        sortBy: sortBy ?? this.sortBy);
  }

  Map<String, dynamic> toMap() {
    return {
      'fromMember': fromMember,
      'targetMember': targetMember,
      'date': date,
      'page': page,
      'size': size,
      'sortBy': sortBy
    };
  }

  String toJson() => json.encode(toMap());

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is GetChatMassageDTO &&
        other.fromMember == fromMember &&
        other.targetMember == targetMember &&
        other.date == date &&
        other.page == page &&
        other.size == size &&
        other.sortBy == sortBy;
  }

  @override
  int get hashCode {
    return fromMember.hashCode ^
        targetMember.hashCode ^
        date.hashCode ^
        page.hashCode ^
        size.hashCode ^
        sortBy.hashCode;
  }
}

class PageMessageModel {
  final List<MessageModel> content;
  final Pageable pageable;
  final Sort sort;
  final int? totalElements;
  final int? totalPages;
  final int? number;
  final int? numberOfElements;
  final int? size;
  final bool? first;
  final bool? last;
  final bool? empty;

  const PageMessageModel(
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

  factory PageMessageModel.fromMap(Map<String, dynamic> map) {
    List list = map['content'];
    return PageMessageModel(
        content: list.map((e) => MessageModel.fromMap(e)).toList(),
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

  factory PageMessageModel.fromJson(String source) =>
      PageMessageModel.fromMap(json.decode(source) as Map<String, dynamic>);

  PageMessageModel copyWith(
      {List<MessageModel>? content,
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
    return PageMessageModel(
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

    return other is PageMessageModel &&
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
