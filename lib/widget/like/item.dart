import 'package:ashera_pet_new/utils/api.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../data/member.dart';
import '../../model/follower.dart';
import '../../model/member.dart';
import '../../model/member_pet.dart';
import '../../model/member_pet_like.dart';
import '../../model/tuple.dart';
import '../../routes/route_name.dart';
import '../../utils/app_color.dart';
import '../../utils/utils.dart';
import '../../view_model/follower.dart';
import '../time_line/app_widget/avatars.dart';

class LikeItem extends StatefulWidget {
  final MemberPetLikeModel model;
  final bool isBeLike;
  const LikeItem({super.key, required this.model, required this.isBeLike});

  @override
  State<StatefulWidget> createState() => _LikeItemState();
}

class _LikeItemState extends State<LikeItem>
    with AutomaticKeepAliveClientMixin {
  MemberPetLikeModel get model => widget.model;
  bool get isBeLike => widget.isBeLike;
  late Future<MemberModel> _pet;
  late Future<MemberPetModel> _pets;

  @override
  void initState() {
    super.initState();
    _pet = _getPetModel();
    _pets = _getPetsModel();
  }

  Future<MemberModel> _getPetModel() async {
    Tuple<bool, String> r;
    if (isBeLike) {
      r = await Api.getMemberData(model.memberId);
    } else {
      r = await Api.getMemberData(model.petMemberId);
    }
    return MemberModel.fromJson(r.i2!);
  }

  Future<MemberPetModel> _getPetsModel() async {
    Tuple<bool, String> r = await Api.getPet(model.memberPetId);
    return MemberPetModel.fromJson(r.i2!);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return FutureBuilder(
        future: _pet,
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.done:
              return GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () =>
                    context.push(RouteName.searchPet, extra: snapshot.data!),
                child: Container(
                  margin:
                      const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
                  padding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                  decoration: BoxDecoration(
                      color: AppColor.textFieldUnSelect,
                      borderRadius: BorderRadius.circular(10)),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Avatar.medium(user: snapshot.data!),
                      const SizedBox(
                        width: 10,
                      ),
                      Container(
                        padding: const EdgeInsets.only(top: 5),
                        child: Text(
                          snapshot.data!.nickname,
                          style: const TextStyle(
                              color: AppColor.textFieldTitle, fontSize: 16),
                        ),
                      ),
                      Expanded(child: Container()),
                      Container(
                        padding: const EdgeInsets.symmetric(vertical: 5),
                        child: Column(
                          children: [
                            //按鈕
                            GestureDetector(
                              child: SizedBox(
                                width: 75,
                                height: 25,
                                child: _follow(snapshot.data!),
                              ),
                            ),
                            const SizedBox(
                              height: 8,
                            ),
                            //日期
                            Container(
                              alignment: Alignment.center,
                              child: Text(
                                Utils.loveContentDate(model.likeAt),
                                style: const TextStyle(
                                    color: AppColor.loveContentDateColor,
                                    fontSize: 10),
                              ),
                            ),
                          ],
                        ),
                      ),
                      FutureBuilder(
                          future: _pets,
                          builder: (context, snapshot) {
                            switch (snapshot.connectionState) {
                              case ConnectionState.done:
                                return Container(
                                  margin: const EdgeInsets.only(
                                      top: 10, bottom: 10, left: 10),
                                  alignment: Alignment.center,
                                  child: Avatar.small(
                                      user: MemberModel.fromMap(
                                          snapshot.data!.toMap())),
                                );
                              default:
                                return Container();
                            }
                          })
                    ],
                  ),
                ),
              );
            default:
              return _loadingWidget();
          }
        });
  }

  Widget _loadingWidget() {
    return Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: const CircularProgressIndicator(),
    );
  }

  @override
  bool get wantKeepAlive => true;

  Widget _follow(MemberModel model) {
    return Consumer<FollowerVm>(
      builder: (context, vm, _) {
        return GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () {
            if (vm.myFollowerList
                .where((element) => element.followerId == model.id)
                .isEmpty) {
              AddFollowerRequestDTO dto = AddFollowerRequestDTO(
                  followerId: model.id, memberId: Member.memberModel.id);
              vm.sendFollowerRequest(dto);
            }
          },
          child: Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.symmetric(vertical: 5),
            decoration: BoxDecoration(
                color: trackingOrNot(vm, model)
                    ? AppColor.button
                    : AppColor.textFieldUnSelect,
                borderRadius: BorderRadius.circular(7),
                border: Border.all(
                    color: trackingOrNot(vm, model)
                        ? Colors.transparent
                        : AppColor.textFieldTitle,
                    width: 1)),
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                trackingOrNot(vm, model) ? '追蹤' : '已追蹤',
                style: const TextStyle(
                    color: AppColor.textFieldTitle, fontSize: 11, height: 1.1),
              ),
            ),
          ),
        );
      },
    );
  }

  //是否追蹤
  bool trackingOrNot(FollowerVm vm, MemberModel model) {
    return vm.myFollowerList
        .where((element) => element.followerId == model.id)
        .isEmpty;
  }
}
