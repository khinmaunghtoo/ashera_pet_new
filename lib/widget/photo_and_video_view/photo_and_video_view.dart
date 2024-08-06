import 'package:ashera_pet_new/utils/app_color.dart';
import 'package:ashera_pet_new/widget/photo_and_video_view/src/body.dart';
import 'package:ashera_pet_new/widget/photo_and_video_view/src/title.dart';
import 'package:ashera_pet_new/widget/system_back.dart';
import 'package:dismissible_page/dismissible_page.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../model/hero_view_params.dart';

class PhotoAndVideoView extends StatefulWidget {
  final HeroViewParamsModel paramsModel;
  const PhotoAndVideoView({super.key, required this.paramsModel});

  @override
  State<StatefulWidget> createState() => _PhotoAndVideoViewState();
}

class _PhotoAndVideoViewState extends State<PhotoAndVideoView> {
  HeroViewParamsModel get paramsModel => widget.paramsModel;

  @override
  Widget build(BuildContext context) {
    return DismissiblePage(
        onDismissed: () => context.pop(),
        child: SystemBack(
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
                    PhotoAndVideoViewTitle(
                      callback: _back,
                    ),
                    //body
                    Expanded(
                        child: Hero(
                      tag: paramsModel.tag,
                      child: PhotoAndVideoViewBody(
                        dataPath: List<String>.from(paramsModel.data),
                        index: paramsModel.index,
                      ),
                    ))
                  ],
                ),
              );
            },
          ),
        )));
  }

  void _back() {
    context.pop();
  }
}
