
import 'package:ashera_pet_new/routes/app_router.dart';
import 'package:ashera_pet_new/routes/route_name.dart';
import 'package:ashera_pet_new/widget/home/post_card_body.dart';
import 'package:flutter/material.dart';
import 'package:inview_notifier_list/inview_notifier_list.dart';
import 'package:provider/provider.dart';

import '../../enum/bottom_bar.dart';
import '../../model/post.dart';
import '../../view_model/bottom_bar.dart';

/// {@template post_card}
/// A card that displays a user post/activity.
/// {@endTemplate}
class PostCard extends StatelessWidget{
  final PostModel postCardData;
  /// {@macro post_card}
  const PostCard({
    super.key,
    required this.postCardData
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
        builder: (context, constraints){
          return InViewNotifierWidget(
            id: 'post-${postCardData.id}',
            builder: (context, isInView, _) => Consumer<BottomBarVm>(builder: (context, vm, _){
              return PostCardBody(
                postCardData: postCardData,
                isInView: isInView &&
                    vm.selectedTab == BottomTab.home &&
                    AppRouter.currentLocation == RouteName.bottomNavigation || AppRouter.currentLocation == RouteName.singlePost,
              );
            },),
          );
        }
    );
  }
}

