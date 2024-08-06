import 'package:ashera_pet_new/widget/ranking/picture_carousal.dart';
import 'package:ashera_pet_new/widget/ranking/profile_slab.dart';
import 'package:flutter/cupertino.dart';
import 'package:inview_notifier_list/inview_notifier_list.dart';

import '../../utils/app_color.dart';

class RankingPostCard extends StatefulWidget {
  final List<dynamic> postList;
  final int nowPageIndex;
  final int myPageIndex;
  const RankingPostCard(
      {super.key,
      required this.postList,
      required this.nowPageIndex,
      required this.myPageIndex});

  @override
  State<StatefulWidget> createState() => _RankingPostCardState();
}

class _RankingPostCardState extends State<RankingPostCard> {
  @override
  Widget build(BuildContext context) {
    return SliverList(
        delegate: SliverChildBuilderDelegate((context, index) {
      return InViewNotifierWidget(
          id: 'post-${widget.postList[index].id}',
          builder: (context, isInView, _) {
            return Container(
              key: ValueKey('post-${widget.postList[index].id}'),
              margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
              padding: const EdgeInsets.symmetric(vertical: 10),
              decoration: BoxDecoration(
                  color: AppColor.textFieldUnSelect,
                  borderRadius: BorderRadius.circular(10)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  RankProfileSlab(
                      userData: widget.postList[index],
                      number: index,
                      model: widget.postList[index]),
                  RankPictureCarousal(
                    postCardData: widget.postList[index],
                    inView:
                        isInView && (widget.nowPageIndex == widget.myPageIndex),
                  ),
                ],
              ),
            );
          });
    }, childCount: widget.postList.length));
  }
}
