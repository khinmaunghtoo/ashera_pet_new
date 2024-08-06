import 'package:ashera_pet_new/data/member.dart';
import 'package:ashera_pet_new/model/member_pet.dart';
import 'package:ashera_pet_new/view_model/search_record.dart';
import 'package:ashera_pet_new/view_model/search_text.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../model/member.dart';
import '../../routes/route_name.dart';
import '../../utils/app_color.dart';
import '../time_line/app_widget/avatars.dart';

class SearchData extends StatefulWidget {
  const SearchData({super.key});

  @override
  State<StatefulWidget> createState() => _SearchDataState();
}

class _SearchDataState extends State<SearchData> {
  SearchRecordVm? _recordVm;

  @override
  Widget build(BuildContext context) {
    _recordVm = Provider.of<SearchRecordVm>(context, listen: false);
    return Selector<SearchTextVm, bool>(
      selector: (context, data) => data.isSearchRecord,
      builder: (context, status, _) {
        return status ? _searchRecordWidget() : _searchPeopleWidget();
      },
    );
  }

  Widget _searchRecordWidget() {
    return SliverToBoxAdapter(
      child: Column(
        children: [
          Container(
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
            child: const Text(
              '最近搜尋',
              style: TextStyle(color: AppColor.textFieldTitle),
            ),
          ),
          SizedBox(
              height: MediaQuery.of(context).size.height,
              child: Selector<SearchRecordVm, List<MemberPetModel>>(
                selector: (context, data) => data.searchRecordList,
                shouldRebuild: (pre, next) => pre != next,
                builder: (context, list, _) {
                  if (list.isEmpty) {
                    return _noSearchRecord();
                  }
                  return ListView.builder(
                    padding: EdgeInsets.zero,
                    itemCount: list.length,
                    itemBuilder: (context, index) =>
                        _searchRecordItem(list[index]),
                  );
                },
              ))
        ],
      ),
    );
  }

  Widget _searchRecordItem(MemberPetModel data) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      child: Stack(
        alignment: Alignment.center,
        children: [
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () => _searchRecordOnTap(data),
            child: AbsorbPointer(
              child: Row(
                children: [
                  Flexible(child: _owner(data)),
                  const SizedBox(
                    width: 3,
                  ),
                  Flexible(child: _pet(data))
                  /*//頭像
                  Avatar.medium(user: data),
                  const SizedBox(
                    width: 10,
                  ),
                  Expanded(
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          //nickname
                          Text(
                            data.nickname,
                            style: const TextStyle(
                                color: AppColor.textFieldTitle, fontSize: 16),
                          ),
                          //底下不知道放什麼
                        ],
                      )),*/
                ],
              ),
            ),
          ),
          Positioned(
              top: 5,
              right: 5,
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () => _removeData(data),
                child: const AbsorbPointer(
                  child: Icon(
                    Icons.clear,
                    size: 30,
                    color: AppColor.textFieldTitle,
                  ),
                ),
              ))
        ],
      ),
    );
  }

  void _searchRecordOnTap(MemberPetModel data) {
    //log('記錄：${Pet.petModel[0].toMap()} ${data.toMap()}');
    if (Member.memberModel.id == data.memberId) {
      //自己
      context.push(RouteName.searchMe);
    } else {
      //進入寵物頁
      context.push(RouteName.searchPet,
          extra: MemberModel.fromMap(data.member!.toMap()));
    }
  }

  //刪除搜尋紀錄
  void _removeData(MemberPetModel data) {
    _recordVm!.removeSearchRecord(data);
  }

  Widget _noSearchRecord() {
    return const Center(
      child: Text(
        '沒有搜尋紀錄',
        style: TextStyle(color: AppColor.textFieldTitle),
      ),
    );
  }

  Widget _searchPeopleWidget() {
    return SliverToBoxAdapter(
      child: SizedBox(
          height: MediaQuery.of(context).size.height,
          child: Selector<SearchTextVm, List<MemberPetModel>>(
            selector: (context, data) => data.petList,
            shouldRebuild: (pre, next) => pre != next,
            builder: (context, list, _) {
              if (list.isEmpty) {
                return _noSearchPeople();
              }
              return ListView.builder(
                padding: EdgeInsets.zero,
                itemCount: list.length,
                itemBuilder: (context, index) => _searchPeopleItem(list[index]),
              );
            },
          )),
    );
  }

  Widget _searchPeopleItem(MemberPetModel data) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => _searchPeopleItemOnTap(data),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
        child: Row(
          children: [
            //主人
            Flexible(child: _owner(data)),
            //寵物
            const SizedBox(
              width: 3,
            ),
            Flexible(child: _pet(data)),

            //頭像
            //Avatar.medium(user: data),
            //const SizedBox(width: 10,),
            /*Column(
              children: [
                //nickname
                Text(
                  data.nickname,
                  style: const TextStyle(
                      color: AppColor.textFieldTitle, fontSize: 16),
                ),
                //底下不知道放什麼
              ],
            ),*/
          ],
        ),
      ),
    );
  }

  Widget _owner(MemberPetModel data) {
    return Row(
      children: [
        Avatar.medium(user: MemberModel.fromMap(data.member!.toMap())),
        const SizedBox(
          width: 10,
        ),
        Flexible(
            child: FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            data.member!.nickname,
            style:
                const TextStyle(color: AppColor.textFieldTitle, fontSize: 16),
          ),
        ))
      ],
    );
  }

  Widget _pet(MemberPetModel data) {
    return Row(
      children: [
        Avatar.medium(user: MemberModel.fromMap(data.toMap())),
        const SizedBox(
          width: 10,
        ),
        Flexible(
            child: FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            data.nickname,
            style:
                const TextStyle(color: AppColor.textFieldTitle, fontSize: 16),
          ),
        )),
      ],
    );
  }

  void _searchPeopleItemOnTap(MemberPetModel data) {
    //加入搜尋紀錄
    _recordVm!.addSearchRecord(data);
    if (Member.memberModel.id == data.memberId) {
      //這是自己
      context.push(RouteName.searchMe);
    } else {
      //進入寵物頁
      context.push(RouteName.searchPet,
          extra: MemberModel.fromMap(data.member!.toMap()));
    }
  }

  Widget _noSearchPeople() {
    return const Center(
      child: Text(
        '沒有符合搜尋的結果',
        style: TextStyle(color: AppColor.textFieldTitle),
      ),
    );
  }
}
