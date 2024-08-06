import 'dart:convert';
import 'dart:developer';

import 'package:ashera_pet_new/model/member_pet.dart';
import 'package:ashera_pet_new/utils/app_color.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../enum/tab_bar.dart';
import '../../model/follower.dart';
import '../../model/member.dart';
import '../../model/tuple.dart';
import '../../routes/route_name.dart';
import '../../utils/api.dart';
import '../../view_model/follower.dart';
import '../../view_model/member.dart';
import '../button.dart';
import '../number_new_line_text.dart';
import '../time_line/app_widget/avatars.dart';

class PetAndPostFollow extends StatefulWidget {
  final MemberModel userData;
  const PetAndPostFollow({
    super.key,
    required this.userData,
  });

  @override
  State<StatefulWidget> createState() => _PetAndPostFollowState();
}

class _PetAndPostFollowState extends State<PetAndPostFollow> {
  MemberModel get userData => widget.userData;
  List<FollowerRequestModel> followerMeList = [];
  List<FollowerRequestModel> myFollowerList = [];
  FriendDataCntDTO dto = const FriendDataCntDTO(
      memberId: 0, postCnt: 0, myFollowCnt: 0, followMeCnt: 0);

  late Future<List<FollowerRequestModel>> _followerMe;
  late Future<List<FollowerRequestModel>> _myFollower;
  late Future<FriendDataCntDTO> _dto;
  late Future<List<MemberPetModel>?> _petData;

  @override
  void initState() {
    super.initState();
    _followerMe = _getFollowerMe();
    _myFollower = _getMyFollower();
    _dto = _getFriendDataCnt();
    _petData = _getMemberPetModel();
  }

  Future<List<FollowerRequestModel>> _getFollowerMe() async {
    List<Tuple<bool, String>> r = await Future.wait([
      Api.getFollowerMeRequest(userData.id),
      Api.getFollowerMe(userData.id)
    ]);
    if (r[0].i1!) {
      List list = json.decode(r[0].i2!);
      followerMeList =
          List.from(list.map((e) => FollowerRequestModel.fromMap(e)).toList());
      followerMeList = List.from(followerMeList.toSet());
    }
    if (r[1].i1!) {
      List list = json.decode(r[1].i2!);
      followerMeList.addAll(
          List.from(list.map((e) => FollowerRequestModel.fromMap(e)).toList()));
      followerMeList = List.from(followerMeList.toSet());
    }

    return followerMeList;
  }

  Future<List<FollowerRequestModel>> _getMyFollower() async {
    List<Tuple<bool, String>> r = await Future.wait([
      Api.getMyFollowerRequest(userData.id),
      Api.getMyFollower(userData.id)
    ]);
    if (r[0].i1!) {
      List list = json.decode(r[0].i2!);
      myFollowerList =
          list.map((e) => FollowerRequestModel.fromMap(e)).toList();
      myFollowerList = List.from(myFollowerList.toSet());
    }
    if (r[1].i1!) {
      List list = json.decode(r[1].i2!);
      myFollowerList
          .addAll(list.map((e) => FollowerRequestModel.fromMap(e)).toList());
      myFollowerList = List.from(myFollowerList.toSet());
    }
    return myFollowerList;
  }

  Future<FriendDataCntDTO> _getFriendDataCnt() async {
    Tuple<bool, String> r = await Api.getFriendData(userData.id);
    if (r.i1!) {
      dto = FriendDataCntDTO.fromJson(r.i2!);
    }
    return dto;
  }

