import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:ashera_pet_new/model/post.dart';
import 'package:ashera_pet_new/widget/home/post_like_bottom_sheet.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svprogresshud/flutter_svprogresshud.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';

import '../../data/member.dart';
import '../../enum/share_post_setting.dart';
import '../../model/post_like.dart';
import '../../model/tuple.dart';
import '../../routes/route_name.dart';
import '../../utils/api.dart';
import '../../utils/app_color.dart';
import '../../utils/app_image.dart';
import '../../utils/utils.dart';
import '../../view_model/post.dart';
import '../time_line/app_widget/favorite_icon.dart';
import '../time_line/app_widget/tab_fade_image.dart';
import 'package:flutter/services.dart';
import 'package:screenshot/screenshot.dart';

class PostLikes extends StatefulWidget {
  final PostModel postCardData;
  final ScreenshotController screenshotController;
  const PostLikes({
    super.key,
    required this.postCardData,
    required this.screenshotController,
  });

  @override
  State<StatefulWidget> createState() => _PostLikesState();
}

class _PostLikesState extends State<PostLikes> {
  PostVm? _postVm;
  final EdgeInsets iconPadding =
      const EdgeInsets.symmetric(horizontal: 8, vertical: 4);
  final Color iconColor = AppColor.textFieldTitle;
  ScreenshotController get screenshotController => widget.screenshotController;

