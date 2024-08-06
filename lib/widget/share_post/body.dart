import 'package:flutter/material.dart';
import 'package:inview_notifier_list/inview_notifier_list.dart';

import '../../model/post.dart';
import '../home/post_card.dart';

class SharePostBody extends StatelessWidget{
  final List<PostModel> list;
  final ScrollController controller;
  const SharePostBody({
    super.key,
    required this.list,
    required this.controller
  });

  @override
  Widget build(BuildContext context) {
    return InViewNotifierList(
      controller: controller,
      padding: EdgeInsets.zero,
      physics: const ClampingScrollPhysics(),
      scrollDirection: Axis.vertical,
      addAutomaticKeepAlives: true,
      isInViewPortCondition: (double deltaTop, double deltaBottom, double viewPortDimension){
        return deltaTop < (0.5 * viewPortDimension) &&
            deltaBottom > (0.5 * viewPortDimension);
      },
      itemCount: list.length,
      builder: (context, index){
        return PostCard(
          key: ValueKey('post-${list[index].id}'),
          postCardData: list[index],
        );
      },
    );
  }
}