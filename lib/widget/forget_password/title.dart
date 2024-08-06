import 'package:flutter/cupertino.dart';

import '../../utils/app_color.dart';

class ForgetPasswordTitle extends StatelessWidget{
  const ForgetPasswordTitle({super.key});

  @override
  Widget build(BuildContext context) {
    return const Text(
      '忘記密碼',
      style: TextStyle(
          fontSize: 26,
          color: AppColor.textFieldTitle
      ),
    );
  }
}