import 'package:ashera_pet_new/utils/app_color.dart';
import 'package:flutter/cupertino.dart';

class LoginAsheraTitle extends StatelessWidget {
  const LoginAsheraTitle({super.key});
  @override
  Widget build(BuildContext context) {
    return const Text(
      'Ashera登入',
      style: TextStyle(fontSize: 26, color: AppColor.textFieldTitle),
    );
  }
}
