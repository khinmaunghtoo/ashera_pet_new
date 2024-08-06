import 'dart:convert';

import 'package:ashera_pet_new/data/member.dart';
import 'package:ashera_pet_new/model/post_message.dart';
import 'package:ashera_pet_new/widget/comments/picture_carousal.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../model/post.dart';
import '../../model/post_like.dart';
import '../../utils/app_color.dart';
import '../../view_model/comments_vm.dart';
import '../../view_model/post.dart';
import '../home/just_text_and_background.dart';
import '../new_post/user.dart';
import '../time_line/app_widget/favorite_icon.dart';
import 'item/item.dart';

//文章與留言
class DescriptionAndComments extends StatefulWidget {
  final ScrollController controller;
  final PostModel cardData;

  const DescriptionAndComments(
      {super.key, required this.controller, required this.cardData});

  @override
  State<StatefulWidget> createState() => _DescriptionAndCommentsState();
}

class _DescriptionAndCommentsState extends State<DescriptionAndComments> {
  ScrollController get controller => widget.controller;
  PostModel get cardData => widget.cardData;
  CommentsVm? _commentsVm;

  _onLayoutDone(_) {
    _commentsVm!.setScrollController(controller);
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(_onLayoutDone);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _commentsVm = Provider.of<CommentsVm>(context, listen: false);
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 20, horizontal: 15),
      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 0),
      decoration: BoxDecoration(
          color: AppColor.textFieldUnSelect,
          borderRadius: BorderRadius.circular(10)),
      child: CustomScrollView(
        controller: controller,
        slivers: [
          //貼文者與文章
          DescriptionAndCommentsHeard(
            cardData: cardData,
          ),
          //貼文
          Consumer<CommentsVm>(builder: (context, vm, _) {
            List<PostMessageModel> list = vm.postDataMessage
                .where((element) =>
                    element.postId == cardData.id && element.postMessageId == 0)
                .toList();
            if (vm.loading) {
              return const SliverFillRemaining(
                child: Center(
                  child: Text(
                    '留言載入中',
                    style: TextStyle(color: AppColor.textFieldTitle),
                  ),
                ),
              );
            }
            if (list.isEmpty) {
              //如果沒資料
              return const SliverFillRemaining(
                child: Center(
                  child: Text(
                    '目前還沒有留言',
                    style: TextStyle(color: AppColor.textFieldTitle),
                  ),
                ),
              );
            }
            return SliverAnimatedList(
                key: vm.commentKey,
                initialItemCount: list.length,
                itemBuilder: (context, index, animation) => CommentTile(
                      key: ValueKey('comment-${list[index].id}'),
                      model: list[index],
                    ));
          })
        ],
      ),
    );
  }
}

class DescriptionAndCommentsHeard extends StatelessWidget {
  final PostModel cardData;

  const DescriptionAndCommentsHeard({super.key, required this.cardData});

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: PostUserWidget(
              userData: cardData.member!,
              isSetting: true,
              postId: cardData.id,
            ),
          ),
          if (!List.from(json.decode(cardData.pics)).isNotEmpty)
            JustTextAndBackground(
              backgroundId: cardData.postBackgroundId,
              text: cardData.body,
            ),
          //圖片
          if (List.from(json.decode(cardData.pics)).isNotEmpty)
            CommentsPictureCarousal(
              inView: true,
              postCardData: cardData,
            ),

          _postLikes(),

          //文章
          if (List.from(json.decode(cardData.pics)).isNotEmpty)
            Container(
              padding: const EdgeInsets.only(top: 10, left: 15),
              child: _bodyText(),
            ),
          const SizedBox(
            height: 10,
          ),
        ],
      ),
    );
  }

  Widget _bodyText() {
    if (cardData.memberId != Member.memberModel.id) {
      return Text(
        cardData.body,
        style: const TextStyle(color: AppColor.textFieldHintText, fontSize: 14),
      );
    } else {
      return Consumer<PostVm>(
        builder: (context, vm, _) {
          return Text(
            vm.mePostData
                .firstWhere((element) => element.id == cardData.id)
                .body,
            style: const TextStyle(
                color: AppColor.textFieldHintText, fontSize: 14),
          );
        },
      );
    }
  }

  Widget _postLikes() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: Selector<CommentsVm, List<PostLikeModel>>(
        selector: (context, data) => data.postDataLike(cardData.id).toList(),
        shouldRebuild: (previous, next) => previous != next,
        builder: (context, list, _) {
          if (list.isEmpty) {
            return Consumer<CommentsVm>(
              builder: (context, vm, _) {
                return Row(
                  children: [
                    GestureDetector(
                        onTap: () => vm.addPostLike(cardData),
                        child: const Icon(
                          Icons.favorite_outline,
                          color: AppColor.textFieldTitle,
                          size: 22,
                        )),
                    const SizedBox(
                      width: 5,
                    ),
                    Text(
                      '${list.length}',
                      style: const TextStyle(color: Colors.white, fontSize: 14),
                    )
                  ],
                );
              },
            );
          }
          return Consumer<CommentsVm>(
            builder: (context, vm, _) {
              return Row(
                children: [
                  FavoriteIconButton(
                    isLiked: list
                        .where((element) =>
                            element.memberId == Member.memberModel.id &&
                            cardData.id == element.postId)
                        .isNotEmpty,
                    onTap: (liked) {
                      if (liked) {
                        vm.addPostLike(cardData);
                      } else {
                        vm.removePostLike(list
                            .where((element) =>
                                element.memberId == Member.memberModel.id &&
                                cardData.id == element.postId)
                            .first
                            .id);
                      }
                    },
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  Text(
                    '${vm.postDataLike(cardData.id).length}',
                    style: const TextStyle(color: Colors.white, fontSize: 14),
                  )
                ],
              );
            },
          );
        },
      ),
    );
  }
}
