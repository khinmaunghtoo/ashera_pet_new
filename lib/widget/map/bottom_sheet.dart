import 'package:ashera_pet_new/model/member.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../enum/health_status.dart';
import '../../model/member_pet.dart';
import '../../routes/route_name.dart';
import '../../utils/app_color.dart';
import '../time_line/app_widget/avatars.dart';

class PetBottomSheet extends StatefulWidget {
  final ScrollController controller;
  final List<MemberPetModel> pets;
  const PetBottomSheet(
      {super.key, required this.controller, required this.pets});

  @override
  State<StatefulWidget> createState() => _PetBottomSheetState();
}

class _PetBottomSheetState extends State<PetBottomSheet> {
  List<MemberPetModel> get pets => widget.pets;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height - 100,
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: ListView.separated(
          padding: EdgeInsets.zero,
          controller: widget.controller,
          itemBuilder: (context, index) => _itemWidget(pets[index]),
          separatorBuilder: (context, index) => _separatorWidget(),
          itemCount: pets.length),
    );
  }

  Widget _itemWidget(MemberPetModel data) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () => context.push(RouteName.petMagazineContent, extra: data),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
        child: Row(
          children: [
            Avatar.medium(user: MemberModel.fromMap(data.toMap())),
            const SizedBox(
              width: 10,
            ),
            Text(
              data.nickname,
              style:
                  const TextStyle(color: AppColor.textFieldTitle, fontSize: 14),
            ),
            Expanded(child: Container()),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                  color: HealthStatus.values[data.healthStatus].color,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                      color: HealthStatus.values[data.healthStatus].color,
                      width: 1)),
              child: Text(
                HealthStatus.values[data.healthStatus].zh,
                style: const TextStyle(
                    fontSize: 14,
                    color: Colors
                        .white /*HealthStatus.values[data.healthStatus].color*/
                    ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _separatorWidget() {
    return Container(
      height: 1,
      decoration: const BoxDecoration(color: Colors.black),
    );
  }
}
