import 'dart:convert';

import 'package:ashera_pet_new/data/member.dart';
import 'package:ashera_pet_new/enum/chat_type.dart';
import 'package:ashera_pet_new/enum/gender.dart';
import 'package:ashera_pet_new/enum/health_status.dart';
import 'package:ashera_pet_new/model/member_pet.dart';
import 'package:ashera_pet_new/page/bottom_navigation/chat/room.dart';
import 'package:ashera_pet_new/routes/route_name.dart';
import 'package:ashera_pet_new/view_model/message_controller.dart';
import 'package:ashera_pet_new/widget/pet_magazine_content/pic_view.dart';
import 'package:dismissible_page/dismissible_page.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../model/member.dart';
import '../../model/message.dart';
import '../../model/tuple.dart';
import '../../utils/api.dart';
import '../../utils/app_color.dart';
import '../../view_model/chat_msg.dart';
import '../../view_model/kanban.dart';
import '../button.dart';

class PetMagazineContentBody extends StatefulWidget {
  final MemberPetModel pet;
  const PetMagazineContentBody({super.key, required this.pet});

  @override
  State<StatefulWidget> createState() => _PetMagazineContentBodyState();
}

class _PetMagazineContentBodyState extends State<PetMagazineContentBody> {
  MemberPetModel get pet => widget.pet;
  ChatMsgVm? _chatMsgVm;
  MemberModel? _model;
  MessageControllerVm? _messageControllerVm;

  _onLayoutDone(_) async {}

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(_onLayoutDone);
    _pet();
  }

  void _pet() async {
    _model = await _getPetModel();
  }

  Future<MemberModel> _getPetModel() async {
    Tuple<bool, String> r = await Api.getMemberData(pet.memberId);
    return MemberModel.fromJson(r.i2!);
  }

  @override
  Widget build(BuildContext context) {
    _chatMsgVm = Provider.of<ChatMsgVm>(context);
    _messageControllerVm = Provider.of<MessageControllerVm>(context);
    return Container(
      padding: EdgeInsets.only(
          top: 20,
          left: 20,
          right: 20,
          bottom: MediaQuery.of(context).padding.bottom),
      child: CustomScrollView(
        slivers: [
          //寵物相片
          SliverToBoxAdapter(
            child: _pics(),
          ),
          _itemWidget()
        ],
      ),
    );
  }

  Widget _pics() {
    List<String> pics = List<String>.from(json.decode(pet.pics));
    if (pics.isNotEmpty) {
      return ContentPicView(imagePaths: pics, tag: 'images${pet.id}');
    } else {
      return Container(
        height: 250,
        alignment: Alignment.center,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            border: Border.all(color: Colors.grey, width: 1)),
        child: const Text(
          '未上傳更多相片',
          style: TextStyle(color: Colors.white, fontSize: 16),
        ),
      );
    }
  }

  Widget _itemBodyWidget(String title, String value) {
    return Container(
      alignment: Alignment.center,
      margin: const EdgeInsets.only(top: 10),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 12, color: Colors.white),
          ),
          const SizedBox(
            height: 5,
          ),
          Container(
            height: 50,
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            decoration: BoxDecoration(
                color: AppColor.textFieldUnSelect,
                borderRadius: BorderRadius.circular(15),
                border: Border.all(
                    color: AppColor.textFieldUnSelectBorder, width: 1)),
            child: Text(
              value,
              style: const TextStyle(color: Colors.white, fontSize: 16),
            ),
          )
        ],
      ),
    );
  }

  //多行
  Widget _itemBodyMultiLineWidget(String title, String value) {
    return Container(
      alignment: Alignment.center,
      margin: const EdgeInsets.only(top: 10),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 12, color: Colors.white),
          ),
          const SizedBox(
            height: 5,
          ),
          Container(
            height: 120,
            alignment: Alignment.topLeft,
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            decoration: BoxDecoration(
                color: AppColor.textFieldUnSelect,
                borderRadius: BorderRadius.circular(15),
                border: Border.all(
                    color: AppColor.textFieldUnSelectBorder, width: 1)),
            child: SingleChildScrollView(
                child: Text(
              value,
              maxLines: 80,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(color: Colors.white, fontSize: 16),
            )),
          )
        ],
      ),
    );
  }

  Widget _itemWidget() {
    return SliverToBoxAdapter(
      child: Column(
        children: [
          //關於我
          _itemBodyMultiLineWidget('關於我', pet.aboutMe),
          //暱稱
          _itemBodyWidget('暱稱', pet.nickname),
          //性別
          _itemBodyWidget('性別', GenderEnum.values[pet.gender].zh),
          //生日
          _itemBodyWidget('生日', pet.birthday),
          //狀態
          _itemBodyWidget('狀態', HealthStatus.values[pet.healthStatus].zh),
          //按鈕(私訊飼主、加入珍藏)
          Visibility(
              visible: pet.memberId != Member.memberModel.id,
              child: Container(
                padding: const EdgeInsets.only(top: 20),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Visibility(
                        visible: pet.healthStatus !=
                                HealthStatus.healthy.index &&
                            !_messageControllerVm!
                                .isInRoom /*LocalRoute.isContain(RouteName.room)*/,
                        child: SizedBox(
                          width: 120,
                          child: blueRectangleButton('私訊飼主', () async {
                            //openOrCloseFirebaseMessaging(false);
                            /*await context.push(RouteName.room, extra: _getNextPageData());*/
                            await context.pushTransparentRoute(
                                RoomPage(userData: _getNextPageData()));
                            //openOrCloseFirebaseMessaging(true);
                          }),
                        )),
                    Visibility(
                      visible: pet.healthStatus == HealthStatus.healthy.index,
                      child: SizedBox(
                        width: 120,
                        child: blueRectangleButton(
                            '查詢主頁',
                            () => context.push(RouteName.searchPet,
                                extra: _model)),
                      ),
                    ),
                    const SizedBox(
                      width: 30,
                    ),
                    SizedBox(
                      width: 120,
                      child: Consumer<KanBanVm>(
                        builder: (context, vm, _) {
                          return blueRectangleButton(
                              vm.isCollection(pet.id) ? '刪除收藏' : '加入珍藏',
                              () => vm.onTapCollection(pet.id));
                        },
                      ),
                    ),
                  ],
                ),
              )),
        ],
      ),
    );
  }

  MemberAndMsgLast _getNextPageData() {
    MessageModel? model;
    if (_chatMsgVm!.lastMsgList
        .where((element) =>
            element.targetMemberId == pet.memberId ||
            element.fromMemberId == pet.memberId)
        .isNotEmpty) {
      model = _chatMsgVm!.lastMsgList
          .where((element) =>
              element.targetMemberId == pet.memberId ||
              element.fromMemberId == pet.memberId)
          .first;
    } else {
      model = null;
    }
    return MemberAndMsgLast(
        member: MemberModel.fromMap(_model!.toMap()),
        msg: model,
        pet: pet,
        chatType: ChatType.PET);
  }
}
