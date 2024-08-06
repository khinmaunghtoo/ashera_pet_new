import 'package:ashera_pet_new/utils/app_color.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../routes/route_name.dart';
import '../../../../widget/me/body.dart';
import '../../../../widget/search_me/title.dart';

class SearchMePage extends StatefulWidget {
  const SearchMePage({super.key});

  @override
  State<StatefulWidget> createState() => _SearchMePageState();
}

class _SearchMePageState extends State<SearchMePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: AppColor.appBackground,
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SizedBox(
            height: constraints.maxHeight,
            width: constraints.maxWidth,
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                //title
                SearchMeTitle(
                  callback: _back,
                ),
                //body
                Expanded(
                    child: SettingsPageBody(
                  callback: _editProfile,
                ))
              ],
            ),
          );
        },
      ),
    );
  }

  //返回
  void _back() {
    context.pop();
  }

  //編輯個人資料
  void _editProfile() {
    context.push(RouteName.editPetProfile);
  }
}
