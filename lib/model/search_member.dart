import 'dart:convert';

import 'package:ashera_pet_new/model/post.dart';

class SearchMember {
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
  final List<MemberPetView> memberPet;
  final int status;

  const SearchMember(
      {required this.id,
      required this.name,
      required this.nickname,
      required this.birthday,
      required this.aboutMe,
      required this.age,
      required this.cellphone,
      required this.gender,
      required this.mugshot,
      required this.customerService,
      required this.memberPet,
      required this.status});

  factory SearchMember.fromMap(Map<String, dynamic> map) {
    List list = map['memberPet'];
    return SearchMember(
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
        memberPet: list.map((e) => MemberPetView.fromMap(e)).toList(),
        status: map['status'] as int? ?? 1);
  }

  factory SearchMember.fromJson(String source) =>
      SearchMember.fromMap(json.decode(source) as Map<String, dynamic>);

  SearchMember copyWith(
      {int? id,
      String? name,
      String? nickname,
      String? birthday,
      String? aboutMe,
      int? age,
      String? cellphone,
      int? gender,
      String? mugshot,
      bool? customerService,
      List<MemberPetView>? memberPet,
      int? status}) {
    return SearchMember(
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
        memberPet: memberPet ?? this.memberPet,
        status: status ?? this.status);
  }

  Map<String, dynamic> toMap() {
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
      'memberPet': memberPet,
      'status': status
    };
  }

  String toJson() => json.encode(toMap());

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is SearchMember &&
        other.id == id &&
        other.name == name &&
        other.nickname == nickname &&
        other.aboutMe == aboutMe &&
        other.age == age &&
        other.cellphone == cellphone &&
        other.gender == gender &&
        other.mugshot == mugshot &&
        other.memberPet == memberPet;
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
        mugshot.hashCode ^
        memberPet.hashCode;
  }
}
