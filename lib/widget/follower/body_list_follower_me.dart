import 'package:ashera_pet_new/utils/api.dart';
import 'package:ashera_pet_new/utils/app_color.dart';
import 'package:ashera_pet_new/widget/time_line/app_widget/avatars.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../model/follower.dart';
import '../../model/member.dart';
import '../../model/tuple.dart';
import '../../routes/route_name.dart';

class BodyListFollowerMeItem extends StatefulWidget {
  final FollowerRequestModel follower;
  const BodyListFollowerMeItem({super.key, required this.follower});

  @override
  State<StatefulWidget> createState() => _BodyListFollowerMeItemState();
}

class _BodyListFollowerMeItemState extends State<BodyListFollowerMeItem> {
  int get targetId => widget.follower.memberId;
  FollowerRequestModel get follower => widget.follower;
  late Future<MemberModel> _pet;

  @override
  void initState() {
    super.initState();
    _pet = _getPetModel();
  }

  Future<MemberModel> _getPetModel() async {
    Tuple<bool, String> r = await Api.getMemberData(targetId);
    return MemberModel.fromJson(r.i2!);
  }

  @override
  Widget build(BuildContext context) {
    if (ModalRoute.of(context)?.isCurrent ?? false) {
      _pet = _getPetModel();
    }
    return FutureBuilder(
        future: _pet,
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
              return _loadingWidget();
            case ConnectionState.waiting:
              return _loadingWidget();
            case ConnectionState.active:
              return _loadingWidget();
            case ConnectionState.done:
              return GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () =>
                    context.push(RouteName.searchPet, extra: snapshot.data!),
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 3, horizontal: 20),
                  child: Row(
                    children: [
                      Stack(
                        fit: StackFit.loose,
                        children: [
                          Avatar.medium(user: snapshot.data!),
                          Positioned(
                              right: 0,
                              top: 0,
                              child: Visibility(
                                  visible: !follower.read,
                                  child: Container(
                                    width: 10,
                                    height: 10,
                                    decoration: const BoxDecoration(
                                        color: Colors.red,
                                        shape: BoxShape.circle),
                                  )))
                        ],
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Text(
                        snapshot.data!.nickname,
                        style: const TextStyle(
                            color: AppColor.textFieldTitle, fontSize: 14),
                      )
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
}
