import 'dart:convert';

class MemberView{
  final int id;
  final String name;
  final String nickname;
  final int gender;
  final String birthday;
  final String mugshot;
  final int identity;
  final bool verify;
  final bool vip;
  final bool online;
  final int status;

  const MemberView({
    this.id = 0,
    this.name = '',
    this.nickname = '',
    this.gender = 1,
    this.birthday = '',
    this.mugshot = '',
    this.identity = 0,
    this.verify = false,
    this.vip = false,
    this.online = false,
    this.status = 1
  });

  factory MemberView.fromMap(Map<String, dynamic> map) {
    return MemberView(
        id: map['id'] as int? ?? 0,
        name: map['name'] as String? ?? '',
        nickname: map['nickname'] as String? ?? '',
        gender: map['gender'] as int? ?? 0,
        birthday: map['birthday'] as String? ?? '',
        mugshot: map['mugshot'] as String? ?? '',
        identity: map['identity'] as int? ?? 0,
        verify: map['verify'] as bool? ?? false,
        vip: map['vip'] as bool? ?? false,
        online: map['online'] as bool? ?? false,
        status: map['status'] as int? ?? 0
    );
  }

  factory MemberView.fromJson(String source) => MemberView.fromMap(json.decode(source) as Map<String, dynamic>);

  MemberView copyWith({
    int? id,
    String? name,
    String? nickname,
    int? gender,
    String? birthday,
    String? mugshot,
    int? identity,
    bool? verify,
    bool? vip,
    bool? online,
    int? status
  }){
    return MemberView(
        id: id ?? this.id,
        name: name ?? this.name,
        nickname: nickname ?? this.nickname,
        gender: gender ?? this.gender,
        birthday: birthday ?? this.birthday,
        mugshot: mugshot ?? this.mugshot,
        identity: identity ?? this.identity,
        verify: verify ?? this.verify,
        vip: vip ?? this.vip,
        online: online ?? this.online,
        status: status ?? this.status
    );
  }

  Map<String, dynamic> toMap(){
    return {
      'id': id,
      'name': name,
      'nickname': nickname,
      'gender': gender,
      'birthday': birthday,
      'mugshot': mugshot,
      'identity': identity,
      'verify': verify,
      'vip': vip,
      'online': online,
      'status': status
    };
  }

  String toJson() => json.encode(toMap());

  @override
  bool operator ==(Object other) {
    if(identical(this, other)) return true;

    return other is MemberView &&
    other.id == id &&
    other.name == name &&
    other.nickname == nickname &&
    other.gender == gender &&
    other.birthday == birthday &&
    other.mugshot == mugshot &&
    other.identity == identity &&
    other.verify == verify &&
    other.vip == vip &&
    other.online == online &&
    other.status == status;
  }

  @override
  int get hashCode {
    return id.hashCode ^
    name.hashCode ^
    nickname.hashCode ^
    gender.hashCode ^
    birthday.hashCode ^
    gender.hashCode ^
    birthday.hashCode ^
    mugshot.hashCode ^
    identity.hashCode ^
    verify.hashCode ^
    vip.hashCode ^
    online.hashCode ^
    status.hashCode;
  }
}