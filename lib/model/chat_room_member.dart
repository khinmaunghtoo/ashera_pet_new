import 'dart:convert';

import 'package:ashera_pet_new/enum/member_status.dart';
import 'package:ashera_pet_new/model/member_view.dart';
import 'package:ashera_pet_new/model/post.dart';

import '../enum/chat_type.dart';

class ChatRoomModel {
  final int id;
  final int memberId;
  final int memberPetId;
  final String uuid;
  final MemberView memberView;
  final MemberPetView memberPetView;
  final MemberStatus status;
  final ChatType chatType;
  final String updatedAt;
  final String createdAt;

  const ChatRoomModel(
      {this.id = 0,
      this.memberId = 0,
      this.memberPetId = 0,
      this.uuid = '',
      this.memberView = const MemberView(),
      this.memberPetView = const MemberPetView(),
      this.status = MemberStatus.ACTIVE,
      this.chatType = ChatType.GENERAL,
      this.updatedAt = '',
      this.createdAt = ''});

  factory ChatRoomModel.fromMap(Map<String, dynamic> map) {
    return ChatRoomModel(
        id: map['id'] as int? ?? 0,
        memberId: map['memberId'] as int? ?? 0,
        memberPetId: map['memberPetId'] as int? ?? 0,
        uuid: map['uuid'] as String? ?? '',
        memberView: map['memberView'] != null
            ? MemberView.fromMap(map['memberView'])
            : const MemberView(),
        memberPetView: map['memberPetView'] != null
            ? MemberPetView.fromMap(map['memberPetView'])
            : const MemberPetView(),
        status: MemberStatus.values.byName(map['status']),
        chatType: ChatType.values.byName(map['chatType']),
        updatedAt: map['updatedAt'],
        createdAt: map['createdAt']);
  }

  factory ChatRoomModel.fromJson(String source) =>
      ChatRoomModel.fromMap(json.decode(source) as Map<String, dynamic>);

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'memberId': memberId,
      'memberPetId': memberPetId,
      'uuid': uuid,
      'memberView': memberView.toMap(),
      'memberPetView': memberPetView.toMap(),
      'status': status.name,
      'chatType': chatType.name,
      'updatedAt': updatedAt,
      'createdAt': createdAt
    };
  }

  String toJson() => json.encode(toMap());

  Map<String, dynamic> createdChatRoomMap() {
    return {
      'memberId': memberId,
      'memberPetId': memberPetId,
      'uuid': uuid,
      'status': status.name,
      'chatType': chatType.name
    };
  }
}

class ChatRoomMemberModel {
  final int id;
  final int memberId;
  final int memberPetId;
  final int chatRoomId;
  final ChatType chatType;
  final MemberView memberView;
  final ChatRoomModel chatRoom;

  const ChatRoomMemberModel(
      {this.id = 0,
      this.memberId = 0,
      this.memberPetId = 0,
      this.chatRoomId = 0,
      this.chatType = ChatType.GENERAL,
      this.memberView = const MemberView(),
      this.chatRoom = const ChatRoomModel()});

  factory ChatRoomMemberModel.fromMap(Map<String, dynamic> map) {
    return ChatRoomMemberModel(
        id: map['id'],
        memberId: map['memberId'],
        memberPetId: map['memberPetId'],
        chatRoomId: map['chatRoomId'],
        chatType: ChatType.values.byName(map['chatType']),
        memberView: map['memberView'] != null
            ? MemberView.fromMap(map['memberView'])
            : const MemberView(),
        chatRoom: map['chatRoom'] != null
            ? ChatRoomModel.fromMap(map['chatRoom'])
            : const ChatRoomModel());
  }

  factory ChatRoomMemberModel.fromJson(String source) =>
      ChatRoomMemberModel.fromMap(json.decode(source) as Map<String, dynamic>);

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'memberId': memberId,
      'memberPetId': memberPetId,
      'chatRoomId': chatRoomId,
      'chatType': chatType.name,
      'memberView': memberView.toMap(),
      'chatRoom': chatRoom.toMap()
    };
  }

  Map<String, dynamic> addMember() {
    return {
      'memberId': memberId,
      'chatRoomId': chatRoomId,
      'chatType': chatType.name,
    };
  }

  Map<String, dynamic> addMemberAndPet() {
    return {
      'memberId': memberId,
      'memberPetId': memberPetId,
      'chatRoomId': chatRoomId,
      'chatType': chatType.name
    };
  }

  Map<String, dynamic> addMemberToDB() {
    return {
      'id': id,
      'chatRoomId': chatRoomId,
      'memberId': memberId,
      'memberPetId': memberPetId,
      'chatType': chatType.name,
    };
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ChatRoomMemberModel &&
        other.id == id &&
        other.memberId == memberId &&
        other.memberPetId == memberPetId &&
        other.chatRoomId == chatRoomId &&
        other.chatType == chatType &&
        other.memberView == memberView &&
        other.chatRoom == chatRoom;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        memberId.hashCode ^
        memberPetId.hashCode ^
        chatRoomId.hashCode ^
        chatType.hashCode ^
        memberView.hashCode ^
        chatRoom.hashCode;
  }
}

class ChatRoomMemberDTO {
  final int memberId;
  final ChatType chatType;

  const ChatRoomMemberDTO({
    required this.memberId,
    required this.chatType,
  });

  Map<String, dynamic> toMap() {
    return {'memberId': memberId, 'chatType': chatType.name};
  }
}
