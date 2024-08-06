import 'package:ashera_pet_new/utils/app_color.dart';
import 'package:ashera_pet_new/view_model/kanban.dart';
import 'package:bootstrap_icons/bootstrap_icons.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../utils/utils.dart';

class PetMagazineContentTitle extends StatelessWidget {
  final int petId;
  final String petNickname;
  const PetMagazineContentTitle(
      {super.key, required this.petId, required this.petNickname});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
      height: Utils.appBarHeight,
      alignment: Alignment.center,
      decoration: const BoxDecoration(
        color: AppColor.textFieldUnSelect,
      ),
      child: Row(
        children: [
          Expanded(
              child: Row(
            children: [
              GestureDetector(
                onTap: () {
                  if (context.canPop()) {
                    context.pop();
                  }
                },
                child: Container(
                  padding: const EdgeInsets.only(left: 10),
                  child: const Icon(
                    Icons.arrow_back,
                    size: 30,
                  ),
                ),
              ),
              Expanded(child: Container())
            ],
          )),
          Text(
            petNickname,
            style: const TextStyle(
                color: AppColor.textFieldTitle, fontSize: 22, height: 1.1),
          ),
          Expanded(
              child: Row(
            mainAxisSize: MainAxisSize.max,
            children: [
              const SizedBox(
                width: 10,
              ),
              const Icon(
                BootstrapIcons.heart_fill,
                color: Colors.redAccent,
                size: 15,
              ),
              const SizedBox(
                width: 5,
              ),
              Consumer<KanBanVm>(
                builder: (context, vm, _) {
                  return Text(
                    '${vm.count(petId)}',
                    style: const TextStyle(
                        color: AppColor.textFieldTitle,
                        fontSize: 14,
                        height: 1.1),
                  );
                },
              ),
              const Spacer(),
            ],
          ))
        ],
      ),
    );
  }
}
