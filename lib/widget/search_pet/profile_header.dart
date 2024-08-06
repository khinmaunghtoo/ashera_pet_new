import 'dart:developer';

import 'package:animate_icons/animate_icons.dart';
import 'package:ashera_pet_new/enum/chat_type.dart';
import 'package:ashera_pet_new/model/follower.dart';
import 'package:ashera_pet_new/model/member.dart';
import 'package:ashera_pet_new/model/member_pet.dart';
import 'package:ashera_pet_new/model/recommend_member.dart';
import 'package:ashera_pet_new/page/bottom_navigation/chat/room.dart';
import 'package:ashera_pet_new/utils/app_color.dart';
import 'package:ashera_pet_new/view_model/follower.dart';
import 'package:ashera_pet_new/widget/search_pet/pet_and_post_follow.dart';
import 'package:ashera_pet_new/widget/search_pet/refer_a_friend_item.dart';
import 'package:dismissible_page/dismissible_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svprogresshud/flutter_svprogresshud.dart';
import 'package:provider/provider.dart';

import '../../data/member.dart';
import '../../model/message.dart';
import '../../view_model/chat_msg.dart';
import '../../view_model/recommend.dart';
import '../button.dart';
import 'about_me.dart';

class SearchPetProfileHeader extends StatefulWidget {
  final MemberModel userData;
  const SearchPetProfileHeader({super.key, required this.userData});

  @override
  State<StatefulWidget> createState() => _SearchPetProfileHeaderState();
}

class _SearchPetProfileHeaderState extends State<SearchPetProfileHeader> {
  MemberModel get userData => widget.userData;
  ChatMsgVm? _chatMsgVm;
  FollowerVm? _followerVm;
  RecommendFriendVm? _recommendVm;
  final bool _isOpen = false;

  late AnimateIconController controller;
  //推薦好友
  bool _isShowReferAFriend = false;

  _onLayoutDone(_) {
    _recommendVm!.getRecommendMember(userData.id);
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(_onLayoutDone);
    controller = AnimateIconController();
  }

