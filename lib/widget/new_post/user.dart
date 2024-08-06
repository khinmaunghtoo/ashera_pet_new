import 'package:ashera_pet_new/data/member.dart';
import 'package:ashera_pet_new/view_model/post.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svprogresshud/flutter_svprogresshud.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../dialog/cupertion_alert.dart';
import '../../enum/post_setting.dart';
import '../../model/member.dart';
import '../../routes/route_name.dart';
import '../../utils/app_color.dart';
import '../time_line/app_widget/avatars.dart';
import '../time_line/app_widget/tap_fade_icon.dart';

//動態發布 頭像與名稱
class PostUserWidget extends StatefulWidget {
  final MemberModel userData;
  final bool isSetting;
  final int? postId;
  const PostUserWidget(
      {super.key,
      required this.userData,
      required this.isSetting,
      this.postId});

  @override
  State<StatefulWidget> createState() => _PostUserWidgetState();
}

class _PostUserWidgetState extends State<PostUserWidget> {
  MemberModel get userData => widget.userData;
  bool get isSetting => widget.isSetting;
  int? get postId => widget.postId;
  PostVm? _postVm;

  @override
  Widget build(BuildContext context) {
    _postVm = Provider.of<PostVm>(context, listen: false);
    return Row(
      mainAxisSize: MainAxisSize.max,
      children: [
        //頭像
        Avatar.medium(
            user: userData,
            callback: () async {
              if (!isSetting) {
                return;
              }
              if (userData.id == Member.memberModel.id) {
                await context.push(RouteName.searchMe);
              } else {
                await context.push(RouteName.searchPet, extra: userData);
              }
            }),
        //名稱
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Text(
            userData.nickname,
            style: const TextStyle(
                color: AppColor.textFieldTitle,
                fontWeight: FontWeight.w300,
                fontSize: 15),
          ),
        ),
        const Spacer(),
        if (userData.id == Member.memberModel.id && isSetting)
          TapFadeIcon(
              onTap: () => _showChooseAction(),
              icon: Icons.more_horiz,
              iconColor: AppColor.textFieldTitle)
      ],
    );
  }

  //選擇動作
  Future<void> _showChooseAction() async {
    PostSetting? value = await showCupertinoModalPopup(
        context: context,
        builder: (context) {
          return CupertinoActionSheet(
            actions: [
              CupertinoActionSheetAction(
                  isDestructiveAction: true,
                  onPressed: () => Navigator.pop(context, PostSetting.edit),
                  child: Text(PostSetting.edit.zh)),
              CupertinoActionSheetAction(
                  isDestructiveAction: true,
                  onPressed: () => Navigator.pop(context, PostSetting.delete),
                  child: Text(PostSetting.delete.zh)),
            ],
            cancelButton: CupertinoActionSheetAction(
              onPressed: () => Navigator.pop(context, PostSetting.cancel),
              isDefaultAction: true,
              child: Text(PostSetting.cancel.zh),
            ),
          );
        });
    if (value != null) {
      switch (value) {
        case PostSetting.edit:
          if (mounted)
            context.push(RouteName.editPost,
                extra: _postVm!.mePostData
                    .firstWhere((element) => element.id == postId));
          break;
        case PostSetting.delete:
          await _showDeleteAction();
          break;
        default:
          break;
      }
    }
  }

  //刪除貼文
  Future<void> _showDeleteAction() async {
    bool? r = await showCupertinoAlert(
        context: context,
        title: '刪除貼文',
        content: '確定要刪除此貼文嗎？',
        confirmation: true,
        cancel: true);
    if (r) {
      //確定刪除
      if (postId == null) {
        return;
      }
      SVProgressHUD.show();
      bool r = await _postVm!.deletePost(postId);
      if (r) {
        SVProgressHUD.showSuccess(status: '此貼文已刪除');
        if (context.canPop()) {
          if (mounted) context.pop();
        }
      } else {
        SVProgressHUD.showError(status: '');
      }
    }
  }
}
