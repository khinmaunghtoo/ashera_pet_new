import 'package:ashera_pet_new/view_model/ranking_classification.dart';
import 'package:ashera_pet_new/widget/ranking/pet_card.dart';
import 'package:ashera_pet_new/widget/ranking/post_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:inview_notifier_list/inview_notifier_list.dart';
import 'package:provider/provider.dart';

import '../../utils/app_color.dart';
import 'classification.dart';

//* POS貼文排行頁面
class PostRankingBody extends StatelessWidget {
  final PageController controller;
  const PostRankingBody({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const RankingClassification(),
        Expanded(
            child: PageView(
          controller: controller,
          children: [
            InViewNotifierCustomScrollView(
              slivers: [
                Consumer<RankingClassificationVm>(
                  builder: (context, vm, _) {
                    if (vm.postCard.isEmpty) {
                      return const SliverFillRemaining(
                        child: Center(
                          child: Text(
                            '目前還沒有貼文',
                            style: TextStyle(color: AppColor.textFieldTitle),
                          ),
                        ),
                      );
                    }
                    if (vm.classification.index != 0) {
                      return const SliverFillRemaining(
                        child: Center(
                          child: Text(
                            '目前還沒有貼文',
                            style: TextStyle(color: AppColor.textFieldTitle),
                          ),
                        ),
                      );
                    }
                    return RankingPostCard(
                      postList: vm.postCard,
                      nowPageIndex: vm.classification.index,
                      myPageIndex: 0,
                    );
                  },
                ),
              ],
              isInViewPortCondition: (double deltaTop, double deltaBottom,
                  double viewPortDimension) {
                return deltaTop < (0.5 * viewPortDimension) &&
                    deltaBottom > (0.5 * viewPortDimension);
              },
            ),
            InViewNotifierCustomScrollView(
              slivers: [
                Consumer<RankingClassificationVm>(
                  builder: (context, vm, _) {
                    if (vm.postCard.isEmpty) {
                      return const SliverFillRemaining(
                        child: Center(
                          child: Text(
                            '目前還沒有貼文',
                            style: TextStyle(color: AppColor.textFieldTitle),
                          ),
                        ),
                      );
                    }
                    if (vm.classification.index != 1) {
                      return const SliverFillRemaining(
                        child: Center(
                          child: Text(
                            '目前還沒有貼文',
                            style: TextStyle(color: AppColor.textFieldTitle),
                          ),
                        ),
                      );
                    }
                    return RankingPostCard(
                      postList: vm.postCard,
                      nowPageIndex: vm.classification.index,
                      myPageIndex: 1,
                    );
                  },
                ),
              ],
              isInViewPortCondition: (double deltaTop, double deltaBottom,
                  double viewPortDimension) {
                return deltaTop < (0.5 * viewPortDimension) &&
                    deltaBottom > (0.5 * viewPortDimension);
              },
            ),
            InViewNotifierCustomScrollView(
              slivers: [
                Consumer<RankingClassificationVm>(
                  builder: (context, vm, _) {
                    if (vm.postCard.isEmpty) {
                      return const SliverFillRemaining(
                        child: Center(
                          child: Text(
                            '目前還沒有貼文',
                            style: TextStyle(color: AppColor.textFieldTitle),
                          ),
                        ),
                      );
                    }
                    if (vm.classification.index != 2) {
                      return const SliverFillRemaining(
                        child: Center(
                          child: Text(
                            '目前還沒有貼文',
                            style: TextStyle(color: AppColor.textFieldTitle),
                          ),
                        ),
                      );
                    }
                    return RankingPetCard(
                      postList: vm.postCard,
                    );
                  },
                ),
              ],
              isInViewPortCondition: (double deltaTop, double deltaBottom,
                  double viewPortDimension) {
                return deltaTop < (0.5 * viewPortDimension) &&
                    deltaBottom > (0.5 * viewPortDimension);
              },
            ),
            InViewNotifierCustomScrollView(
              slivers: [
                Consumer<RankingClassificationVm>(
                  builder: (context, vm, _) {
                    if (vm.postCard.isEmpty) {
                      return const SliverFillRemaining(
                        child: Center(
                          child: Text(
                            '目前還沒有貼文',
                            style: TextStyle(color: AppColor.textFieldTitle),
                          ),
                        ),
                      );
                    }
                    if (vm.classification.index != 3) {
                      return const SliverFillRemaining(
                        child: Center(
                          child: Text(
                            '目前還沒有貼文',
                            style: TextStyle(color: AppColor.textFieldTitle),
                          ),
                        ),
                      );
                    }
                    return RankingPetCard(
                      postList: vm.postCard,
                    );
                  },
                ),
              ],
              isInViewPortCondition: (double deltaTop, double deltaBottom,
                  double viewPortDimension) {
                return deltaTop < (0.5 * viewPortDimension) &&
                    deltaBottom > (0.5 * viewPortDimension);
              },
            ),
          ],
        ))
      ],
    );
  }
}