  Future<List<MemberPetModel>?> _getMemberPetModel() async {
    //Tuple<bool, String> r = await Api.getMemberData(userData.id);
    Tuple<bool, String> r = await Api.getPetByMemberId(userData.id);
    if (r.i1!) {
      log('對方寵物：${r.i2}');
      List petList = json.decode(r.i2!);
      return petList.map((e) => MemberPetModel.fromMap(e)).toList();
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        //主人 頭貼
        Flexible(
          flex: 2,
          child: Container(
            height: 115,
            width: 100,
            padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
            child: Column(
              children: [
                Expanded(child: Consumer<MemberVm>(
                  builder: (context, vm, _) {
                    return Stack(
                      alignment: Alignment.center,
                      children: [
                        Avatar.big(
                          callback: () {
                            if (userData.mugshot.isNotEmpty) {
                              //會員資料
                              context.push(RouteName.userProfile,
                                  extra: userData);
                            }
                          },
                          user: userData,
                        ),
                        if (vm.targetMemberWarnings
                            .where((e) =>
                                e.targetMemberId == userData.id &&
                                e.warning == true)
                            .isNotEmpty)
                          Positioned(
                              left: 4, top: 0, child: yellowButton(23, () {})),
                      ],
                    );
                  },
                )),
                Text(
                  userData.nickname,
                  style: const TextStyle(
                      color: AppColor.textFieldTitle,
                      fontSize: 18,
                      fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ),
        //寵物 頭貼與名稱
        Flexible(
          flex: 1,
          child: FutureBuilder(
            future: _petData,
            builder: (context, snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.done:
                  if (snapshot.data!.isNotEmpty) {
                    return SizedBox(
                      width: 90,
                      height: 60,
                      child: Stack(
                        alignment: Alignment.bottomLeft,
                        children: [
                          Avatar.medium(
                              callback: () {
                                if (snapshot.data!.length > 1) {
                                  //多隻
                                  context.push(RouteName.otherMemberPets,
                                      extra: snapshot.data!);
                                } else {
                                  //單隻
                                  context.push(RouteName.lookPetProfile,
                                      extra: snapshot.data![0]);
                                }
                              },
                              user: MemberModel.fromMap(
                                  snapshot.data![0].toMap())),
                          Positioned(
                              top: 0,
                              right: 0,
                              child: Visibility(
                                visible: snapshot.data!.length > 1,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 5, horizontal: 5),
                                  decoration: const BoxDecoration(
                                    color: Colors.blueAccent,
                                    shape: BoxShape.circle,
                                  ),
                                  child: Text(
                                    '+${snapshot.data!.length - 1}',
                                    style: const TextStyle(
                                        color: Colors.white, fontSize: 14),
                                  ),
                                ),
                              ))
                        ],
                      ),
                    );
                  } else {
                    return Container();
                  }
                default:
                  return Container();
              }
            },
          ),
        ),
        //貼文數
        Flexible(
            child: FutureBuilder(
          future: _dto,
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.none:
                return NumberNewLineText(number: dto.postCnt, text: '貼文');
              case ConnectionState.waiting:
                return NumberNewLineText(number: dto.postCnt, text: '貼文');
              case ConnectionState.active:
                return NumberNewLineText(number: dto.postCnt, text: '貼文');
              case ConnectionState.done:
                return NumberNewLineText(number: dto.postCnt, text: '貼文');
            }
          },
        )),
        //粉絲
        Flexible(child: Consumer<FollowerVm>(
          builder: (context, vm, _) {
            _followerMe = _getFollowerMe();
            return FutureBuilder(
              future: _followerMe,
              builder: (context, snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.none:
                    return NumberNewLineText(
                        number: followerMeList.length, text: '粉絲');
                  case ConnectionState.waiting:
                    return NumberNewLineText(
                        number: followerMeList.length, text: '粉絲');
                  case ConnectionState.active:
                    return NumberNewLineText(
                        number: followerMeList.length, text: '粉絲');
                  case ConnectionState.done:
                    return GestureDetector(
                      onTap: () async {
                        if (snapshot.data!.isNotEmpty) {
                          OtherPetFollowerModel data = OtherPetFollowerModel(
                              type: FollowerTabBarEnum.followerMe,
                              followerMeList: followerMeList,
                              myFollowerList: myFollowerList);
                          context.push(RouteName.otherFollower, extra: data);
                        }
                      },
                      child: NumberNewLineText(
                          number: snapshot.data!.length, text: '粉絲'),
                    );
                }
              },
            );
          },
        )),
        //追蹤中
        Flexible(child: Consumer<FollowerVm>(
          builder: (context, vm, _) {
            _myFollower = _getMyFollower();
            return FutureBuilder(
                future: _myFollower,
                builder: (context, snapshot) {
                  switch (snapshot.connectionState) {
                    case ConnectionState.none:
                      return NumberNewLineText(
                          number: myFollowerList.length, text: '追蹤中');
                    case ConnectionState.waiting:
                      return NumberNewLineText(
                          number: myFollowerList.length, text: '追蹤中');
                    case ConnectionState.active:
                      return NumberNewLineText(
                          number: myFollowerList.length, text: '追蹤中');
                    case ConnectionState.done:
                      return GestureDetector(
                        onTap: () {
                          if (snapshot.data!.isNotEmpty) {
                            OtherPetFollowerModel data = OtherPetFollowerModel(
                                type: FollowerTabBarEnum.myFollower,
                                followerMeList: followerMeList,
                                myFollowerList: myFollowerList);
                            context.push(RouteName.otherFollower, extra: data);
                          }
                        },
                        child: NumberNewLineText(
                            number: snapshot.data!.length, text: '追蹤中'),
                      );
                  }
                });
          },
        ))
      ],
    );
  }
}
