import 'dart:convert';

import '../enum/member_status.dart';

// 会员（用户）
class MemberModel{
  final int id;
  final String name;
  final String nickname;
  final String birthday;
  final String aboutMe;
  final int age;
  final String cellphone;
  final int gender;
  final String mugshot;
  final bool customerService;
  final MemberStatus status;
  final bool messageNotifyStatus;

  const MemberModel({
    required this.id,
    required this.name,
    required this.nickname,
    required this.birthday,
    required this.aboutMe,
    required this.age,
    required this.cellphone,
    required this.gender,
    required this.mugshot,
    this.customerService = false,
    this.status = MemberStatus.NONE,
    this.messageNotifyStatus = false
  });

  factory MemberModel.fromMap(Map<String, dynamic> map){
    return MemberModel(
        id: map['id'] as int? ?? 0,
        name: map['name'] as String? ?? '',
        nickname: map['nickname'] as String? ?? '',
        birthday: map['birthday'] as String? ?? '',
        aboutMe: map['aboutMe'] as String? ?? '',
        age: map['age'] as int? ?? 0,
        cellphone: map['cellphone'] as String? ?? '',
        gender: map['gender'] as int? ?? 0,
        mugshot: map['mugshot'] as String? ?? '',
        customerService: map['customerService'] as bool? ?? false,
        status: MemberStatus.values[map['status'] as int? ?? 0],
        messageNotifyStatus: map['messageNotifyStatus'] as bool? ?? false
    );
  }

  factory MemberModel.fromJson(String source) => MemberModel.fromMap(json.decode(source) as Map<String, dynamic>);

  MemberModel copyWith({
    int? id,
    String? name,
    String? nickname,
    String? birthday,
    String? aboutMe,
    int? age,
    String? cellphone,
    int? gender,
    String? mugshot,
    bool? customerService,
    MemberStatus? status,
    bool? messageNotifyStatus
  }){
    return MemberModel(
        id: id ?? this.id,
        name: name ?? this.name,
        nickname: nickname ?? this.nickname,
        birthday: birthday ?? this.birthday,
        aboutMe: aboutMe ?? this.aboutMe,
        age: age ?? this.age,
        cellphone: cellphone ?? this.cellphone,
        gender: gender ?? this.gender,
        mugshot: mugshot ?? this.mugshot,
        customerService: customerService ?? this.customerService,
        status: status ?? this.status,
        messageNotifyStatus: messageNotifyStatus ?? this.messageNotifyStatus
    );
  }

  Map<String, dynamic> toMap(){
    return {
      'id': id,
      'name': name,
      'nickname': nickname,
      'birthday': birthday,
      'aboutMe': aboutMe,
      'age': age,
      'cellphone': cellphone,
      'gender': gender,
      'mugshot': mugshot,
      'customerService': customerService,
      'status': status.index,
      'messageNotifyStatus': messageNotifyStatus
    };
  }

  Map<String, dynamic> updateMap(){
    return {
      'name': name,
      'nickname': nickname,
      'birthday': birthday,
      'aboutMe': aboutMe,
      'age': age,
      'cellphone': cellphone,
      'gender': gender,
      'mugshot': mugshot,
    };
  }

  String toJson() => json.encode(toMap());

  @override
  bool operator ==(Object other) {
    if(identical(this, other)) return true;

    return other is MemberModel &&
      other.id == id &&
      other.name == name &&
      other.nickname == nickname &&
      other.aboutMe == aboutMe &&
      other.age == age &&
      other.cellphone == cellphone &&
      other.gender == gender &&
      other.mugshot == mugshot;
  }

  @override
  int get hashCode {
    return id.hashCode ^
    name.hashCode ^
    nickname.hashCode ^
    aboutMe.hashCode ^
    age.hashCode ^
    cellphone.hashCode ^
    gender.hashCode ^
    mugshot.hashCode;
  }
}

class UpdateMemberPasswordWithOldDTO{
  final String newPassword;
  final String oldPassword;

  const UpdateMemberPasswordWithOldDTO({
    required this.newPassword,
    required this.oldPassword
  });

  factory UpdateMemberPasswordWithOldDTO.fromMap(Map<String, dynamic> map){
    return UpdateMemberPasswordWithOldDTO(
        newPassword: map['newPassword'] as String? ?? '',
        oldPassword: map['oldPassword'] as String? ?? ''
    );
  }

  Map<String, dynamic> toMap(){
    return{
      'newPassword': newPassword,
      'oldPassword': oldPassword
    };
  }

  String toJson() => json.encode(toMap());
}