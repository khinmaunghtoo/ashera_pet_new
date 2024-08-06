import 'package:ashera_pet_new/enum/tab_bar.dart';
import 'package:ashera_pet_new/model/follower.dart';
import 'package:ashera_pet_new/routes/route_name.dart';
import 'package:ashera_pet_new/view_model/follower.dart';
import 'package:ashera_pet_new/widget/me/user_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../data/member.dart';
import '../../model/member.dart';
import '../../utils/ws.dart';
import '../../view_model/post.dart';
import '../number_new_line_text.dart';

class UserAndPostFollow extends StatelessWidget {
  final MemberModel userData;
  final VoidCallback callback;
  const UserAndPostFollow(
      {super.key, required this.userData, required this.callback});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        //會員 頭貼與名稱
        Flexible(
            child: UserWidget(
          adoptReport: () => context.push(RouteName.adoptRecord),
          callback: () => context.push(RouteName.editUserProfile),
        )),
        //貼文數
        Flexible(
            child: Selector<PostVm, FriendDataCntDTO>(
          selector: (context, data) => data.friendDataCnt,
          shouldRebuild: (pre, next) => pre != next,
          builder: (context, dto, _) {
            return NumberNewLineText(number: dto.postCnt, text: '貼文');
          },
        )),
        //粉絲
        Flexible(
            child: Selector<FollowerVm, List<FollowerRequestModel>>(
          selector: (context, data) => data.followerMeList,
          shouldRebuild: (pre, next) => pre != next,
          builder: (context, list, _) {
            return GestureDetector(
              onTap: () async {
                if (list.isNotEmpty) {
                  await context.push(RouteName.follower,
                      extra: FollowerTabBarEnum.followerMe);
                  Ws.stompClient.send(
                      destination: Ws.updateFollowerRequestIsReadByFollowerId,
                      body: '${Member.memberModel.id}');
                }
              },
              child: NumberNewLineText(
                number: list.length,
                text: '粉絲',
                isRead: list.isNotEmpty &&
                    list.where((e) => e.read == false).isNotEmpty,
              ),
            );
          },
        )),
        //追蹤中
        Flexible(
            child: Selector<FollowerVm, List<FollowerRequestModel>>(
          selector: (context, data) => data.myFollowerList,
          shouldRebuild: (pre, next) => pre != next,
          builder: (context, list, _) {
            return GestureDetector(
              onTap: () async {
                if (list.isNotEmpty) {
                  await context.push(RouteName.follower,
                      extra: FollowerTabBarEnum.myFollower);
                  Ws.stompClient.send(
                      destination: Ws.updateFollowerRequestIsReadByFollowerId,
                      body: '${Member.memberModel.id}');
                }
              },
              child: NumberNewLineText(number: list.length, text: '追蹤中'),
            );
          },
        ))
      ],
    );
  }
}
