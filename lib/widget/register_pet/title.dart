import 'package:ashera_pet_new/utils/app_color.dart';
import 'package:flutter/cupertino.dart';

class RegisterPetTitle extends StatelessWidget {
  const RegisterPetTitle({super.key});

  @override
  Widget build(BuildContext context) {
    return const Text(
      '設定寵物資料',
      style: TextStyle(fontSize: 26, color: AppColor.textFieldTitle),
    );
  }
}
