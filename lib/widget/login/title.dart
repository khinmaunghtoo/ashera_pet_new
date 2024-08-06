import 'package:ashera_pet_new/utils/app_color.dart';
import 'package:flutter/cupertino.dart';

class LoginTitle extends StatelessWidget {
  const LoginTitle({super.key});

  @override
  Widget build(BuildContext context) {
    return const Text(
      '登入',
      style: TextStyle(fontSize: 26, color: AppColor.textFieldTitle),
    );
  }
}
