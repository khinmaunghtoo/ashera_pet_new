import 'dart:convert';


//* 用戶信息
class UserLoginResDTO{
  final GenerateTokenBody body;
  final int lastLoginAt;
  final int userId;

  const UserLoginResDTO({
    required this.body,
    required this.lastLoginAt,
    required this.userId
  });

  factory UserLoginResDTO.fromMap(Map<String, dynamic> map){
    return UserLoginResDTO(
        body: GenerateTokenBody.fromMap(map['body']),
        lastLoginAt: map['lastLoginAt'] as int? ?? 0,
        userId: map['userId'] as int? ?? 0,
    );
  }

  factory UserLoginResDTO.fromJson(String source) => UserLoginResDTO.fromMap(json.decode(source) as Map<String, dynamic>);

  UserLoginResDTO copyWith({
    GenerateTokenBody? body,
    int? lastLoginAt,
    int? userId
  }){
    return UserLoginResDTO(
        body: body ?? this.body,
        lastLoginAt: lastLoginAt ?? this.lastLoginAt,
        userId: userId ?? this.userId
    );
  }

  Map<String, dynamic> toMap(){
    return {
      'body': body,
      'lastLoginAt': lastLoginAt,
      'userId': userId
    };
  }

  @override
  bool operator ==(Object other) {
    if(identical(this, other)) return true;

    return other is UserLoginResDTO &&
      other.body == body &&
      other.userId == userId &&
      other.lastLoginAt == lastLoginAt;
  }

  @override
  int get hashCode {
    return body.hashCode ^ lastLoginAt.hashCode ^ userId.hashCode;
  }
}
class GenerateTokenBody{
  final int expiredTime;
  final String token;

  const GenerateTokenBody({
    required this.expiredTime,
    required this.token
  });

  factory GenerateTokenBody.fromMap(Map<String, dynamic> map){
    return GenerateTokenBody(
        expiredTime: map['expiredTime'] as int? ?? 0,
        token: map['token'] as String? ?? ''
    );
  }

  factory GenerateTokenBody.fromJson(String source) => GenerateTokenBody.fromMap(json.decode(source) as Map<String, dynamic>);

  GenerateTokenBody copyWith({
    int? expiredTime,
    String? token
  }) {
    return GenerateTokenBody(
        expiredTime: expiredTime ?? this.expiredTime,
        token: token ?? this.token
    );
  }

  Map<String, dynamic> toMap(){
    return {
      'expiredTime': expiredTime,
      'token': token
    };
  }

  String toJson() => json.encode(toMap());

  @override
  bool operator ==(Object other) {
    if(identical(this, other)) return true;

    return other is GenerateTokenBody &&
      other.expiredTime == expiredTime &&
      other.token == token;
  }

  @override
  int get hashCode {
    return expiredTime.hashCode ^
    token.hashCode;
  }
}