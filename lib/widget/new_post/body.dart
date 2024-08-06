import 'dart:convert';
import 'dart:developer';

import 'package:ashera_pet_new/model/post.dart';
import 'package:ashera_pet_new/model/post_background_model.dart';
import 'package:ashera_pet_new/routes/route_name.dart';
import 'package:ashera_pet_new/utils/utils.dart';
import 'package:ashera_pet_new/view_model/post.dart';
import 'package:ashera_pet_new/widget/home/just_text_and_background.dart';
import 'package:ashera_pet_new/widget/new_post/text_background_img.dart';
import 'package:ashera_pet_new/widget/new_post/user.dart';
import 'package:cached_video_player_plus/cached_video_player_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../data/member.dart';
import '../../model/post_card_media.dart';
import '../../utils/api.dart';
import '../../utils/app_color.dart';
import '../edit_post/post_background_img.dart';
import '../home/picture_carousal.dart';
import '../text_field.dart';
import 'media_item.dart';

//* 發帖的body
class NewPostBody extends StatefulWidget {
  final FocusNode focusNodePostInput;
  final TextEditingController postInput;
  final List<PostCardMediaModel> postMediaList;
  final int sharedPostId;
  const NewPostBody(
      {super.key,
      required this.focusNodePostInput,
      required this.postInput,
      required this.postMediaList,
      required this.sharedPostId});

  @override
  State<StatefulWidget> createState() => _NewPostBodyState();
}

class _NewPostBodyState extends State<NewPostBody> {
  FocusNode get focusNodePostInput => widget.focusNodePostInput;
  TextEditingController get postInput => widget.postInput;
  List<PostCardMediaModel> get postMediaList => widget.postMediaList;
  int get sharedPostId => widget.sharedPostId;
  CachedVideoPlayerPlusController? _controller;
  PostVm? _postVm;

  _onLayoutDone(_) {
    //*? 為什麼發新的post，會有 postData?
    // 這個model肯定會是null
    // 這裡會報錯。
    PostModel model =
        _postVm!.postData.where((element) => element.id == sharedPostId).first;

    // 讀post的圖???
    List<String> imageUrl = List<String>.from(json.decode(model.pics));

    if (imageUrl.length <= 1) {
      // 這裡first也可能是null啊，因為上面是 <= 1 ?
      if (Utils.videoFileVerification(imageUrl.first)) {
        _controller = CachedVideoPlayerPlusController.networkUrl(
          Uri.parse(
            Utils.getFilePath(imageUrl.first),
          ),
          httpHeaders: {"authorization": "Bearer ${Api.accessToken}"},
        );
        _controller?.pause();
      }
    }
  }

  @override
  void initState() {
    super.initState();
    // WidgetsBinding.instance.addPostFrameCallback(_onLayoutDone);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _postVm = Provider.of<PostVm>(context, listen: false);
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
      decoration: BoxDecoration(
          color: AppColor.textFieldUnSelect,
          borderRadius: BorderRadius.circular(10)),
      child: SingleChildScrollView(
        padding: EdgeInsets.zero,
        child: SizedBox(
          height: _getHeight(),
          child: Column(
            children: [
              Flexible(
                  child: PostUserWidget(
                userData: Member.memberModel,
                isSetting: false,
              )),
              if (postMediaList.isEmpty)
                Flexible(
                  flex: 3,
                  child: Container(
                    margin: const EdgeInsets.only(top: 5),
                    child: Stack(
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
                            );
                          },
                        ),
                        JustTextPostInputField(
                          focusNode: focusNodePostInput,
                          controller: postInput,
                        ),
                      ],
                    ),
                  ),
                ),
              if (postMediaList.isEmpty)
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
                          return _postBackground(vm.postBackgroundLists[index]);
                        },
                        separatorBuilder: (context, index) {
                          return Container(
                            width: 10,
                          );
                        },
                      ),
                    );
                  },
                ),
              if (postMediaList.isNotEmpty)
                Flexible(
                    flex: 2,
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: PostInputTextField(
                        focusNode: focusNodePostInput,
                        controller: postInput,
                      ),
                    )),
              SizedBox(
                height: 85,
                child: ListView.separated(
                  addAutomaticKeepAlives: true,
                  padding: EdgeInsets.zero,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) {
                    log('index: $index ${postMediaList.length}');
                    return MediaItem(
                      key: ValueKey('post$index'),
                      model: index >= postMediaList.length
                          ? null
                          : postMediaList[index],
                      sharedPostId: sharedPostId,
                    );
                  },
                  itemCount: postMediaList.length + 1,
                  separatorBuilder: (context, index) {
                    return Container(
                      width: 5,
                    );
                  },
                ) /*GridView.builder(
                    addAutomaticKeepAlives: true,
                    padding: EdgeInsets.zero,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 4, childAspectRatio: 1.0),
                    itemCount: postMediaList.length + 1,
                    itemBuilder: (context, index) {
                      log('index: $index ${postMediaList.length}');
                      return MediaItem(
                        key: ValueKey('post$index'),
                        model: index >= postMediaList.length
                            ? null
                            : postMediaList[index],
                        sharedPostId: sharedPostId,
                      );
                    })*/
                ,
              ),
              if (sharedPostId != 0)
                Flexible(flex: 3, child: _otherMemberPost())
            ],
          ),
        ),
      ),
    );
  }

  double _getHeight() {
    if (postMediaList.isEmpty) {
      return MediaQuery.of(context).size.height + 90;
    } else {
      return MediaQuery.of(context).size.height;
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

  Widget _otherMemberPost() {
    return Consumer<PostVm>(
      builder: (context, vm, _) {
        if (vm.postData
            .where((element) => element.id == sharedPostId)
            .isEmpty) {
          return Container();
        }
        PostModel model =
            vm.postData.where((element) => element.id == sharedPostId).first;
        if (List.from(json.decode(model.pics)).isNotEmpty) {
          //圖片、影片
          return PictureCarousal(
            postCardData: model,
            inView: false,
            controller: _controller,
            routerName: RouteName.newPost,
          );
        } else {
          //文字
          return Container(
            child: JustTextAndBackground(
                backgroundId: model.postBackgroundId, text: model.body),
          );
        }
      },
    );
  }
}
