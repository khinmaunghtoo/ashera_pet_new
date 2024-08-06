import 'dart:convert';

class LoginCredential {
  final String name;
  final String password;

  const LoginCredential({required this.name, required this.password});

  Map<String, dynamic> toMap() {
    return {'name': name, 'password': password};
  }

  String toJson() => json.encode(toMap());
}
