import 'dart:convert';

class TargetMemberWarningDto{
  final int targetMemberId;
  final bool warning;

  const TargetMemberWarningDto({
    required this.targetMemberId,
    required this.warning
  });

  factory TargetMemberWarningDto.fromMap(Map<String, dynamic> map){
    return TargetMemberWarningDto(
        targetMemberId: map['targetMemberId'],
        warning: map['warning']
    );
  }

  factory TargetMemberWarningDto.fromJson(String source) => TargetMemberWarningDto.fromMap(json.decode(source) as Map<String, dynamic>);

  TargetMemberWarningDto copyWith({
    int? targetMemberId,
    bool? warning
  }){
    return TargetMemberWarningDto(
      targetMemberId: targetMemberId ?? this.targetMemberId,
      warning: warning ?? this.warning
    );
  }

  Map<String, dynamic> toWs(){
    return {
      'targetMemberId': targetMemberId,
    };
  }

  Map<String, dynamic> toMap(){
    return {
      'targetMemberId': targetMemberId,
      'warning': warning
    };
  }
}