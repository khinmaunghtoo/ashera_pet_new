import 'dart:convert';

import 'package:ashera_pet_new/view_model/ranking_classification.dart';
import 'package:ashera_pet_new/view_model/video_vm.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cached_video_player_plus/cached_video_player_plus.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../model/ranking_message.dart';
import '../../routes/route_name.dart';
import '../../utils/api.dart';
import '../../utils/app_color.dart';
import '../../utils/app_image.dart';
import '../../utils/utils.dart';
import '../image_carousel/carousel.dart';
import '../time_line/app_widget/favorite_icon.dart';
import '../time_line/app_widget/tab_fade_image.dart';
import '../video_widget.dart';

///圖片 愛心 留言 分享 喜歡這則貼文的人
class RankPictureCarousal extends StatefulWidget {
  final bool inView;
  final RankingMessageModel postCardData;

  const RankPictureCarousal(
      {super.key, required this.inView, required this.postCardData});

  @override
  State<StatefulWidget> createState() => _RankPictureCarousalState();
}

class _RankPictureCarousalState extends State<RankPictureCarousal>
    with AutomaticKeepAliveClientMixin {
  late CachedVideoPlayerPlusController _controller;

  @override
  void initState() {
    super.initState();
    List<String> imageUrl =
        List<String>.from(json.decode(widget.postCardData.pics));
    if (imageUrl.isNotEmpty) {
      if (imageUrl.length <= 1) {
        if (Utils.videoFileVerification(imageUrl.first)) {
          _controller = CachedVideoPlayerPlusController.networkUrl(
            Uri.parse(
              Utils.getFilePath(imageUrl.first),
            ),
            httpHeaders: {"authorization": "Bearer ${Api.accessToken}"},
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ..._pictureCarousel(context), /*_likes()*/
      ],
    );
  }

  List<Widget> _pictureCarousel(BuildContext context) {
    const iconPadding = EdgeInsets.symmetric(horizontal: 8, vertical: 4);
    var imageUrl = List<String>.from(json.decode(widget.postCardData.pics));
    double aspectRatio = 1; //widget.postCardData.aspectRatio;
    const iconColor = AppColor.textFieldTitle;
    return [
      //圖片!! 這部分要修改了 單張 多張 GIF 影片
      if (imageUrl.isNotEmpty)
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxHeight: 500),
              child: AspectRatio(
                aspectRatio: aspectRatio,
                child: Container(
                  clipBehavior: Clip.hardEdge,
                  decoration:
                      BoxDecoration(borderRadius: BorderRadius.circular(5)),
                  child: _dataWidget(imageUrl),
                ),
              ),
            ),
          ),
        ),
      if (imageUrl.isEmpty)
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxHeight: 500),
              child: AspectRatio(
                aspectRatio: aspectRatio,
                child: Container(
                  alignment: Alignment.center,
                  clipBehavior: Clip.hardEdge,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: AppColor.textOnlyBackground),
                  child: Text(
                    /*widget.postCardData.post != null ?*/ widget
                        .postCardData.post!.body /* : ''*/,
                    maxLines: 2,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                    ),
                    //widget.postCardData
                  ),
                ),
              ),
            ),
          ),
        ),

      //愛心 留言 分享 收藏
      Consumer<RankingClassificationVm>(
        builder: (context, vm, _) {
          return Row(
            children: [
              const SizedBox(
                width: 4,
              ),
              //愛心
              Column(
                children: [
                  Padding(
                    padding: iconPadding,
                    child: FavoriteIconButton(
                      isLiked: true,
                      onTap: (liked) => context.push(RouteName.comments,
                          extra: widget.postCardData
                              .post) /*context.push(RouteName.singlePost, extra: '${widget.postCardData.postId}')*/,
                    ),
                  ),
                  //數字
                  _numberText(widget.postCardData.likeCnt)
                ],
              ),

              //留言
              Column(
                children: [
                  Padding(
                    padding: iconPadding,
                    child: TapFadeImage(
                      onTap: () => context.push(RouteName.comments,
                          extra: widget.postCardData
                              .post) /*context.push(RouteName.singlePost, extra: '${widget.postCardData.postId}')*/,
                      //icon: Icons.chat_bubble_outline,
                      img: AppImage.iconMessage,
                      iconColor: iconColor,
                    ),
                  ),
                  //數字
                  _numberText(widget.postCardData.messageCnt)
                ],
              ),

              //轉發
              Column(
                children: [
                  Padding(
                    padding: iconPadding,
                    child: TapFadeImage(
                      onTap: () => context.push(RouteName.comments,
                          extra: widget.postCardData
                              .post) /*context.push(RouteName.singlePost, extra: '${widget.postCardData.postId}')*/,
                      img: AppImage.iconShare,
                      iconColor: iconColor,
                    ),
                  ),
                  //數字
                  _numberText(widget.postCardData.sharePostCnt)
                ],
              ),

              //收藏 <-目前不用
            ],
          );
        },
      )
    ];
  }

  Widget _likes() {
    return Container();
    /*if (likeReactions.isNotEmpty) {
      return Padding(
        padding: const EdgeInsets.only(left: 15.0, top: 2.0),
        child: Text.rich(TextSpan(
            text: '喜歡的人 ',
            style: const TextStyle(
                fontWeight: FontWeight.w300, color: AppColor.textFieldHintText),
            children: [
              TextSpan(
                text: likeReactions[0].nickname,
                style: const TextStyle(
                    fontWeight: FontWeight.w500,
                    color: AppColor.textFieldTitle),
              ),
              if (likeCount > 1 && likeCount < 3) ...[
                const TextSpan(text: ' 和 '),
                TextSpan(
                    text: likeReactions[1].nickname,
                    style: const TextStyle(
                        fontWeight: FontWeight.w500,
                        color: AppColor.textFieldTitle))
              ],
              if (likeCount >= 3) ...[
                const TextSpan(
                    text: ' 和 ',
                    style: TextStyle(color: AppColor.textFieldHintText)),
                TextSpan(
                    text: '其他${likeCount - 1}人',
                    style: const TextStyle(
                        color: AppColor.textFieldTitle,
                        fontWeight: FontWeight.w500))
              ]
            ])),
      );
    } else {
      return const SizedBox.shrink();
    }*/
  }

  Widget _numberText(int number) {
    return FittedBox(
      fit: BoxFit.scaleDown,
      child: Text(
        Utils.getNumberOfPeople(number),
        style: const TextStyle(
          color: AppColor.textFieldTitle,
        ),
      ),
    );
  }

  //判斷是影片還是圖片Widget
  Widget _dataWidget(List<String> urlList) {
    //單張 不要用空值判斷
    if (urlList.length <= 1) {
      String url = urlList.first;
      if (Utils.videoFileVerification(url)) {
        //video
        return Consumer<VideoVm>(
          builder: (context, vm, _) {
            return VideoWidget(
              key: ValueKey('post-${widget.postCardData.id}'),
              videoController: _controller,
              play: widget.inView,
              controller: false,
              volume: vm.volume,
              isShare: false,
              bottom: 5,
            );
          },
        );
      } else if (Utils.imageFileVerification(url)) {
        //image
        return CachedNetworkImage(
          imageUrl: Utils.getFilePath(url),
          httpHeaders: {"authorization": "Bearer ${Api.accessToken}"},
          imageBuilder: (context, img) {
            return Image(
              fit: BoxFit.cover,
              image: img,
            );
          },
          errorWidget: (context, url, error) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(
                    Icons.priority_high,
                    size: 40,
                    color: AppColor.required,
                  ),
                  FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      '這張相片\n發生了一些問題！',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: AppColor.textFieldTitle),
                    ),
                  )
                ],
              ),
            );
          },
        );
      } else {
        return Container();
      }
    } else {
      //多張
      return Carousel(
        tag: 'post-${widget.postCardData.id}',
        imagePaths: urlList,
        inView: widget.inView,
      );
    }
  }

  @override
  bool get wantKeepAlive => true;
}
