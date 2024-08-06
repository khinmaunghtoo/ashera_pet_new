import 'dart:convert';

import 'package:ashera_pet_new/enum/member_status.dart';

import '../enum/chat_type.dart';
import 'member.dart';
import 'member_view.dart';
import 'message.dart';

class MemberPetModel {
  final int id;
  final int memberId;
  final String mugshot;
  final String facePic;
  final String nickname;
  final String aboutMe;
  final int age;
  final String birthday;
  final int animalType;
  final int gender;
  final int healthStatus;
  final MemberStatus status;
  final MemberView? member;
  final num latitude;
  final num longitude;
  final String pics;

  const MemberPetModel(
      {required this.id,
      required this.memberId,
      required this.mugshot,
      this.facePic = '',
      required this.nickname,
      required this.aboutMe,
      required this.age,
      required this.birthday,
      required this.animalType,
      required this.gender,
      required this.healthStatus,
      required this.member,
      this.latitude = 0.0,
      this.longitude = 0.0,
      this.pics = '',
      required this.status});

  factory MemberPetModel.fromMap(Map<String, dynamic> map) {
    return MemberPetModel(
        id: map['id'] as int? ?? 0,
        memberId: map['memberId'] as int? ?? 0,
        mugshot: map['mugshot'] as String? ?? '',
        facePic: map['facePic'] as String? ?? '',
        nickname: map['nickname'] as String? ?? '',
        aboutMe: map['aboutMe'] as String? ?? '',
        age: map['age'] as int? ?? 0,
        birthday: map['birthday'] != null
            ? map['birthday'].toString().substring(0, 7)
            : '',
        animalType: map['animalType'] as int? ?? 0,
        gender: map['gender'] as int? ?? 0,
        healthStatus: map['healthStatus'] as int? ?? 0,
        member: map['member'].runtimeType == String
            ? MemberView.fromJson(map['member'] ?? '{}')
            : MemberView.fromMap(map['member'] ?? {}),
        latitude: map['latitude'] as double? ?? 0.0,
        longitude: map['longitude'] as double? ?? 0.0,
        pics: map['pics'] as String? ?? '[]',
        status: map['status'].runtimeType == String
            ? MemberStatus.values.byName(map['status'])
            : MemberStatus.values[map['status'] as int? ?? 0]);
  }

  factory MemberPetModel.fromJson(String source) =>
      MemberPetModel.fromMap(json.decode(source) as Map<String, dynamic>);

  MemberPetModel copyWith(
      {int? id,
      int? memberId,
      String? mugshot,
      String? facePic,
      String? nickname,
      String? aboutMe,
      int? age,
      String? birthday,
      int? animalType,
      int? gender,
      int? healthStatus,
      MemberView? member,
      num? latitude,
      num? longitude,
      String? pics,
      MemberStatus? status}) {
    return MemberPetModel(
        id: id ?? this.id,
        memberId: memberId ?? this.memberId,
        mugshot: mugshot ?? this.mugshot,
        facePic: facePic ?? this.facePic,
        nickname: nickname ?? this.nickname,
        aboutMe: aboutMe ?? this.aboutMe,
        age: age ?? this.age,
        birthday: birthday ?? this.birthday,
        animalType: animalType ?? this.animalType,
        gender: gender ?? this.gender,
        healthStatus: healthStatus ?? this.healthStatus,
        member: member ?? this.member,
        latitude: latitude ?? this.latitude,
        longitude: longitude ?? this.longitude,
        pics: pics ?? this.pics,
        status: status ?? this.status);
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'memberId': memberId,
      'nickname': nickname,
      'mugshot': mugshot,
      'facePic': facePic,
      'aboutMe': aboutMe,
      'age': age,
      'birthday': birthday,
      'animalType': animalType,
      'gender': gender,
      'healthStatus': healthStatus,
      'member': json.encode(member),
      'latitude': latitude,
      'longitude': longitude,
      'pics': pics,
      'status': status.index
    };
  }

  Map<String, dynamic> addToDB() {
    return {
      'id': id,
      'memberId': memberId,
      'nickname': nickname,
      'mugshot': mugshot,
      'facePic': facePic,
      'aboutMe': aboutMe,
      'age': age,
      'birthday': birthday,
      'animalType': animalType,
      'gender': gender,
      'healthStatus': healthStatus,
      'member': json.encode(member),
      'status': status.index
    };
  }

  Map<String, dynamic> addMemberPetDTO() {
    return {
      'memberId': memberId,
      'mugshot': mugshot,
      'nickname': nickname,
      'aboutMe': aboutMe,
      'age': age,
      'birthday': birthday,
      'animalType': animalType,
      'gender': gender,
      'healthStatus': healthStatus
    };
  }

  Map<String, dynamic> updateMemberPetDTO() {
    return {
      'id': id,
      'mugshot': mugshot,
      'facePic': facePic,
      'nickname': nickname,
      'aboutMe': aboutMe,
      'age': age,
      'birthday': birthday,
      'gender': gender,
      'healthStatus': healthStatus,
      'pics': pics,
      'latitude': latitude,
      'longitude': longitude,
    };
  }

  Map<String, dynamic> addAllPetToDB() {
    return {
      'id': id,
      'memberId': memberId,
      'mugshot': mugshot,
      'facePic': facePic,
      'nickname': nickname,
      'aboutMe': aboutMe,
      'age': age,
      'birthday': birthday,
      'animalType': animalType,
      'gender': gender,
      'healthStatus': healthStatus,
      'status': status.name,
      'member': json.encode(member?.toMap()),
      'latitude': latitude,
      'longitude': longitude,
      'pics': pics
    };
  }

  String toJson() => json.encode(toMap());

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is MemberPetModel &&
        other.id == id &&
        other.mugshot == mugshot &&
        other.aboutMe == aboutMe &&
        other.nickname == nickname &&
        other.age == age &&
        other.birthday == birthday &&
        other.healthStatus == healthStatus &&
        other.latitude == latitude &&
        other.longitude == longitude &&
        other.pics == pics;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        mugshot.hashCode ^
        aboutMe.hashCode ^
        nickname.hashCode ^
        age.hashCode ^
        birthday.hashCode ^
        healthStatus.hashCode ^
        latitude.hashCode ^
        longitude.hashCode ^
        pics.hashCode;
  }
}

class MemberAndMsgLast {
  final MemberModel member;
  final MessageModel? msg;
  final MemberPetModel? pet;
  final ChatType chatType;
  final int? chatRoomId;

  const MemberAndMsgLast(
      {required this.member,
      this.msg,
      this.pet,
      required this.chatType,
      this.chatRoomId});

  Map<String, dynamic> toMap() {
    return {
      'member': member.toJson(),
      'msg': msg?.toJson(),
      'pet': pet?.toJson(),
      'chatType': chatType,
      'chatRoomId': chatRoomId
    };
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is MemberAndMsgLast &&
        other.member == member &&
        other.msg == msg &&
        other.pet == pet;
  }

  @override
  int get hashCode {
    return member.hashCode ^ msg.hashCode ^ pet.hashCode;
  }
}

class MemberPetLocationDTO {
  final int memberPetId;
  final num latitude;
  final num longitude;

  const MemberPetLocationDTO(
      {required this.memberPetId,
      required this.latitude,
      required this.longitude});

  Map<String, dynamic> toMap() {
    return {
      'memberPetId': memberPetId,
      'latitude': latitude,
      'longitude': longitude
    };
  }
}
