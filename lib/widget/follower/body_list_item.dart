import 'package:ashera_pet_new/utils/api.dart';
import 'package:ashera_pet_new/utils/app_color.dart';
import 'package:ashera_pet_new/widget/time_line/app_widget/avatars.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../model/member.dart';
import '../../model/tuple.dart';
import '../../routes/route_name.dart';

class BodyListItem extends StatefulWidget {
  final int targetId;
  const BodyListItem({super.key, required this.targetId});

  @override
  State<StatefulWidget> createState() => _BodyListItemState();
}

class _BodyListItemState extends State<BodyListItem> {
  int get targetId => widget.targetId;
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
                      Avatar.medium(user: snapshot.data!),
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
