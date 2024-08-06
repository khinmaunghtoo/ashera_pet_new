import 'package:ashera_pet_new/utils/app_color.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';

class GoToLogin extends StatelessWidget {
  final VoidCallback callback;
  const GoToLogin({super.key, required this.callback});

  @override
  Widget build(BuildContext context) {
    return RichText(
        text: TextSpan(
            text: '已有帳號了?',
            style:
                const TextStyle(color: AppColor.textFieldTitle, fontSize: 15),
            children: [
          TextSpan(
              text: ' 去登入',
              style: const TextStyle(color: AppColor.button),
              recognizer: TapGestureRecognizer()..onTap = callback)
        ]));
  }
}
