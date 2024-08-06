import 'package:flutter/cupertino.dart';

import '../../utils/app_color.dart';

class UserAsheraLogin extends StatelessWidget{
  final VoidCallback callback;
  const UserAsheraLogin({super.key, required this.callback});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: callback,
      child: const Text(
          '使用 Ashera 帳號登入',
          style: TextStyle(
            color: AppColor.asheraAccount,
            fontSize: 15
          ),
      ),
    );
  }
}