import 'dart:math';
import 'package:ashera_pet_new/model/member.dart';
import 'package:ashera_pet_new/widget/time_line/app_widget/avatars.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../enum/ranking_classification.dart';
import '../../model/member_pet.dart';
import '../../model/tuple.dart';
import '../../utils/api.dart';
import '../../utils/app_color.dart';
import '../../utils/app_image.dart';
import '../../view_model/ranking_classification.dart';

// 排行分類篩選按鈕
// 最愛，最多收藏，最多留言之類的
class RankingClassification extends StatefulWidget {
  const RankingClassification({super.key});

  @override
  State<StatefulWidget> createState() => _RankingClassificationState();
}

class _RankingClassificationState extends State<RankingClassification> {
  int? _randomMs;
  int? _randomFo;
  int? _randomPo;
  int? _randomLike;
  int? _randomKeep;

  Future<MemberPetModel>? _likePet;
  Future<MemberPetModel>? _keepPet;

  RankingClassificationVm? _classificationVm;

  _onLayoutDone(_) {
    _randomLike ??= Random().nextInt(_classificationVm!.likeList.isNotEmpty
        ? _classificationVm!.likeList.length - 1
        : 0);
    _randomKeep ??=
        Random().nextInt(_classificationVm!.collectionList.length - 1);

    _likePet =
        _getPetsModel(_classificationVm!.likeList[_randomLike!].memberPetId);
    _keepPet = _getPetsModel(
        _classificationVm!.collectionList[_randomKeep!].memberPetId);

    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(_onLayoutDone);
  }

  @override
  Widget build(BuildContext context) {
    _classificationVm = Provider.of<RankingClassificationVm>(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children:
            RankingClassificationEnum.values.map((e) => _item(e)).toList(),
      ),
    );
  }

  Widget _item(RankingClassificationEnum value) {
    return Consumer<RankingClassificationVm>(
      builder: (context, vm, _) {
        return GestureDetector(
          onTap: () => vm.setClassification(value),
          child: Column(
            children: [
              _noAvatar(value, vm),
              const SizedBox(
                height: 5,
              ),
              FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  value.zh,
                  style: TextStyle(
                      color: _getTextColor(value, vm),
                      fontSize: 15,
                      fontWeight: _getFontWeight(value, vm),
                      letterSpacing: 1.5),
                ),
              )
            ],
          ),
        );
      },
    );
  }

  Widget _noAvatar(value, vm) {
    return Container(
        decoration: BoxDecoration(
            shape: BoxShape.circle,
            border:
                Border.all(color: _getAvatarBorderColor(value, vm), width: 3)),
        child: _getAvatar(value, vm));
  }

  Widget _getAvatar(
      RankingClassificationEnum value, RankingClassificationVm vm) {
    switch (value) {
      case RankingClassificationEnum.message:
        if (vm.messageList.isNotEmpty) {
          _randomMs ??= Random().nextInt(vm.messageList.length - 1);
          return CircleAvatar(
            radius: 33,
            child: Avatar.big(user: vm.messageList[_randomMs!].member!),
          );
        } else {
          return const CircleAvatar(
            radius: 33,
            backgroundColor: AppColor.textFieldTitle,
            child: Image(
              width: 30,
              fit: BoxFit.cover,
              image: AssetImage(AppImage.logoGray),
            ),
          );
        }
      case RankingClassificationEnum.fan:
        if (vm.followerList.isNotEmpty) {
          _randomFo ??= Random().nextInt(vm.followerList.length - 1);
          return CircleAvatar(
            radius: 33,
            child: Avatar.big(user: vm.followerList[_randomFo!].member),
          );
        } else {
          return const CircleAvatar(
            radius: 33,
            backgroundColor: AppColor.textFieldTitle,
            child: Image(
              width: 30,
              fit: BoxFit.cover,
              image: AssetImage(AppImage.logoGray),
            ),
          );
        }
      case RankingClassificationEnum.like:
        if (vm.likeList.isNotEmpty) {
          return FutureBuilder(
              future: _likePet,
              builder: (context, snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.done:
                    return CircleAvatar(
                      radius: 33,
                      child: Avatar.big(
                          user: MemberModel.fromMap(snapshot.data!.toMap())),
                    );
                  default:
                    return const CircleAvatar(
                      radius: 33,
                      backgroundColor: AppColor.textFieldTitle,
                      child: Image(
                        width: 30,
                        fit: BoxFit.cover,
                        image: AssetImage(AppImage.logoGray),
                      ),
                    );
                }
              });
        } else {
          return const CircleAvatar(
            radius: 33,
            backgroundColor: AppColor.textFieldTitle,
            child: Image(
              width: 30,
              fit: BoxFit.cover,
              image: AssetImage(AppImage.logoGray),
            ),
          );
        }
      case RankingClassificationEnum.collection:
        if (vm.collectionList.isNotEmpty) {
          return FutureBuilder(
              future: _keepPet,
              builder: (context, snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.done:
                    return CircleAvatar(
                      radius: 33,
                      child: Avatar.big(
                          user: MemberModel.fromMap(snapshot.data!.toMap())),
                    );
                  default:
                    return const CircleAvatar(
                      radius: 33,
                      backgroundColor: AppColor.textFieldTitle,
                      child: Image(
                        width: 30,
                        fit: BoxFit.cover,
                        image: AssetImage(AppImage.logoGray),
                      ),
                    );
                }
              });
        } else {
          return const CircleAvatar(
            radius: 33,
            backgroundColor: AppColor.textFieldTitle,
            child: Image(
              width: 30,
              fit: BoxFit.cover,
              image: AssetImage(AppImage.logoGray),
            ),
          );
        }
    }
  }

  Color _getTextColor(
      RankingClassificationEnum value, RankingClassificationVm vm) {
    if (value == vm.classification) {
      return Colors.white;
    } else {
      return AppColor.textFieldTitle;
    }
  }

  Color _getAvatarBorderColor(
      RankingClassificationEnum value, RankingClassificationVm vm) {
    if (value == vm.classification) {
      return Colors.white;
    } else {
      return Colors.transparent;
    }
  }

  FontWeight? _getFontWeight(
      RankingClassificationEnum value, RankingClassificationVm vm) {
    if (value == vm.classification) {
      return FontWeight.w700;
    } else {
      return null;
    }
  }

  Future<MemberPetModel> _getPetsModel(int petId) async {
    Tuple<bool, String> r = await Api.getPet(petId);
    return MemberPetModel.fromJson(r.i2!);
  }
}