  @override
  Widget build(BuildContext context) {
    _postVm = Provider.of<PostVm>(context, listen: false);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const SizedBox(
              width: 4,
            ),
            //愛心
            Padding(
              padding: iconPadding,
              child: Selector<PostVm, List<PostLikeModel>>(
                selector: (context, data) => data.postDataLike.toList(),
                shouldRebuild: (previous, next) => previous != next,
                builder: (context, list, _) {
                  if (list.isEmpty) {
                    return GestureDetector(
                        onTap: () => _postVm!.addPostLike(widget.postCardData),
                        child: const Icon(
                          Icons.favorite_outline,
                          color: AppColor.textFieldTitle,
                          size: 22,
                        ));
                  }
                  log('這邊2？ ${widget.postCardData.body} ${list.where((element) => element.memberId == Member.memberModel.id && widget.postCardData.id == element.postId).isNotEmpty}');
                  return FavoriteIconButton(
                    key: UniqueKey(),
                    isLiked: list
                        .where((element) =>
                            element.memberId == Member.memberModel.id &&
                            widget.postCardData.id == element.postId)
                        .isNotEmpty,
                    onTap: (liked) {
                      if (liked) {
                        _postVm!.addPostLike(widget.postCardData);
                      } else {
                        _postVm!.removePostLike(list
                            .where((element) =>
                                element.memberId == Member.memberModel.id &&
                                widget.postCardData.id == element.postId)
                            .first
                            .id);
                      }
                    },
                  );
                },
              ),
            ),
            //留言
            Padding(
              padding: iconPadding,
              child: TapFadeImage(
                onTap: () => context.push(RouteName.comments,
                    extra: widget.postCardData),
                //icon: Icons.chat_bubble_outline,
                img: AppImage.iconMessage,
                iconColor: iconColor,
              ),
            ),

            //轉發
            Padding(
              padding: iconPadding,
              child: TapFadeImage(
                onTap: () => _showChooseAction(),
                //icon: Icons.near_me_outlined,
                img: AppImage.iconShare,
                iconColor: iconColor,
              ),
            ),

            //收藏 <-目前不用
          ],
        ),
        Consumer<PostVm>(
          builder: (context, vm, _) {
            List<PostLikeModel> list = vm.postDataLike
                .where((element) => element.postId == widget.postCardData.id)
                .toList();
            if (list.isNotEmpty) {
              return Padding(
                padding: const EdgeInsets.only(left: 15.0, top: 2.0),
                child: GestureDetector(
                  onTap: () => _showLikeMemberBottomSheet(list),
                  child: Text.rich(TextSpan(
                      text: '喜歡的人 ',
                      style: const TextStyle(
                          fontWeight: FontWeight.w300,
                          color: AppColor.textFieldHintText),
                      children: [
                        TextSpan(
                          text: list[0].member.nickname,
                          style: const TextStyle(
                              fontWeight: FontWeight.w500,
                              color: AppColor.textFieldTitle),
                        ),
                        if (list.length > 1 && list.length < 3) ...[
                          const TextSpan(text: ' 和 '),
                          TextSpan(
                              text: list[1].member.nickname,
                              style: const TextStyle(
                                  fontWeight: FontWeight.w500,
                                  color: AppColor.textFieldTitle))
                        ],
                        if (list.length >= 3) ...[
                          const TextSpan(
                              text: ' 和 ',
                              style:
                                  TextStyle(color: AppColor.textFieldHintText)),
                          TextSpan(
                              text: '其他${list.length - 1}人',
                              style: const TextStyle(
                                  color: AppColor.textFieldTitle,
                                  fontWeight: FontWeight.w500))
                        ]
                      ])),
                ),
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ],
    );
  }

  //選擇動作
  Future<void> _showChooseAction() async {
    SharePostSetting? value = await showCupertinoModalPopup(
        context: context,
        builder: (context) {
          return CupertinoActionSheet(
            actions: [
              /*CupertinoActionSheetAction(
                  onPressed: () => Navigator.pop(context, SharePostSetting.forward),
                  child: Text(SharePostSetting.forward.zh)),*/
              CupertinoActionSheetAction(
                  onPressed: () =>
                      Navigator.pop(context, SharePostSetting.share),
                  child: Text(SharePostSetting.share.zh)),
            ],
            cancelButton: CupertinoActionSheetAction(
              onPressed: () => Navigator.pop(context, SharePostSetting.cancel),
              isDefaultAction: true,
              child: Text(SharePostSetting.cancel.zh),
            ),
          );
        });

    if (value != null) {
      switch (value) {
        case SharePostSetting.share:
          SVProgressHUD.show();
          Tuple<bool, String> r =
              await _postVm!.getShareCode(widget.postCardData.id);
          //複製出來的分享碼 加上 url
          if (r.i1!) {
            //SVProgressHUD.dismiss();
            String shareUrl = Api.shareUrl(r.i2!);
            log('分享：$shareUrl');
            //內容是文字、圖片、影片
            if (List.from(json.decode(widget.postCardData.pics)).isNotEmpty) {
              //圖片、影片
              //下載圖片或影片
              List<String> imageUrl =
                  List<String>.from(json.decode(widget.postCardData.pics));
              if (imageUrl.isNotEmpty) {
                if (Utils.videoFileVerification(imageUrl.first)) {
                  if (Platform.isAndroid) {
                    SVProgressHUD.dismiss();
                    Share.share(shareUrl);
                  }
                  if (Platform.isIOS) {
                    Uint8List video = await Utils.getNetFile(imageUrl.first);
                    SVProgressHUD.dismiss();
                    Share.shareXFiles([
                      XFile.fromData(video,
                          name: 'post_text.png', mimeType: 'video/mp4')
                    ], text: shareUrl);
                  }
                } else if (Utils.imageFileVerification(imageUrl.first)) {
                  if (Platform.isAndroid) {
                    SVProgressHUD.dismiss();
                    Share.share(shareUrl);
                  }
                  if (Platform.isIOS) {
                    Uint8List image = await Utils.getNetFile(imageUrl.first);
                    SVProgressHUD.dismiss();
                    Share.shareXFiles([
                      XFile.fromData(image,
                          name: 'post_image.png', mimeType: 'image/png')
                    ], text: shareUrl);
                  }
                } else {
                  SVProgressHUD.dismiss();
                }
              }
            } else {
              //文字
              if (Platform.isAndroid) {
                SVProgressHUD.dismiss();
                Share.share(shareUrl);
              }
              if (Platform.isIOS) {
                Uint8List? image = await screenshotController.capture();
                SVProgressHUD.dismiss();
                if (image != null) {
                  Share.shareXFiles([
                    XFile.fromData(image,
                        name: 'post_text.png', mimeType: 'image/png')
                  ], text: shareUrl);
                }
              }
            }
            //Share.share(shareUrl);
          } else {
            SVProgressHUD.showSuccess(status: r.i2!);
          }
          break;
        case SharePostSetting.cancel:
          break;
        default:
          break;
      }
    }
  }

  //顯示喜歡的人
  void _showLikeMemberBottomSheet(List<PostLikeModel> postLikes) {
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
          top: Radius.circular(30),
        )),
        builder: (context) => DraggableScrollableSheet(
            initialChildSize: 0.4,
            maxChildSize: 0.9,
            minChildSize: 0.32,
            expand: false,
            snap: true,
            builder: (context, scrollController) => PostLikeBottomSheet(
                  controller: scrollController,
                  postLikes: postLikes,
                )));
  }
}
