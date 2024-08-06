import 'dart:convert';

class UpdateAdoptRecordReplyDTO{
  final int id;
  final String fromMember;
  final String targetMember;
  final String reply;
  final String replyPics;

  const UpdateAdoptRecordReplyDTO({
    required this.id,
    required this.fromMember,
    required this.targetMember,
    required this.reply,
    required this.replyPics
  });

  factory UpdateAdoptRecordReplyDTO.fromMap(Map<String, dynamic> map){
    return UpdateAdoptRecordReplyDTO(
        id: map['id'] as int? ?? 0,
        fromMember: map['fromMember'] as String? ?? '',
        targetMember: map['targetMember'] as String? ?? '',
        reply: map['reply'] as String? ?? '',
        replyPics: map['replyPics'] as String? ?? ''
    );
  }

  factory UpdateAdoptRecordReplyDTO.fromJson(String source) => UpdateAdoptRecordReplyDTO.fromMap(json.decode(source) as Map<String, dynamic>);

  Map<String, dynamic> toMap(){
    return {
      'id': id,
      'fromMember': fromMember,
      'targetMember': targetMember,
      'reply': reply,
      'replyPics': replyPics
    };
  }

  String toJson() => json.encode(toMap());
}