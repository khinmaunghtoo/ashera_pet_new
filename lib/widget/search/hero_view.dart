import 'package:ashera_pet_new/model/hero_view_params.dart';
import 'package:ashera_pet_new/widget/system_back.dart';
import 'package:dismissible_page/dismissible_page.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../utils/app_color.dart';
import '../../utils/utils.dart';
import '../back_button.dart';
import '../hero_view/pic.dart';

class NetworkImageHeroView extends StatelessWidget {
  final HeroViewParamsModel paramsModel;
  const NetworkImageHeroView({super.key, required this.paramsModel});

  @override
  Widget build(BuildContext context) {
    return DismissiblePage(
        direction: DismissiblePageDismissDirection.down,
        child: SystemBack(
            child: Scaffold(
          backgroundColor: AppColor.appBackground,
          resizeToAvoidBottomInset: false,
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
                    _title(context),
                    Expanded(
                        child: HeroViewPic(
                      tag: paramsModel.tag,
                      imgUrl: paramsModel.data,
                    ) /*Hero(
                tag: paramsModel.tag,
                child: PhotoView(
                  minScale: PhotoViewComputedScale.contained,
                  imageProvider: CachedNetworkImageProvider(
                    Utils.getFilePath(paramsModel.data as String),
                    headers: {"authorization": "Bearer ${Api.accessToken}"},
                  ),
                ),
              )*/
                        )
                  ],
                ),
              );
            },
          ),
        )),
        onDismissed: () => context.pop());
  }

  Widget _title(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
      height: Utils.appBarHeight,
      alignment: Alignment.center,
      decoration: const BoxDecoration(color: AppColor.textFieldUnSelect),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
              child: TopCloseBackButton(
            alignment: Alignment.centerLeft,
            callback: () {
              if (context.canPop()) {
                context.pop();
              }
            },
          )),
          Expanded(child: Container())
        ],
      ),
    );
  }
}
