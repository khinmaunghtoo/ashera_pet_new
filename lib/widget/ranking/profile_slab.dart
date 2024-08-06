import 'dart:developer';

import 'package:ashera_pet_new/routes/route_name.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svprogresshud/flutter_svprogresshud.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../data/member.dart';
import '../../dialog/alert.dart';
import '../../enum/post_setting.dart';
import '../../enum/ranking_list_type.dart';
import '../../model/complaint.dart';
import '../../model/complaint_record.dart';
import '../../model/ranking_message.dart';
import '../../utils/app_color.dart';
import '../../utils/app_image.dart';
import '../../utils/utils.dart';
import '../../view_model/complaint_record.dart';
import '../time_line/app_widget/avatars.dart';
import '../time_line/app_widget/tap_fade_icon.dart';

///黃冠 貼文者 頭像 名稱 ...
class RankProfileSlab extends StatefulWidget {
  final RankingMessageModel userData;
  final int number;
  final dynamic model;

  const RankProfileSlab(
      {super.key,
      required this.userData,
      required this.number,
      required this.model});

  @override
  State<StatefulWidget> createState() => _RankProfileSlabState();
}

class _RankProfileSlabState extends State<RankProfileSlab> {
  ComplaintRecordVm? _complaintRecordVm;
  int get number => widget.number;
  RankingMessageModel get userData => widget.userData;

  @override
  void initState() {
    super.initState();
    //log('進來的是什麼：${widget.model.toMap()}');
  }

  @override
  Widget build(BuildContext context) {
    _complaintRecordVm = Provider.of<ComplaintRecordVm>(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Row(
        children: [
          if (number < 3)
            Padding(
              padding: const EdgeInsets.only(right: 12),
              child: Text(
                (number + 1).toString().padLeft(2, '0'),
                style: TextStyle(color: _getNumberColor(number), fontSize: 16),
              ),
            ),
          SizedBox(
            height: 50,
            width: 70,
            child: Stack(
              alignment: Alignment.center,
              children: [
                Avatar.medium(
                    callback: () {
                      log('點擊：${userData.toMap()}');
                      if (userData.memberId == Member.memberModel.id) {
                        context.push(RouteName.searchMe);
                      } else {
                        context.push(RouteName.searchPet,
                            extra: userData.member);
                      }
                    },
                    user: userData.member!),
                if (number < 3)
                  Positioned(
                      top: 0,
                      left: 0,
                      child: Transform.rotate(
                        angle: 5.3,
                        child: Image(
                          width: 20,
                          image: AssetImage(_getNumberCrown(number)),
                        ),
                      )),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 0.0),
            child: Text(
              userData.member!.nickname,
              style: const TextStyle(
                  fontSize: 16,
                  color: AppColor.textFieldTitle,
                  fontWeight: FontWeight.w500),
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

  //皇冠
  String _getNumberCrown(int value) {
    switch (value) {
      case 0:
        return AppImage.rank1;
      case 1:
        return AppImage.rank2;
      case 2:
        return AppImage.rank3;
      default:
        return '';
    }
  }

  Color _getNumberColor(int value) {
    switch (value) {
      case 0:
        return AppColor.firstPlace;
      case 1:
        return AppColor.secondPlace;
      case 2:
        return AppColor.thirdPlace;
      default:
        return AppColor.textFieldTitle;
    }
  }

  //選擇動作
  Future<void> _showChooseAction() async {
    //如果是自己
    if (userData.memberId == Member.memberModel.id) {
      return;
    }
    PostSetting value = await showCupertinoModalPopup(
        context: context,
        builder: (context) {
          return CupertinoActionSheet(
            actions: [
              CupertinoActionSheetAction(
                  isDestructiveAction: true,
                  onPressed: () => Navigator.pop(context, PostSetting.report),
                  child: const Text('檢舉')),
            ],
            cancelButton: CupertinoActionSheetAction(
              onPressed: () => Navigator.pop(context, PostSetting.cancel),
              isDefaultAction: true,
              child: const Text('取消'),
            ),
          );
        });
    switch (value) {
      case PostSetting.report:
        await _showReportAction();
        break;
      case PostSetting.cancel:
        break;
      default:
        break;
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
          dataId: userData.postId,
          fromMemberId: Member.memberModel.id,
          targetMemberId: userData.memberId,
          targetMember: userData.member!.name,
          type: RankingListType.POST,
          pic: widget.model.pics,
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
}
