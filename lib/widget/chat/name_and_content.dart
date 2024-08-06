import 'package:flutter/cupertino.dart';

import '../../enum/message_type.dart';
import '../../utils/app_color.dart';

class NameAndContent extends StatelessWidget{
  final dynamic userData;
  final String content;
  final MessageType type;
  const NameAndContent({super.key, required this.userData, required this.content, required this.type});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                userData.nickname,
                style: const TextStyle(
                    color: AppColor.textFieldTitle,
                    fontSize: 16,
                    fontWeight: FontWeight.w500
                ),
              ),
            ],
          ),
          Text(
            _getText(type, content),
            style: const TextStyle(
                color: AppColor.textFieldHintText,
                fontSize: 12,
              overflow: TextOverflow.ellipsis,
            ),
          )
        ],
      ),
    );
  }

  String _getText(MessageType type, String content){
    switch(type){
      case MessageType.TEXT:
        return content;
      case MessageType.AUDIO:
        return '傳送了一則錄音訊息';
      case MessageType.VIDEO:
        return '傳送了一則影片訊息';
      case MessageType.PIC:
        return '傳送了一則圖片訊息';
      case MessageType.VIDEO_CALL:
        return '「視訊」';
      case MessageType.VOICE_CALL:
        return '「通話」';
    }
  }
}