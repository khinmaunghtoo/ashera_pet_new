import 'dart:developer';

import 'package:ashera_pet_new/data/member.dart';
import 'package:ashera_pet_new/dialog/alert.dart';
import 'package:ashera_pet_new/dialog/cupertion_alert.dart';
import 'package:ashera_pet_new/enum/chat_setting.dart';
import 'package:ashera_pet_new/enum/chat_type.dart';
import 'package:ashera_pet_new/model/member_pet.dart';
import 'package:ashera_pet_new/routes/route_name.dart';
import 'package:ashera_pet_new/view_model/photos_and_videos.dart';
import 'package:ashera_pet_new/widget/room/body.dart';
import 'package:dismissible_page/dismissible_page.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../data/blacklist.dart';
import '../../../enum/ranking_list_type.dart';
import '../../../model/add_adopt_record_dto.dart';
import '../../../model/complaint.dart';
import '../../../model/member.dart';
import '../../../utils/app_color.dart';
import '../../../utils/ws.dart';
import '../../../view_model/blacklist.dart';
import '../../../view_model/complaint_record.dart';
import '../../../view_model/message_controller.dart';
import '../../../widget/room/title.dart';
import '../../../widget/room/input.dart';

class RoomPage extends StatefulWidget {
  final MemberAndMsgLast userData;
  const RoomPage({
    super.key,
    required this.userData,
  });

  @override
  State<StatefulWidget> createState() => _RoomPageState();
}

class _RoomPageState extends State<RoomPage> {
  MemberAndMsgLast get userData => widget.userData;
  MemberModel get petData => widget.userData.member;
  PhotosAndVideosVm? _photosAndVideosVm;
  BlackListVm? _blackListVm;
  MessageControllerVm? _messageControllerVm;

  _onLayoutDone(_) {
    _messageControllerVm!.setInRoom(true);
    log('UserData: ${userData.toMap()}');
    _messageControllerVm!.initOtherMemberData(userData);
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(_onLayoutDone);
    //取自己是否是警示用戶
    Ws.stompClient
        .send(destination: Ws.isTargetMemberWarning, body: '${petData.id}');
    log('是誰的最後一筆：${userData.toMap()}');
  }

  @override
  void dispose() {
    _messageControllerVm!.setInRoom(false);
    _messageControllerVm!.removeOtherMember();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _messageControllerVm =
        Provider.of<MessageControllerVm>(context, listen: false);
    _blackListVm = Provider.of<BlackListVm>(context, listen: false);
    _photosAndVideosVm = Provider.of<PhotosAndVideosVm>(context, listen: false);
    return DismissiblePage(
      direction: DismissiblePageDismissDirection.startToEnd,
      dragSensitivity: 1,
      startingOpacity: 0.2,
      reverseDuration: const Duration(milliseconds: 10),
      child: Scaffold(
        resizeToAvoidBottomInset: true,
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
                  RoomTitle(
                      id: petData.id,
                      title: petData.nickname,
                      callback: _back,
                      menuCallback: _menuOnTap,
                      userNameOnTap: _userNameOnTap,
                      adoptRecordOnTap: _adoptRecordOnTap,
                      isShowReport: userData.chatType ==
                          ChatType
                              .PET /*&& Pet.petModel.where((element) => element.id == (userData.pet == null ? userData.msg!.memberPetId : userData.pet!.id)).isNotEmpty*/
                      ),
                  Flexible(
                      child: Stack(
                    alignment: Alignment.center,
                    children: [
                      RoomBody(member: petData),
                      if (BlackList.blacklist
                          .where(
                              (element) => element.targetMemberId == petData.id)
                          .isNotEmpty)
                        Container(
                          height: 50,
                          width: 160,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                              color: Colors.black38,
                              borderRadius: BorderRadius.circular(10)),
                          padding: const EdgeInsets.symmetric(
                              vertical: 5, horizontal: 10),
                          child: const Text(
                            '已加入黑名單',
                            style: TextStyle(color: Colors.white, fontSize: 20),
                          ),
                        )
                    ],
                  )),
                  RoomInput(
                    userData: petData,
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).padding.bottom,
                  )
                ],
              ),
            );
          },
        ),
      ),
      onDismissed: () => context.pop(),
    );
  }

  //返回
  void _back() {
    context.pop();
  }

  //點title
  void _userNameOnTap() {
    context.push(RouteName.searchPet, extra: petData);
  }

  //
  void _adoptRecordOnTap() {
    context.push(RouteName.adoptRecord);
  }

  //選單
  void _menuOnTap(ChatSetting item) async {
    log('item: ${item.zh} 對方：${petData.id}');
    switch (item) {
      case ChatSetting.photosAndVideos:
        _photosAndVideosVm!.initPhotosAndVideosData(petData);
        context.pushNamed(RouteName.photosAndVideosRecord);
        break;
      case ChatSetting.blacklist:
        bool r = await _showAlert('確定要把對方加入黑名單？');
        if (r) {
          //加
          _blackListVm!.addBlackList(petData.id);
        }
        break;
      case ChatSetting.report:
        //彈出視窗
        _showReportAction();
        break;
    }
  }

  Future<void> _showReportAction() async {
    String? value = await showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (context) {
          return Consumer<ComplaintRecordVm>(
            builder: (context, vm, _) {
              return SizedBox(
                  height: 200.0 +
                      (55 *
                          vm.reasonList
                              .where((e) => e.type == RankingListType.MESSAGE)
                              .length),
                  child: Column(
                    children: [
                      Text.rich(
                          textAlign: TextAlign.center,
                          TextSpan(
                              text: '檢舉\n',
                              style: TextStyle(color: Colors.grey[500]),
                              children: const [TextSpan(text: '你為何要檢舉此用戶？')])),
                      const Divider(),
                      ...vm.reasonList
                          .where((e) => e.type == RankingListType.MESSAGE)
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
                  ));
            },
          );
        });
    if (value != null) {
      AdoptRecordModel dto = AdoptRecordModel(
          fromMemberId: Member.memberModel.id,
          fromMember: Member.memberModel.name,
          targetMemberId: Member.nowChatMemberModel!.id,
          targetMember: Member.nowChatMemberModel!.name,
          reason: value,
          pic: '');
      //檢舉
      if (await Alert.showReportAlert(context, dto) != null) {
        Alert.showComplaintSuccessAlert(context);
        await Future.delayed(const Duration(milliseconds: 3000),
            () => Navigator.of(context).pop());
      }
    }
  }

  Widget _item(ComplaintModel e) {
    return GestureDetector(
      onTap: () => Navigator.pop(context, e.reason),
      child: Column(
        children: [ListTile(title: Text(e.reason)), const Divider()],
      ),
    );
  }

  Future<bool> _showAlert(String text) async {
    return await showCupertinoAlert(
        context: context, content: text, cancel: true, confirmation: true);
  }
}
