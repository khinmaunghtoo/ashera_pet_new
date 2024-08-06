import 'package:ashera_pet_new/data/member.dart';
import 'package:ashera_pet_new/model/follower.dart';
import 'package:ashera_pet_new/routes/route_name.dart';
import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../model/notify.dart';
import '../../utils/app_color.dart';
import '../../utils/utils.dart';
import '../../view_model/follower.dart';
import '../time_line/app_widget/avatars.dart';

//追蹤
class NotifyCardFollow extends StatefulWidget {
  final NotifyModel model;
  const NotifyCardFollow({super.key, required this.model});

  @override
  State<StatefulWidget> createState() => _NotifyCardFollowState();
}

class _NotifyCardFollowState extends State<NotifyCardFollow> {
  NotifyModel get model => widget.model;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      child: Row(
        children: [
          //大頭照
          Avatar.medium(
            user: model.fromMember,
            callback: () {
              context.push(RouteName.searchPet, extra: model.fromMember);
            },
          ),
          //內容
          Expanded(
              child: Container(
            padding: const EdgeInsets.only(left: 10),
            child: Text.rich(TextSpan(children: [
              TextSpan(
                  text: model.message,
                  style: const TextStyle(
                      color: AppColor.textFieldTitle, fontSize: 14)),
              /*const TextSpan(
                              text: '開始追蹤你。',
                              style: TextStyle(
                                  color: AppColor.textFieldTitle,
                                  fontSize: 14
                              )
                          ),*/
              TextSpan(
                  text: '\n ${Utils.getPostTime(model.createdAt)}',
                  style: const TextStyle(
                      color: AppColor.textFieldHintText, fontSize: 14))
            ])),
          )),
          //按鈕
          if (!model.message.contains('開始追蹤你'))
            GestureDetector(
              child: SizedBox(
                width: 75,
                height: 25,
                child: _follow(),
              ),
            )
        ],
      ),
    );
  }

  Widget _follow() {
    return Consumer<FollowerVm>(
      builder: (context, vm, _) {
        return GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () {
            if (vm.followerMeList
                .where((element) =>
                    element.memberId == model.fromMemberId &&
                    element.acceptTime != 0)
                .isEmpty) {
              /*AddFollowerRequestDTO dto = AddFollowerRequestDTO(
                followerId: model.fromMemberId,
                memberId: Member.memberModel.id);
            vm.sendFollowerRequest(dto);*/
              AcceptFollowerRequestDTO dto = AcceptFollowerRequestDTO(
                  followerId: Member.memberModel.id,
                  memberId: model.fromMemberId,
                  approve: true);
              vm.sendFollowerRequestAccept(dto);
            }
          },
          child: Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.symmetric(vertical: 5),
            decoration: BoxDecoration(
                color: AppColor.button, borderRadius: BorderRadius.circular(7)),
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                vm.followerMeList
                        .where((element) =>
                            element.memberId == model.fromMemberId &&
                            element.acceptTime != 0)
                        .isEmpty
                    ? '同意'
                    : '已同意',
                style: const TextStyle(
                    color: AppColor.textFieldTitle, fontSize: 11, height: 1.1),
              ),
            ),
          ),
        );
      },
    );
  }
}
