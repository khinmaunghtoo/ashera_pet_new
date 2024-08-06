import 'dart:convert';


import '../enum/message_type.dart';
import 'member.dart';

class PostMessageModel{
  final int id;
  final int memberId;
  final int postId;
  final int postMessageId;
  final int postMemberId;
  final String message;
  final MessageType messageType;
  final String reply;
  final MemberModel? member;
  final int status;
  final String createdAt;
  final String updatedAt;

  const PostMessageModel({
    this.id = 0,
    required this.memberId,
    required this.postId,
    this.postMessageId = 0,
    required this.postMemberId,
    required this.message,
    this.messageType = MessageType.TEXT,
    this.reply = '123',
    this.member,
    this.status = 1,
    this.createdAt = '',
    this.updatedAt = ''
  });

  factory PostMessageModel.fromMap(Map<String, dynamic> map){
    return PostMessageModel(
        id: map['id'] as int? ?? 0,
        memberId: map['memberId'] as int? ?? 0,
        postId: map['postId'] as int? ?? 0,
        postMessageId: map['postMessageId'] as int? ?? 0,
        postMemberId: map['postMemberId'] as int? ?? 0,
        message: map['message'] as String? ?? '',
        messageType: MessageType.values[map['messageType'] as int? ?? 0],
        reply: map['reply'] as String? ?? '',
        member: map['member'] != null ? MemberModel.fromMap(map['member']) : null,
        status: map['status'] as int? ?? 0,
        createdAt: map['createdAt'] as String? ?? '',
        updatedAt: map['updatedAt'] as String? ?? ''
    );
  }

  factory PostMessageModel.fromJson(String source) => PostMessageModel.fromMap(json.decode(source) as Map<String, dynamic>);

  PostMessageModel copyWith({
    int? id,
    int? memberId,
    int? postId,
    int? postMessageId,
    int? postMemberId,
    String? message,
    MessageType? messageType,
    String? reply,
    MemberModel? member,
    int? status,
    String? createdAt,
    String? updatedAt,
  }){
    return PostMessageModel(
        id: id ?? this.id,
        memberId: memberId ?? this.memberId,
        postId: postId ?? this.postId,
        postMessageId: postMessageId ?? this.postMessageId,
        postMemberId: postMemberId ?? this.postMemberId,
        message: message ?? this.message,
        messageType: messageType ?? this.messageType,
        reply: reply ?? this.reply,
        member: member ?? this.member,
        status: status ?? this.status,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt
    );
  }

  Map<String, dynamic> toMap(){
    return {
      'id': id,
      'memberId': memberId,
      'postId': postId,
      'postMessageId': postMessageId,
      'postMemberId': postMemberId,
      'message': message,
      'messageType': messageType.name,
      'reply': reply,
      'member': member?.toMap(),
      'status': status,
      'createdAt': createdAt,
      'updatedAt': updatedAt
    };
  }

  Map<String, dynamic> addMessage(){
    return {
      'memberId': memberId,
      'memberPetId': 0,
      'postId': postId,
      'postMessageId': postMessageId,
      'postMemberId': postMemberId,
      'message': message,
      'messageType': messageType.index,
      'status': status,
      'reply': reply
    };
  }

  String toJson() => json.encode(toMap());

  @override
  bool operator ==(Object other) {
    if(identical(this, other)) return true;

    return other is PostMessageModel &&
      other.id == id &&
      other.memberId == memberId &&
      other.postId == postId &&
      other.postMessageId == postMessageId &&
      other.postMemberId == postMemberId &&
      other.message == message &&
      other.messageType == messageType &&
      other.reply == reply &&
      other.member == member &&
      other.status == status &&
      other.createdAt == createdAt &&
      other.updatedAt == updatedAt;
  }

  @override
  int get hashCode {
    return id.hashCode ^
    memberId.hashCode ^
    postId.hashCode ^
    postMessageId.hashCode ^
    postMemberId.hashCode ^
    message.hashCode ^
    messageType.hashCode ^
    reply.hashCode ^
    member.hashCode ^
    status.hashCode ^
    createdAt.hashCode ^
    updatedAt.hashCode;
  }

}