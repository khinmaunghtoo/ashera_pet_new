import 'package:ashera_pet_new/utils/app_color.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../model/member.dart';
import '../../../../utils/ws.dart';
import '../../../../widget/search_pet/body.dart';
import '../../../../widget/search_pet/title.dart';

class SearchPetPage extends StatefulWidget {
  final MemberModel userData;
  const SearchPetPage({super.key, required this.userData});

  @override
  State<StatefulWidget> createState() => _SearchPetPageState();
}

class _SearchPetPageState extends State<SearchPetPage> {
  MemberModel get userData => widget.userData;

  @override
  void initState() {
    super.initState();
    //取用戶是否是警示用戶
    Ws.stompClient
        .send(destination: Ws.isTargetMemberWarning, body: '${userData.id}');
  }

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
                SearchPetTitle(
                  callback: _back,
                  text: userData.nickname,
                ),
                //body
                Expanded(
                    child: SearchPetBody(
                  userData: userData,
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
}
