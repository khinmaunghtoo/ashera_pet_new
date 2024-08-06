class ForgotPasswordModel {
  final String code;
  final String number;
  final String password;

  const ForgotPasswordModel({
    required this.code,
    required this.number,
    required this.password
  });

  Map<String, dynamic> toMap(){
    return {
      'code': code,
      'number': number,
      'password': password
    };
  }
}