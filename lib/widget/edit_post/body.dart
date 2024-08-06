import 'dart:convert';

import 'package:ashera_pet_new/widget/edit_post/post_background_img.dart';
import 'package:ashera_pet_new/widget/time_line/app_widget/avatars.dart';
import 'package:cached_video_player_plus/cached_video_player_plus.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../model/hero_view_params.dart';
import '../../model/member.dart';
import '../../model/post.dart';
import '../../model/post_background_model.dart';
import '../../routes/route_name.dart';
import '../../utils/api.dart';
import '../../utils/app_color.dart';
import '../../utils/utils.dart';
import '../../view_model/post.dart';
import '../home/post_img.dart';
import '../image_carousel/carousel.dart';
import '../new_post/text_background_img.dart';
import '../text_field.dart';
import '../video_widget.dart';

class EditPostBody extends StatefulWidget {
  final PostModel model;
  final TextEditingController postInput;
  final FocusNode focusNodePostInput;
  const EditPostBody(
      {super.key,
      required this.model,
      required this.postInput,
      required this.focusNodePostInput});

  @override
  State<StatefulWidget> createState() => _EditPostBodyState();
}

class _EditPostBodyState extends State<EditPostBody> {
  PostModel get model => widget.model;
  TextEditingController get postInput => widget.postInput;
  FocusNode get focusNodePostInput => widget.focusNodePostInput;

  late CachedVideoPlayerPlusController _controller;

  @override
  void initState() {
    super.initState();
    List<String> imageUrl = List<String>.from(json.decode(model.pics));
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
          _profileSlab(),
          //文章
          if (List.from(json.decode(model.pics)).isNotEmpty)
            Container(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: PostInputTextField(
                focusNode: focusNodePostInput,
                controller: postInput,
              ),
            ),
          //純文字
          if (List.from(json.decode(model.pics)).isEmpty)
            Flexible(
                flex: 3,
                child: Container(
                  margin: const EdgeInsets.only(top: 5),
                  child: Column(
                    children: [
                      Stack(
                        alignment: Alignment.center,
                        children: [
                          Consumer<PostVm>(
                            builder: (context, vm, _) {
                              return NewPostTextBackgroundImg(
                                imgUrl: vm.postBackgroundLists
                                    .firstWhere(
                                        (element) =>
                                            element.id == vm.postBackgroundId,
                                        orElse: () =>
                                            vm.postBackgroundLists.first)
                                    .pic,
                              ) /*Container(
                              width: MediaQuery.of(context).size.width,
                              height: 350,
                              alignment: Alignment.center,
                              child: CachedNetworkImage(
                                fit: BoxFit.cover,
                                imageUrl: Utils.getPublicPath(vm.postBackgroundLists.firstWhere((element) => element.id == vm.postBackgroundId, orElse: () => vm.postBackgroundLists.first).pic),
                                httpHeaders: {"authorization": "Bearer ${Api.accessToken}"},
                                fadeInDuration: const Duration(milliseconds: 0),
                                fadeOutDuration: const Duration(milliseconds: 0),
                              ),
                            )*/
                                  ;
                            },
                          ),
                          JustTextPostInputField(
                            focusNode: focusNodePostInput,
                            controller: postInput,
                          ),
                        ],
                      ),
                      if (List.from(json.decode(model.pics)).isEmpty)
                        Consumer<PostVm>(
                          builder: (context, vm, _) {
                            if (vm.postBackgroundLists.isEmpty) {
                              return Container();
                            }
                            return SizedBox(
                              height: 50,
                              child: ListView.separated(
                                padding: EdgeInsets.zero,
                                scrollDirection: Axis.horizontal,
                                itemCount: vm.postBackgroundLists.length,
                                itemBuilder: (context, index) {
                                  return _postBackground(
                                      vm.postBackgroundLists[index]);
                                },
                                separatorBuilder: (context, index) {
                                  return Container(
                                    width: 10,
                                  );
                                },
                              ),
                            );
                          },
                        )
                    ],
                  ),
                )),
          //圖片
          if (List.from(json.decode(model.pics)).isNotEmpty)
            Flexible(
                child: Visibility(
                    visible: !focusNodePostInput.hasFocus,
                    child: _pictureCarousal())),
        ],
      ),
    );
  }

  Widget _profileSlab() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Row(
        children: [
          Avatar.medium(user: MemberModel.fromMap(model.member!.toMap())),
          Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: Text(
              model.member!.nickname,
              style: const TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                  fontWeight: FontWeight.w500),
            ),
          ),
          //性別icon
          Utils.genderIcon(model.member!.gender),
        ],
      ),
    );
  }

  Widget _pictureCarousal() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ..._pictureCarousel(context),
      ],
    );
  }

  List<Widget> _pictureCarousel(BuildContext context) {
    List<String> imageUrl = List<String>.from(json.decode(model.pics));
    double aspectRatio = 1; //widget.postCardData.aspectRatio;
    return [
      //圖片!! 這部分要修改了 單張 多張 GIF 影片
      Flexible(
          child: Padding(
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
      )),
    ];
  }

  //判斷是影片還是圖片Widget
  Widget _dataWidget(List<String> urlList) {
    //單張 不要用空值判斷
    if (urlList.length <= 1) {
      String url = urlList.first;
      if (Utils.videoFileVerification(url)) {
        //video
        //點了要能放大影片
        return GestureDetector(
          onTap: () {
            context.push(RouteName.netWorkVideoHeroView,
                extra: HeroViewParamsModel(
                    tag: 'video-${model.id}', data: url, index: 0));
          },
          child: VideoWidget(
            key: ValueKey('post-${model.id}'),
            videoController: _controller,
            play: false,
            controller: false,
            volume: 0.0,
            isShare: true,
            bottom: 5,
          ),
        );
      } else if (Utils.imageFileVerification(url)) {
        //image
        return GestureDetector(
          onTap: () {
            context.push(RouteName.netWorkImageHeroView,
                extra: HeroViewParamsModel(
                    tag: 'img_${model.id}', data: url, index: 0));
          },
          child: PostImg(
            id: model.id,
            imgUrl: url,
          ),
        );
      } else {
        return Container();
      }
    } else {
      //多張
      return Carousel(
        tag: 'post-${model.id}',
        imagePaths: urlList,
        inView: false,
      );
    }
  }

  Widget _postBackground(PostBackgroundModel model) {
    return Consumer<PostVm>(
      builder: (context, vm, _) {
        return GestureDetector(
          onTap: () => vm.setPostBackground(model.id),
          child: Container(
            width: 40,
            height: 40,
            alignment: Alignment.center,
            child: PostBackgroundImg(
              imgUrl: model.pic.substring(1, model.pic.length),
            ),
          ),
        );
      },
    );
  }
}