  @override
  Widget build(BuildContext context) {
    _chatMsgVm = Provider.of(context, listen: false);
    _recommendVm = Provider.of(context, listen: false);
    _followerVm = Provider.of(context, listen: false);
    return LayoutBuilder(builder: (context, constraints) {
      return Column(
        children: [
          _confirmOrCancelTheOtherFollowButton(),
          //最上 會員 貼文數 跟隨中 追隨中
          Container(
            padding:
                const EdgeInsets.only(left: 20, right: 20, top: 15, bottom: 5),
            child: PetAndPostFollow(
              userData: userData,
            ),
          ),
          //關於
          if (userData.aboutMe.isNotEmpty)
            SearchPetAboutMe(aboutMe: userData.aboutMe),
          //追蹤 發送訊息
          Container(
            height: 60,
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(child: _followButton()),
                const SizedBox(
                  width: 20,
                ),
                Expanded(child: _sendMessageButton())
              ],
            ),
          ),
          //推薦好友
          Container(
            padding: const EdgeInsets.symmetric(vertical: 1, horizontal: 20),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text(
                  '推薦好友',
                  style: TextStyle(
                      color: AppColor.textFieldTitle,
                      fontSize: 14,
                      height: 1.1),
                ),
                AnimateIcons(
                  startIcon: Icons.expand_more_outlined,
                  endIcon: Icons.expand_less_outlined,
                  onStartIconPress: () {
                    log('這是關');
                    _isShowReferAFriend = false;
                    setState(() {});
                    return true;
                  },
                  onEndIconPress: () {
                    log('這是開');
                    _isShowReferAFriend = true;
                    setState(() {});
                    return true;
                  },
                  controller: controller,
                  duration: const Duration(milliseconds: 500),
                  startIconColor: AppColor.textFieldTitle,
                  endIconColor: AppColor.textFieldTitle,
                  clockwise: true,
                )
              ],
            ),
          ),
          Offstage(
            offstage: !_isShowReferAFriend,
            child: Container(
              height: 150,
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
              child: Selector<RecommendFriendVm, List<RecommendMemberModel>>(
                selector: (context, data) => data.recommendList.toList(),
                shouldRebuild: (previous, next) => previous != next,
                builder: (context, list, _) {
                  return ListView.builder(
                      padding: EdgeInsets.zero,
                      scrollDirection: Axis.horizontal,
                      addAutomaticKeepAlives: true,
                      addRepaintBoundaries: true,
                      itemCount: list.length,
                      itemBuilder: (context, index) {
                        return ReferAFriendItem(
                            memberId: list[index].recommendMemberId);
                      });
                },
              ),
            ),
          )
        ],
      );
    });
  }

  //確認或取消對方追蹤
  Widget _confirmOrCancelTheOtherFollowButton() {
    return Consumer<FollowerVm>(
      builder: (context, vm, _) {
        if (vm.followerMeList
            .where((element) =>
                element.memberId == userData.id && element.acceptTime == 0)
            .isNotEmpty) {
          return Container(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
            decoration: const BoxDecoration(color: AppColor.textFieldSelect),
            child: Row(
              children: [
                Expanded(
                    child: Text(
                  ' ${userData.nickname} 想要追蹤你是否同意？',
                  style: const TextStyle(
                      color: AppColor.textFieldTitle,
                      fontSize: 14,
                      height: 1.1),
                )),
                //同意
                SizedBox(
                  height: 25,
                  width: 50,
                  child: blueRectangleButton(
                      '同意', () => _sendAgreeFollower(vm), 5),
                ),
                const SizedBox(
                  width: 10,
                ),
                //取消
                SizedBox(
                  height: 25,
                  width: 50,
                  child: grayRectangleButton(
                      '拒絕', () => _sendRejectFollower(vm), 5),
                )
              ],
            ),
          );
        }
        return const SizedBox();
      },
    );
  }

  //追蹤按鈕
  Widget _followButton() {
    return Consumer<FollowerVm>(
      builder: (context, vm, _) {
        if (vm.myFollowerList
            .where((element) =>
                element.followerId == userData.id && element.acceptTime != 0)
            .isNotEmpty) {
          //取消追蹤
          return grayRectangleButton('取消追蹤', () => _sendCancelFollower(vm), 10);
        }
        if (vm.myFollowerList
            .where((element) => element.followerId == userData.id)
            .isNotEmpty) {
          //已發出追蹤
          return grayRectangleButton(
              '已送出追蹤請求', () => _sendRevokeFollower(vm), 10);
        }
        return blueRectangleButton('追蹤', () => _sendFollower(vm), 10);
      },
    );
  }

  //發送訊息
  Widget _sendMessageButton() {
    return grayRectangleButton('發送訊息', _sendMessageOnTap, 10);
  }

  //發送追蹤
  void _sendFollower(FollowerVm vm) {
    AddFollowerRequestDTO dto = AddFollowerRequestDTO(
        followerId: userData.id, memberId: Member.memberModel.id);
    vm.sendFollowerRequest(dto);
  }

  //同意追蹤
  void _sendAgreeFollower(FollowerVm vm) {
    AcceptFollowerRequestDTO dto = AcceptFollowerRequestDTO(
        followerId: Member.memberModel.id,
        memberId: userData.id,
        approve: true);
    vm.sendFollowerRequestAccept(dto);
  }

  //拒絕追蹤
  void _sendRejectFollower(FollowerVm vm) {
    AcceptFollowerRequestDTO dto = AcceptFollowerRequestDTO(
        followerId: Member.memberModel.id,
        memberId: userData.id,
        approve: false);
    vm.sendFollowerRequestAccept(dto);
  }

  //收回追蹤
  void _sendRevokeFollower(FollowerVm vm) {
    log('撤回追蹤');
    FollowerRequestModel data = vm.myFollowerList
        .where((element) => element.followerId == userData.id)
        .first;
    DeleteFollowerRequestDTO dto = DeleteFollowerRequestDTO(
        memberId: Member.memberModel.id, followerRequestId: data.id);
    vm.removeFollowerRequest(dto);
  }

  //取消追蹤
  void _sendCancelFollower(FollowerVm vm) {
    log('取消追蹤');
    AddFollowerRequestDTO dto = AddFollowerRequestDTO(
        followerId: userData.id, memberId: Member.memberModel.id);
    vm.removeFollower(dto);
  }

  //發送訊息
  void _sendMessageOnTap() async {
    //openOrCloseFirebaseMessaging(false);
    //await context.push(RouteName.room, extra: _getNextPageData());
    if (_followerVm!.myFollowerList
        .where((element) =>
            element.followerId == userData.id && element.acceptTime != 0)
        .isNotEmpty) {
      await context
          .pushTransparentRoute(RoomPage(userData: _getNextPageData()));
    } else {
      SVProgressHUD.showInfo(status: '此帳號若未追蹤你，你將無法發送訊息給這個帳號');
      await Future.delayed(const Duration(milliseconds: 2000));
      SVProgressHUD.dismiss();
    }

    //openOrCloseFirebaseMessaging(true);
  }

  MemberAndMsgLast _getNextPageData() {
    MessageModel? model;
    if (_chatMsgVm!.lastMsgList
        .where((element) =>
            element.targetMemberId == userData.id ||
            element.fromMemberId == userData.id)
        .isNotEmpty) {
      model = _chatMsgVm!.lastMsgList
          .where((element) =>
              element.targetMemberId == userData.id ||
              element.fromMemberId == userData.id)
          .first;
    } else {
      model = null;
    }
    return MemberAndMsgLast(
        member: MemberModel.fromMap(userData.toMap()),
        msg: model,
        chatType: ChatType.GENERAL);
  }
}
