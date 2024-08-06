import 'package:ashera_pet_new/utils/app_color.dart';
import 'package:ashera_pet_new/widget/explore/body.dart';
import 'package:ashera_pet_new/widget/system_back.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../model/post.dart';
import '../../widget/explore/title.dart';

//探索
class ExplorePage extends StatefulWidget {
  final PostModel postData;

  const ExplorePage({
    super.key,
    required this.postData,
  });

  @override
  State<StatefulWidget> createState() => _ExplorePageState();
}

class _ExplorePageState extends State<ExplorePage>
    with AutomaticKeepAliveClientMixin {
  PostModel get postData => widget.postData;

  ScrollController controller = ScrollController();

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return SystemBack(
        child: Scaffold(
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
                //title
                ExploreTitle(
                  callback: _back,
                ),
                //body
                Expanded(
                    child: Container(
                  padding: const EdgeInsets.only(top: 5, right: 15, left: 15),
                  child: ExploreBody(
                    list: [postData],
                    controller: controller,
                  ),
                ))
              ],
            ),
          );
        },
      ),
    ));
  }

  void _back() {
    context.pop();
  }
}
