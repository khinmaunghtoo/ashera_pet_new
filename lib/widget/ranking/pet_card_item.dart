import 'package:ashera_pet_new/widget/ranking/pet_card_data.dart';
import 'package:ashera_pet_new/widget/ranking/pet_card_image.dart';
import 'package:ashera_pet_new/widget/ranking/pet_card_slab.dart';
import 'package:flutter/material.dart';

import '../../model/member_pet.dart';
import '../../model/ranking_message.dart';
import '../../model/tuple.dart';
import '../../utils/api.dart';

class RankingPetCardItem extends StatefulWidget {
  final RankingMessageModel item;
  final int index;
  const RankingPetCardItem(
      {super.key, required this.item, required this.index});

  @override
  State<StatefulWidget> createState() => _RankingPetCardItemState();
}

class _RankingPetCardItemState extends State<RankingPetCardItem>
    with AutomaticKeepAliveClientMixin {
  int get index => widget.index;
  RankingMessageModel get item => widget.item;
  late Future<MemberPetModel> _pet;

  @override
  void initState() {
    super.initState();
    _pet = _getPetModel();
  }

  Future<MemberPetModel> _getPetModel() async {
    Tuple<bool, String> r = await Api.getPet(item.memberPetId);
    return MemberPetModel.fromJson(r.i2!);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        //排行
        RankPetCardSlab(number: index),
        //照片
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: FutureBuilder(
              future: _pet,
              builder: (context, snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.done:
                    return RankPetCardImage(pet: snapshot.data!);
                  default:
                    return Container(
                      height: 250,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          border: Border.all(color: Colors.grey, width: 1)),
                      child: const Text(
                        '相片載入中',
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                    );
                }
              }),
        ),
        //寵物資料
        Container(
          padding: const EdgeInsets.only(top: 10),
          child: FutureBuilder(
            future: _pet,
            builder: (context, snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.done:
                  return RankingPetCardData(
                    pet: snapshot.data!,
                    count: item.count,
                  );
                default:
                  return Container();
              }
            },
          ),
        )
      ],
    );
  }

  @override
  bool get wantKeepAlive => true;
}
