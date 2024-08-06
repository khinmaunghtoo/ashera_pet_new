import 'dart:convert';
import 'dart:developer';

import 'package:ashera_pet_new/utils/utils.dart';
import 'package:ashera_pet_new/view_model/post.dart';
import 'package:ashera_pet_new/widget/me/user_post_grid_view_pic_item.dart';
import 'package:ashera_pet_new/widget/me/user_post_grid_view_text_item.dart';
import 'package:ashera_pet_new/widget/me/user_post_grid_view_video_item.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../model/post.dart';
import '../../routes/route_name.dart';

//個人頁 - 照片
class UserPostGridView extends StatefulWidget {
  final List<PostModel> imgList;
  const UserPostGridView({super.key, required this.imgList});

  @override
  State<StatefulWidget> createState() => _UserPostGridViewState();
}

class _UserPostGridViewState extends State<UserPostGridView> {
  List<PostModel> get imgList => widget.imgList;

  @override
  Widget build(BuildContext context) {
    return SliverGrid(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3, crossAxisSpacing: 1, mainAxisSpacing: 1),
      delegate: SliverChildBuilderDelegate((context, index) {
        List<String> list = List<String>.from(json.decode(imgList[index].pics));
        if (list.isEmpty) {
          return _textWidget(
              index, imgList[index].body, imgList[index].postBackgroundId);
        }
        if (list.length > 1) {
          return _multiple(index, list);
        }
        return _leaflet(index, list);
      }, childCount: widget.imgList.length, addAutomaticKeepAlives: true),
    );
  }

  //多張
  Widget _multiple(int index, List<String> list) {
    String image = list.first;
    if (Utils.videoFileVerification(image)) {
      return UserPostGridViewVideoItem(
        data: imgList[index],
        url: image,
        isMultiple: true,
      );
    } else {
      return UserPostGridViewPicView(
          data: imgList[index], url: image, isMultiple: true);
    }
  }

  //單張
  Widget _leaflet(int index, List<String> list) {
    String image = list.first;
    if (Utils.videoFileVerification(image)) {
      log('影片：$image');
      return UserPostGridViewVideoItem(
        data: imgList[index],
        url: image,
        isMultiple: false,
      );
    } else {
      log('圖片：$image');
      return UserPostGridViewPicView(
          data: imgList[index], url: image, isMultiple: false);
    }
  }

  //純文字
  Widget _textWidget(int index, String text, int backgroundId) {
    return GestureDetector(
      onTap: () => context.push(RouteName.comments, extra: imgList[index]),
      child: Consumer<PostVm>(
        builder: (context, vm, _) {
          return UserPostGridViewTextItem(
            text: text,
            imgUrl: vm.postBackgroundLists
                .firstWhere((element) => element.id == backgroundId,
                    orElse: () => vm.postBackgroundLists.first)
                .pic,
          );
        },
      ),
    );
  }
}
