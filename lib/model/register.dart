import 'dart:convert';

import 'package:ashera_pet_new/enum/register.dart';

import 'member.dart';

class AddRegisterDTO {
  final String name;
  final String nickname;
  final String password;
  final String cellphone;
  final String verificationCode;

  const AddRegisterDTO(
      {required this.name,
      required this.nickname,
      required this.password,
      required this.cellphone,
      required this.verificationCode});

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'nickname': nickname,
      'password': password,
      'cellphone': cellphone,
      'verificationCode': verificationCode
    };
  }

  String toJson() => json.encode(toMap());
}

class AddMemberFromAsheraDTO {
  final String name;
  final String password;

  const AddMemberFromAsheraDTO({required this.name, required this.password});

  Map<String, dynamic> toMap() {
    return {'name': name, 'password': password};
  }

  String toJson() => json.encode(toMap());
}

class RegMemberResDTO {
  final RegMemberResCode code;
  final MemberModel member;

  const RegMemberResDTO({required this.code, required this.member});

  factory RegMemberResDTO.fromMap(Map<String, dynamic> map) {
    return RegMemberResDTO(
        code: RegMemberResCode.values.byName(map['code']),
        member: MemberModel.fromMap(map['member']));
  }

  factory RegMemberResDTO.fromJson(String source) =>
      RegMemberResDTO.fromMap(json.decode(source) as Map<String, dynamic>);

  RegMemberResDTO copyWith({RegMemberResCode? code, MemberModel? member}) {
    return RegMemberResDTO(
        code: code ?? this.code, member: member ?? this.member);
  }

  Map<String, dynamic> toMap() {
    return {'code': code, 'member': member.toMap()};
  }

  String toJson() => json.encode(toMap());

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is RegMemberResDTO &&
        other.code == code &&
        other.member == member;
  }

  @override
  int get hashCode {
    return code.hashCode ^ member.hashCode;
  }
}
