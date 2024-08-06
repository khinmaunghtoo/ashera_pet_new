import 'package:ashera_pet_new/data/pet.dart';
import 'package:ashera_pet_new/db/app_db.dart';
import 'package:ashera_pet_new/enum/menu.dart';
import 'package:ashera_pet_new/utils/shared_preference.dart';
import 'package:ashera_pet_new/view_model/bottom_drawer.dart';
import 'package:ashera_pet_new/view_model/member.dart';
import 'package:ashera_pet_new/widget/bottom_drawer/button_drawer.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../data/last_msg.dart';
import '../../dialog/cupertion_alert.dart';
import '../../routes/route_name.dart';
import '../../utils/app_color.dart';
import '../../utils/utils.dart';

class MenuDrawer extends StatefulWidget {
  const MenuDrawer({super.key});

  @override
  State<StatefulWidget> createState() => _MenuDrawerState();
}

class _MenuDrawerState extends State<MenuDrawer> {
  MemberVm? _memberVm;
  final double _headerHeight = 0.0;

  @override
  Widget build(BuildContext context) {
    _memberVm = Provider.of<MemberVm>(context);
    return LayoutBuilder(builder: (context, constraints) {
      return Consumer<BottomDrawerVm>(builder: (context, vm, _) {
        return BottomDrawer(
          header: GestureDetector(
            onTap: vm.close,
            behavior: HitTestBehavior.translucent,
            child: Container(
              width: constraints.maxWidth,
              height: 35,
              alignment: Alignment.center,
              child: Container(
                width: 40,
                height: 5,
                margin: const EdgeInsets.only(top: 20, bottom: 10),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    color: AppColor.textFieldUnSelectBorder.withOpacity(0.8),
                    borderRadius: BorderRadius.circular(10)),
              ),
            ),
          ),
          body: Column(
            children: MenuEnum.values.map((e) => _itemButton(e)).toList(),
          ),
          headerHeight: _headerHeight,
          drawerHeight: (constraints.maxHeight / 1.45) -
              MediaQuery.of(context).padding.top,
          controller: vm.controller,
          color: AppColor.textFieldUnSelect,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.15),
              blurRadius: 60,
              spreadRadius: 5,
              offset: const Offset(2, -6), // changes position of shadow
            ),
          ],
        );
      });
    });
  }

  Widget _itemButton(MenuEnum item) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => _onTap(item),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 40),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(
              item.icon,
              size: 25,
              color: AppColor.textFieldTitle,
            ),
            Expanded(
                child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              alignment: Alignment.centerLeft,
              child: Text(
                item.zh,
                style: const TextStyle(
                    fontSize: 16, color: AppColor.textFieldTitle, height: 1.1),
              ),
            ))
          ],
        ),
      ),
    );
  }

  void _onTap(MenuEnum item) async {
    switch (item) {
      //
      //case MenuEnum.identificationRecord:
      //  context.push(RouteName.identificationRecord);
      //  break;
      case MenuEnum.editUserProfile:
        context.push(RouteName.editUserProfile);
        break;
      case MenuEnum.changePassword:
        context.push(RouteName.changePassword);
        break;
      case MenuEnum.blockList:
        context.push(RouteName.blockList);
        break;
      case MenuEnum.report:
        context.push(RouteName.adoptRecord);
        break;
      case MenuEnum.aboutAsheraPet:
        context.push(RouteName.aboutUs);
        break;
      case MenuEnum.commentsAndFeedback:
        context.push(RouteName.commentsAndFeedback);
        break;
      //登出
      case MenuEnum.signOut:
        bool r = await showCupertinoAlert(
          title: '登出',
          content: '確定要登出帳號嗎？',
          context: context,
          cancel: true,
          confirmation: true,
        );
        if (r) {
          LastMsg.lastMsgList.clear();
          Utils.clearAndPutToken();
          Pet.petModel.clear();
          AppDB.delete(AppDB.msgTable);
          AppDB.delete(AppDB.searchTable);
          SharedPreferenceUtil.removeMember();
          if (mounted) context.pushReplacement(RouteName.login);
        }
        break;
      case MenuEnum.logOut:
        //提示
        bool r = await showCupertinoAlert(
          title: '註銷',
          content: '確定要刪除帳號嗎？',
          context: context,
          cancel: true,
          confirmation: true,
        );
        if (r) {
          //刪除帳號
          await _memberVm!.deleteMember();
          Pet.petModel.clear();
          AppDB.delete(AppDB.msgTable);
          AppDB.delete(AppDB.searchTable);
          AppDB.delete(AppDB.messageRoomTable);
          AppDB.delete(AppDB.allPet);
          SharedPreferenceUtil.removeMember();
          if (mounted) context.pushReplacement(RouteName.login);
        }
        break;
    }
  }
}
