import 'package:ashera_pet_new/model/notify.dart';
import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';

import '../../model/member.dart';
import '../../routes/route_name.dart';
import '../../utils/app_color.dart';
import '../time_line/app_widget/avatars.dart';

class NotifyCardAdopt extends StatefulWidget {
  final NotifyModel model;
  const NotifyCardAdopt({super.key, required this.model});

  @override
  State<StatefulWidget> createState() => _NotifyCardAdoptState();
}

class _NotifyCardAdoptState extends State<NotifyCardAdopt> {
  NotifyModel get model => widget.model;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      child: Row(
        children: [
          //大頭照
          Avatar.medium(
            user: const MemberModel(
              id: 0,
              name: '',
              nickname: '',
              birthday: '',
              aboutMe: '',
              age: 0,
              cellphone: '',
              gender: 0,
              mugshot: '',
            ),
            callback: () {
              context.push(RouteName.adoptRecord);
            },
          ),
          //內容
          Expanded(
              child: GestureDetector(
            onTap: () => context.push(RouteName.adoptRecord),
            child: Container(
              padding: const EdgeInsets.only(left: 10),
              child: Text.rich(TextSpan(children: [
                TextSpan(
                    text: model.message,
                    style: const TextStyle(
                        color: AppColor.textFieldTitle, fontSize: 14)),
              ])),
            ),
          )),
        ],
      ),
    );
  }
}
