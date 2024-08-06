import 'package:ashera_pet_new/enum/messag_notify_type.dart';
import 'package:ashera_pet_new/model/notify.dart';
import 'package:ashera_pet_new/utils/app_color.dart';
import 'package:flutter/cupertino.dart';

import 'adopt.dart';
import 'reply.dart';
import 'follow.dart';
import 'like.dart';

class NotifyCard extends StatefulWidget {
  final String title;
  final List<NotifyModel> listData;
  const NotifyCard({super.key, required this.title, required this.listData});

  @override
  State<StatefulWidget> createState() => _NotifyCardState();
}

class _NotifyCardState extends State<NotifyCard> {
  @override
  Widget build(BuildContext context) {
    if (widget.listData.isEmpty) {
      return Container();
    }
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: AppColor.textFieldUnSelect),
      child: Column(
        children: [
          _title(),
          //內容
          ...widget.listData.map((e) => _item(e))
        ],
      ),
    );
  }

  Widget _title() {
    return Container(
      alignment: Alignment.topLeft,
      padding: const EdgeInsets.only(top: 10, bottom: 5, left: 10),
      child: Text(
        widget.title,
        style: const TextStyle(
            color: AppColor.textFieldTitle,
            fontWeight: FontWeight.w800,
            fontSize: 15),
      ),
    );
  }

  Widget _item(NotifyModel model) {
    switch (model.messageNotifyType) {
      case MessageNotifyType.NORMAL:
        return Container();
      case MessageNotifyType.FOLLOW:
        return NotifyCardFollow(model: model);
      case MessageNotifyType.FOLLOW_REQUEST:
        return NotifyCardFollow(model: model);
      case MessageNotifyType.MESSAGE:
        return NotifyCardReply(model: model);
      case MessageNotifyType.POST_LIKE:
        return NotifyCardLike(model: model);
      case MessageNotifyType.ADOPT:
        return NotifyCardAdopt(model: model);
    }
  }
}
