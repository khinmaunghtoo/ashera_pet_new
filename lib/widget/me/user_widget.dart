import 'package:ashera_pet_new/data/member.dart';
import 'package:ashera_pet_new/model/hero_view_params.dart';
import 'package:ashera_pet_new/routes/route_name.dart';
import 'package:ashera_pet_new/utils/app_color.dart';
import 'package:ashera_pet_new/view_model/member.dart';
import 'package:ashera_pet_new/widget/time_line/app_widget/avatars.dart';
import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../button.dart';

//個人頁 頭像與名稱
class UserWidget extends StatelessWidget {
  final VoidCallback? adoptReport;
  final VoidCallback? callback;

  const UserWidget(
      {super.key, required this.adoptReport, required this.callback});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      children: [
        Consumer<MemberVm>(
          builder: (context, vm, _) {
            return Stack(
              alignment: Alignment.center,
              children: [
                Avatar.big(
                    callback: () {
                      if (Member.memberModel.mugshot.isNotEmpty) {
                        context.push(RouteName.netWorkImageHeroView,
                            extra: HeroViewParamsModel(
                                tag: 'Avatar_${Member.memberModel.id}',
                                data: Member.memberModel.mugshot,
                                index: 0));
                      }
                    },
                    user: Member.memberModel),
                if (callback != null)
                  Positioned(
                      right: 4,
                      bottom: 0,
                      child: blueAddButton(23, callback ?? () {})),
                if (vm.targetMemberWarnings
                    .where((e) =>
                        e.targetMemberId == Member.memberModel.id &&
                        e.warning == true)
                    .isNotEmpty)
                  Positioned(
                      left: 4,
                      top: 0,
                      child: yellowButton(23, adoptReport ?? () {})),
              ],
            );
          },
        ),
        Container(
          padding: const EdgeInsets.symmetric(vertical: 5),
          child: Consumer<MemberVm>(
            builder: (context, vm, _) {
              return Text(
                Member.memberModel.nickname,
                style: const TextStyle(
                    color: AppColor.textFieldTitle,
                    fontWeight: FontWeight.w600,
                    fontSize: 15),
              );
            },
          ),
        )
      ],
    );
  }
}
