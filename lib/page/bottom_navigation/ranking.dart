import 'package:ashera_pet_new/widget/ranking/body.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../utils/app_color.dart';
import '../../view_model/ranking_classification.dart';
import '../../widget/ranking/title.dart';

//* 排行頁面
//  貼文最多留言，最多關注，最多愛心，最多收藏
class PostRankingPage extends StatefulWidget {
  const PostRankingPage({super.key});

  @override
  State<StatefulWidget> createState() => _PostRankingPageState();
}

class _PostRankingPageState extends State<PostRankingPage>
    with AutomaticKeepAliveClientMixin {
  RankingClassificationVm? _rankingClassificationVm;

  @override
  bool get wantKeepAlive => true;

  final PageController _pageController = PageController(initialPage: 0);

  _onLayoutDone(_) {
    _rankingClassificationVm!.initPageController(_pageController);
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(_onLayoutDone);
  }

  @override
  Widget build(BuildContext context) {
    _rankingClassificationVm =
        Provider.of<RankingClassificationVm>(context, listen: false);
    super.build(context);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: AppColor.appBackground,
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SizedBox(
            height: constraints.maxHeight,
            width: constraints.maxWidth,
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                PostRankingTitle(
                  callback: _barTap,
                ),
                Expanded(
                    child: PostRankingBody(
                  controller: _pageController,
                )),
              ],
            ),
          );
        },
      ),
    );
  }

  void _barTap() {}
}
