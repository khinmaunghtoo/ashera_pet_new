import 'package:flutter/material.dart';

import '../../../enum/adopt_status.dart';

class ChatPassOrNotTextWidget extends StatelessWidget{
  final ComplaintRecordStatus status;
  const ChatPassOrNotTextWidget({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    return Text.rich(
      TextSpan(
        text: '檢舉內容 : ',
        style: const TextStyle(
          color: Colors.white,
        ),
        children: [
          TextSpan(
            text: status.zh,
            style: TextStyle(
              color: status.color,
              fontWeight: FontWeight.bold,
              decoration: TextDecoration.underline,
              decorationColor: status.color,
            )
          )
        ]
      )
    );
  }
}