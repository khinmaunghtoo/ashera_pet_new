import 'dart:developer';

import 'package:ashera_pet_new/enum/ranking_list_type.dart';
import 'package:ashera_pet_new/model/complaint.dart';
import 'package:ashera_pet_new/model/complaint_record.dart';
import 'package:ashera_pet_new/model/post.dart';
import 'package:ashera_pet_new/view_model/post.dart';
import 'package:cached_video_player_plus/cached_video_player_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svprogresshud/flutter_svprogresshud.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../data/member.dart';
import '../../dialog/alert.dart';
import '../../dialog/cupertion_alert.dart';
import '../../enum/post_setting.dart';
import '../../model/member.dart';
import '../../routes/route_name.dart';
import '../../utils/app_color.dart';
import '../../utils/utils.dart';
import '../../view_model/complaint_record.dart';
import '../time_line/app_widget/avatars.dart';
import '../time_line/app_widget/tap_fade_icon.dart';

///貼文者 頭像 名稱 ...
class ProfileSlab extends StatefulWidget {
  final PostModel userData;
  final Color textColor;
  final CachedVideoPlayerPlusController? controller;
  const ProfileSlab(
      {super.key,
      required this.userData,
      this.textColor = AppColor.textFieldTitle,
      this.controller});

  @override
  State<StatefulWidget> createState() => _ProfileSlabState();
}

class _ProfileSlabState extends State<ProfileSlab>
    with AutomaticKeepAliveClientMixin {
  ComplaintRecordVm? _complaintRecordVm;
  PostVm? _postVm;
  PostModel get userData => widget.userData;
  Color get textColor => widget.textColor;
  CachedVideoPlayerPlusController? get controller => widget.controller;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    _complaintRecordVm = Provider.of<ComplaintRecordVm>(context, listen: false);
    _postVm = Provider.of<PostVm>(context, listen: false);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Row(
        children: [
          Avatar.medium(
              callback: () async {
                log('點擊：${userData.toMap()}');
                if (userData.member!.id == Member.memberModel.id) {
                  controller?.pause();
                  await context.push(RouteName.searchMe);
                  controller?.play();
                } else {
                  controller?.pause();
                  //double pixels = 0;
                  //if(_postVm!.controller != null){
                  //  pixels = _postVm!.controller!.position.pixels;
                  //}

                  await context.push(RouteName.searchPet,
                      extra: userData.member!);
                  _postVm!.justRefresh();
                  await Future.delayed(const Duration(milliseconds: 300));
                  //if(_postVm!.controller != null){
                  //  _postVm!.controller!.position.jumpTo(pixels);
                  //}
                  _postVm!.jumpToPixels();
                  if (controller != null) {
                    controller?.play();
                  }
                }
              },
              user: MemberModel.fromMap(userData.member!.toMap())),
          Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: Text(
              userData.member!.nickname,
              style: TextStyle(
                  fontSize: 16, color: textColor, fontWeight: FontWeight.w500),
            ),
          ),
          //性別icon
          Utils.genderIcon(userData.member!.gender),
          const Spacer(),
          TapFadeIcon(
              onTap: () => _showChooseAction(),
              icon: Icons.more_horiz,
              iconColor: AppColor.textFieldTitle)
        ],
      ),
    );
  }

  //選擇動作
  Future<void> _showChooseAction() async {
    PostSetting? value = await showCupertinoModalPopup(
        context: context,
        builder: (context) {
          return CupertinoActionSheet(
            actions: [
              if (userData.memberId == Member.memberModel.id)
                CupertinoActionSheetAction(
                    isDestructiveAction: true,
                    onPressed: () => Navigator.pop(context, PostSetting.edit),
                    child: Text(PostSetting.edit.zh)),
              if (userData.memberId == Member.memberModel.id)
                CupertinoActionSheetAction(
                    isDestructiveAction: true,
                    onPressed: () => Navigator.pop(context, PostSetting.delete),
                    child: Text(PostSetting.delete.zh)),
              if (userData.memberId != Member.memberModel.id)
                CupertinoActionSheetAction(
                    isDestructiveAction: true,
                    onPressed: () => Navigator.pop(context, PostSetting.report),
                    child: Text(PostSetting.report.zh)),
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
          if (mounted) context.push(RouteName.editPost, extra: userData);
          break;
        case PostSetting.delete:
          await _showDeleteAction();
          break;
        case PostSetting.report:
          await _showReportAction();
          break;
        case PostSetting.cancel:
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
      SVProgressHUD.show();
      bool r = await _postVm!.deletePost(userData.id);
      if (r) {
        SVProgressHUD.showSuccess(status: '此貼文已刪除');
      } else {
        SVProgressHUD.showError(status: '');
      }
    }
  }

  //檢舉
  Future<void> _showReportAction() async {
    /*String? value = await showCupertinoModalPopup(
        context: context,
        builder: (context) {
          return Consumer<ComplaintRecordVm>(builder: (context, vm, _){
            return CupertinoActionSheet(
              title: const Text('檢舉'),
              message: const Text('你為何要檢舉這則貼文？'),
              actions: vm.reasonList.where((e) => e.type == RankingListType.POST).map((e) => _item(e, context)).toList(),
              cancelButton: CupertinoActionSheetAction(
                onPressed: () => Navigator.pop(context),
                isDefaultAction: true,
                child: const Text('取消'),
              ),
            );
          },);
        });*/
    String? value = await showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (context) {
          return Consumer<ComplaintRecordVm>(
            builder: (context, vm, _) {
              return SizedBox(
                height: 200.0 +
                    (60 *
                        vm.reasonList
                            .where((e) => e.type == RankingListType.POST)
                            .length),
                child: Column(
                  children: [
                    Text.rich(
                        textAlign: TextAlign.center,
                        TextSpan(
                            text: '檢舉\n',
                            style: TextStyle(color: Colors.grey[500]),
                            children: const [TextSpan(text: '你為何要檢舉這則貼文？')])),
                    const Divider(),
                    ...vm.reasonList
                        .where((e) => e.type == RankingListType.POST)
                        .map((e) => _item(e)),
                    ListTile(
                      title: const Text(
                        '取消',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.red),
                      ),
                      onTap: () => Navigator.pop(context),
                    )
                  ],
                ),
              );
            },
          );
        });
    if (value != null) {
      SVProgressHUD.show();
      ComplaintRecordModel dto = ComplaintRecordModel(
          dataId: userData.id,
          fromMemberId: Member.memberModel.id,
          targetMemberId: userData.memberId,
          targetMember: userData.member!.name,
          type: RankingListType.POST,
          pic: userData.pics,
          reason: value);
      bool r = await _complaintRecordVm!.addComplaintRecord(dto);
      SVProgressHUD.dismiss();
      if (r) {
        //SVProgressHUD.showSuccess(status: '送出成功');
        Alert.showComplaintSuccessAlert(context);
      } else {
        SVProgressHUD.showError(status: '');
      }
    }
  }

  /*Widget _item(ComplaintModel e, context){
    return CupertinoActionSheetAction(
        isDestructiveAction: false,
        onPressed: () => Navigator.pop(context, e.reason),
        child: Text(e.reason));
  }*/

  Widget _item(ComplaintModel e) {
    return GestureDetector(
      onTap: () => Navigator.pop(context, e.reason),
      child: Column(
        children: [ListTile(title: Text(e.reason)), const Divider()],
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
