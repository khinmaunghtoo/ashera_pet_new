import 'dart:developer';

import 'package:ashera_pet_new/model/blacklist.dart';
import 'package:ashera_pet_new/view_model/blacklist.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../model/member.dart';
import '../../model/tuple.dart';
import '../../utils/api.dart';
import '../../utils/app_color.dart';
import '../time_line/app_widget/avatars.dart';

class BlockItem extends StatefulWidget {
  final BlackListModel data;

  const BlockItem({super.key, required this.data});

  @override
  State<StatefulWidget> createState() => _BlockItemState();
}

class _BlockItemState extends State<BlockItem>
    with AutomaticKeepAliveClientMixin {
  BlackListModel get data => widget.data;
  late Future<MemberModel> _pet;

  BlackListVm? _blackListVm;

  @override
  void initState() {
    super.initState();
    log('傳進來的：${data.toMap()}');
    _pet = _getMemberModel();
  }

  Future<MemberModel> _getMemberModel() async {
    //Tuple<bool, String> r = await Api.getPetByMemberId(data.targetMemberId);
    Tuple<bool, String> r = await Api.getMemberData(data.targetMemberId);
    log('r ${r.i2!}');
    return MemberModel.fromJson(r.i2!);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    _blackListVm = Provider.of<BlackListVm>(context, listen: false);
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 5),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: AppColor.textFieldUnSelect),
      child: FutureBuilder(
        future: _pet,
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
              return _loadingWidget();
            case ConnectionState.waiting:
              return _loadingWidget();
            case ConnectionState.active:
              return _loadingWidget();
            case ConnectionState.done:
              log('有嗎？${snapshot.data!.toMap()}');
              return Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  //大頭照
                  Avatar.medium(user: snapshot.data!),
                  const SizedBox(
                    width: 10,
                  ),
                  //名稱、性別與內容
                  Expanded(
                    child: Text(
                      snapshot.data!.nickname,
                      style: const TextStyle(
                          color: AppColor.textFieldTitle,
                          fontSize: 16,
                          fontWeight: FontWeight.w500),
                    ),
                  ),
                  //解鎖
                  _unBlockButton()
                ],
              );
          }
        },
      ),
    );
  }

  Widget _unBlockButton() {
    return GestureDetector(
      onTap: () => _unblockOnTap(),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: Colors.white, width: 1),
        ),
        child: const Text(
          "解除",
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }

  Widget _loadingWidget() {
    return Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: const CircularProgressIndicator(),
    );
  }

  void _unblockOnTap() {
    _blackListVm!.removeBlackList(data.id);
  }

  @override
  bool get wantKeepAlive => true;
}
