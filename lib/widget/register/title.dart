import 'package:ashera_pet_new/utils/app_color.dart';
import 'package:flutter/cupertino.dart';

class RegisterTitle extends StatelessWidget {
  const RegisterTitle({super.key});

  @override
  Widget build(BuildContext context) {
    return const Text(
      '註冊',
      style: TextStyle(fontSize: 26, color: AppColor.textFieldTitle),
    );
  }
}
