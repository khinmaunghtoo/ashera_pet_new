import 'package:ashera_pet_new/widget/ranking/pet_card_item.dart';
import 'package:flutter/cupertino.dart';

import '../../model/ranking_message.dart';
import '../../utils/app_color.dart';

class RankingPetCard extends StatelessWidget {
  final List<RankingMessageModel> postList;
  const RankingPetCard({super.key, required this.postList});

  @override
  Widget build(BuildContext context) {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          return Container(
            margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
            padding: const EdgeInsets.only(bottom: 10),
            decoration: BoxDecoration(
                color: AppColor.textFieldUnSelect,
                borderRadius: BorderRadius.circular(10)),
            child: RankingPetCardItem(
              item: postList[index],
              index: index,
            ),
          );
        },
        childCount: postList.length,
      ),
    );
  }
}
