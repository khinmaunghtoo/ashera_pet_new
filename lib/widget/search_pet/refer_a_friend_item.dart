import 'package:ashera_pet_new/view_model/follower.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

import '../../data/member.dart';
import '../../model/follower.dart';
import '../../model/member.dart';
import '../../model/tuple.dart';
import '../../utils/api.dart';
import '../../utils/app_color.dart';
import '../button.dart';
import '../time_line/app_widget/avatars.dart';

class ReferAFriendItem extends StatefulWidget {
  final int memberId;
  const ReferAFriendItem({super.key, required this.memberId});

  @override
  State<StatefulWidget> createState() => _ReferAFriendItemState();
}

class _ReferAFriendItemState extends State<ReferAFriendItem>
    with AutomaticKeepAliveClientMixin {
  int get memberId => widget.memberId;

  late Future<MemberModel> _pet;

  Future<MemberModel> getPet(int memberPetId) async {
    Tuple<bool, String> r = await Api.getPet(memberPetId);
    return MemberModel.fromJson(r.i2!);
  }

  @override
  void initState() {
    super.initState();
    _pet = getPet(memberId);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return FutureBuilder(
        future: _pet,
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.done:
              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 5),
                padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 5),
                decoration: BoxDecoration(
                    color: AppColor.textFieldUnSelect,
                    borderRadius: BorderRadius.circular(10)),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    //頭像
                    Avatar.medium(user: snapshot.data!),
                    //暱稱
                    Text(
                      snapshot.data!.nickname,
                      style: const TextStyle(
                          color: AppColor.textFieldTitle, fontSize: 14),
                    ),
                    //追蹤
                    Container(
                      height: 30,
                      width: 90,
                      alignment: Alignment.center,
                      child: Consumer<FollowerVm>(
                        builder: (context, vm, _) {
                          return blueRectangleButton('追蹤', () {
                            AddFollowerRequestDTO dto = AddFollowerRequestDTO(
                                followerId: snapshot.data!.id,
                                memberId: Member.memberModel.id);
                            vm.sendFollowerRequest(dto);
                          }, 8);
                        },
                      ),
                    ),
                  ],
                ),
              );
            default:
              return Container();
          }
        });
  }

  @override
  bool get wantKeepAlive => true;
}
