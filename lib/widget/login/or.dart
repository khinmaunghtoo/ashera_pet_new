import 'package:ashera_pet_new/utils/app_color.dart';
import 'package:flutter/cupertino.dart';

class Or extends StatelessWidget {
  const Or({super.key});
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
            child: Container(
          width: 120,
          height: 1,
          decoration: const BoxDecoration(color: AppColor.textFieldHintText),
        )),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: const Text(
            '或',
            style: TextStyle(
              color: AppColor.textFieldHintText,
            ),
          ),
        ),
        Expanded(
            child: Container(
          width: 120,
          height: 1,
          decoration: const BoxDecoration(color: AppColor.textFieldHintText),
        )),
      ],
    );
  }
}
