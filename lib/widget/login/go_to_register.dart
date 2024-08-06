import 'package:ashera_pet_new/utils/app_color.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';

class GoToRegister extends StatelessWidget {
  final VoidCallback callback;
  const GoToRegister({super.key, required this.callback});

  @override
  Widget build(BuildContext context) {
    return RichText(
        text: TextSpan(
            text: '還沒有帳號?',
            style:
                const TextStyle(color: AppColor.textFieldTitle, fontSize: 15),
            children: [
          TextSpan(
              text: ' 去註冊',
              style: const TextStyle(color: AppColor.button),
              recognizer: TapGestureRecognizer()..onTap = callback)
        ]));
  }
}
