import 'package:ashera_pet_new/utils/app_color.dart';
import 'package:ashera_pet_new/view_model/photos_and_videos.dart';
import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../utils/utils.dart';
import '../back_button.dart';

class PhotosAndVideosTitle extends StatelessWidget {
  const PhotosAndVideosTitle({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
      height: Utils.appBarHeight,
      alignment: Alignment.center,
      decoration: const BoxDecoration(
        color: AppColor.textFieldUnSelect,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
              child: TopBackButton(
            alignment: Alignment.centerLeft,
            callback: () {
              if (context.canPop()) {
                context.pop();
              }
            },
          )),
          Consumer<PhotosAndVideosVm>(
            builder: (context, vm, _) {
              if (vm.otherMember != null) {
                return Text(
                  vm.otherMember!.nickname,
                  style: const TextStyle(
                      fontSize: 20,
                      color: AppColor.textFieldTitle,
                      height: 1.1),
                );
              } else {
                return Container();
              }
            },
          ),
          Expanded(child: Container())
        ],
      ),
    );
  }
}
