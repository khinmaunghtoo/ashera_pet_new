import 'dart:io';

import 'package:ashera_pet_new/model/hero_view_params.dart';
import 'package:ashera_pet_new/utils/app_color.dart';
import 'package:dismissible_page/dismissible_page.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:photo_view/photo_view.dart';

import '../../utils/utils.dart';
import '../back_button.dart';

class FileHeroView extends StatelessWidget {
  final HeroViewParamsModel paramsModel;
  const FileHeroView({super.key, required this.paramsModel});

  @override
  Widget build(BuildContext context) {
    return DismissiblePage(
      direction: DismissiblePageDismissDirection.down,
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
                      child: Hero(
                    tag: paramsModel.tag,
                    child: PhotoView(
                      imageProvider: FileImage(paramsModel.data as File),
                      minScale: PhotoViewComputedScale.contained,
                    ),
                  ))
                ],
              ),
            );
          },
        ),
      ),
      onDismissed: () => context.pop(),
    );
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
            callback: () => context.pop(),
          )),
          Expanded(child: Container())
        ],
      ),
    );
  }
}
