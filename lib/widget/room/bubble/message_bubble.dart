import 'package:ashera_pet_new/widget/time_line/app_widget/avatars.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../model/member.dart';
import '../../../model/message.dart';
import '../../../routes/route_name.dart';
import '../../../utils/app_color.dart';
import '../../../utils/utils.dart';
import 'bubble_background.dart';

@immutable
class MessageBubble extends StatelessWidget {
  final EdgeInsetsGeometry padding;
  const MessageBubble(
      {super.key,
      required this.member,
      required this.showAvatar,
      required this.message,
      required this.child,
      this.padding = const EdgeInsets.all(12.0)});
  final MemberModel member;
  final bool showAvatar;
  final MessageModel message;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final messageAlignment =
        !message.isMine ? Alignment.topLeft : Alignment.topRight;
    return Row(
      children: [
        SizedBox(
          width: 30,
          child: showAvatar
              ? Avatar.small(
                  user: member,
                  callback: () {
                    context.push(RouteName.searchPet, extra: member);
                  },
                )
              : Container(),
        ),
        Flexible(
            fit: FlexFit.loose,
            child: FractionallySizedBox(
              alignment: messageAlignment,
              widthFactor: 1,
              child: Align(
                alignment: messageAlignment,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      vertical: 6.0, horizontal: 10.0),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      //自己時間&已讀
                      Offstage(
                        offstage: !message.isMine,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 5),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Offstage(
                                offstage: message.isRead == 0,
                                child: const Text(
                                  '已讀',
                                  style: TextStyle(
                                      color: AppColor.textFieldTitle,
                                      fontSize: 14),
                                ),
                              ),
                              Text(
                                Utils.sqlTimeToHHAndMM(message.createdAt),
                                style: const TextStyle(
                                    color: AppColor.textFieldTitle,
                                    fontSize: 14),
                              ),
                            ],
                          ),
                        ),
                      ),
                      //內容
                      Flexible(
                          fit: FlexFit.loose,
                          child: ClipRRect(
                            borderRadius: !message.isMine
                                ? const BorderRadius.only(
                                    topLeft: Radius.circular(16.0),
                                    topRight: Radius.circular(16.0),
                                    bottomRight: Radius.circular(16.0),
                                    bottomLeft: Radius.circular(0))
                                : const BorderRadius.only(
                                    topLeft: Radius.circular(16.0),
                                    topRight: Radius.circular(16.0),
                                    bottomRight: Radius.circular(0),
                                    bottomLeft: Radius.circular(16.0)),
                            child: BubbleBackground(
                              colors: [
                                if (!message.isMine) ...const [
                                  Color(0xFF6C7689),
                                  Color(0xFF3A364B),
                                ] else ...const [
                                  Color(0xFF19B7FF),
                                  Color(0xFF491CCB),
                                ],
                              ],
                              child: DefaultTextStyle.merge(
                                style: const TextStyle(
                                  fontSize: 18.0,
                                  color: Colors.white,
                                ),
                                child: Padding(
                                  padding: padding,
                                  child: child,
                                ),
                              ),
                            ),
                          )),
                      //對方時間&已讀
                      Offstage(
                        offstage: message.isMine,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 5),
                          child: Column(
                            children: [
                              /*Offstage(
                                offstage: message.isRead == 0,
                                child: const Text(
                                  '已讀',
                                  style: TextStyle(
                                      color: AppColor.textFieldTitle,
                                      fontSize: 14),
                                ),
                              ),*/
                              Text(
                                Utils.sqlTimeToHHAndMM(message.createdAt),
                                style: const TextStyle(
                                    color: AppColor.textFieldTitle,
                                    fontSize: 14),
                              )
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            )),
      ],
    );
  }
}
