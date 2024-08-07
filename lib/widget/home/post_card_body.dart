import 'dart:convert';
import 'dart:developer';

import 'package:ashera_pet_new/routes/app_router.dart';
import 'package:ashera_pet_new/routes/route_name.dart';
import 'package:ashera_pet_new/widget/home/picture_carousal.dart';
import 'package:ashera_pet_new/widget/home/post_likes.dart';
import 'package:ashera_pet_new/widget/home/profile_slab.dart';
import 'package:cached_video_player_plus/cached_video_player_plus.dart';
import 'package:flutter/cupertino.dart';

import '../../model/post.dart';
import '../../utils/api.dart';
import '../../utils/app_color.dart';
import '../../utils/utils.dart';
import 'description.dart';
import 'interactive_comment_slab.dart';
import 'just_text_and_background.dart';
import 'package:screenshot/screenshot.dart';

class PostCardBody extends StatefulWidget {
  final PostModel postCardData;
  final bool isInView;

  const PostCardBody(
      {super.key, required this.postCardData, required this.isInView});

  @override
  State<StatefulWidget> createState() => _PostCardBodyState();
}

class _PostCardBodyState extends State<PostCardBody> {
  PostModel get postCardData => widget.postCardData;
  ScreenshotController screenshotController = ScreenshotController();
  CachedVideoPlayerPlusController? _controller;

  @override
  void initState() {
    super.initState();
    log('貼文 ${widget.postCardData.body} inView：${widget.isInView} imageUrl ${widget.postCardData.pics}');
    List<String> imageUrl =
        List<String>.from(json.decode(widget.postCardData.pics));
    if (imageUrl.isNotEmpty) {
      if (imageUrl.length <= 1) {
        if (Utils.videoFileVerification(imageUrl.first)) {
          if (AppRouter.currentLocation == RouteName.bottomNavigation ||
              AppRouter.currentLocation == RouteName.singlePost) {
            _controller = CachedVideoPlayerPlusController.networkUrl(
              Uri.parse(
                Utils.getFilePath(imageUrl.first),
              ),
              httpHeaders: {"authorization": "Bearer ${Api.accessToken}"},
            );
            if (widget.isInView) {
              _controller?.play();
            } else {
              _controller?.pause();
            }
          }
        }
      }
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    log('PostCord is Play:${postCardData.body} ${widget.isInView}');
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 5),
      padding: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
          color: AppColor.textFieldUnSelect,
          borderRadius: BorderRadius.circular(10)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //寵物資料
          ProfileSlab(
            userData: postCardData,
            controller: _controller,
          ),
          //圖片
          if (List.from(json.decode(postCardData.pics)).isNotEmpty)
            PictureCarousal(
              postCardData: postCardData,
              inView: widget.isInView,
              controller: _controller,
              routerName: RouteName.bottomNavigation,
            ),

          //顯示貼文背景與文章
          if (List.from(json.decode(postCardData.pics)).isEmpty)
            JustTextAndBackground(
              backgroundId: postCardData.postBackgroundId,
              text: postCardData.body,
              screenshotController: screenshotController,
            ),

          //按讚、留言、分享
          PostLikes(
            postCardData: postCardData,
            screenshotController: screenshotController,
          ),
          //文章內容
          if (List.from(json.decode(postCardData.pics)).isNotEmpty)
            Description(postCardData: postCardData),
          //留言
          InteractiveCommentSlab(postCardData: postCardData)
        ],
      ),
    );
  }
}
