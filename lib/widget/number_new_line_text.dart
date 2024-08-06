import 'package:flutter/material.dart';

import '../utils/app_color.dart';
import '../utils/utils.dart';

class NumberNewLineText extends StatelessWidget {
  final int number;
  final String text;
  final bool isRead;
  const NumberNewLineText(
      {super.key, required this.number, required this.text, this.isRead = false});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Stack(
          fit: StackFit.loose,
          alignment: Alignment.center,
          children: [
            FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                '  ${Utils.getNumber(number)}  ',
                style: const TextStyle(
                    color: AppColor.textFieldTitle,
                    fontSize: 18,
                    fontWeight: FontWeight.bold
                ),
              ),
            ),
            Positioned(
                left: 0,
                top: 0,
                child: Visibility(
                    visible: isRead,
                    child: Container(
                      width: 8,
                      height: 8,
                      decoration: const BoxDecoration(
                          color: Colors.red, shape: BoxShape.circle),
                    ))
            )
          ],
        ),
        Container(
            padding: const EdgeInsets.symmetric(vertical: 5),
            child: Text(
              text,
              style:
                  const TextStyle(color: AppColor.textFieldTitle, fontSize: 16),
            )),
      ],
    );
  }
}
