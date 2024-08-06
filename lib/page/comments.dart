import 'package:ashera_pet_new/widget/system_back.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../model/post.dart';
import '../utils/app_color.dart';
import '../view_model/comments_vm.dart';
import '../view_model/post.dart';
import '../widget/comments/body.dart';
import '../widget/comments/title.dart';

class CommentsPage extends StatefulWidget {
  final PostModel postCardData;
  const CommentsPage({super.key, required this.postCardData});

  @override
  State<StatefulWidget> createState() => _CommentsPageState();
}

class _CommentsPageState extends State<CommentsPage> {
  PostVm? _postVm;
  CommentsVm? _commentsVm;

  _onLayoutDone(_) async {
    _commentsVm!.setPostData(_postVm!.postData);
    await Future.delayed(const Duration(milliseconds: 100));
    //防止原本有點開回覆子留言
    _commentsVm!.setParentId(null);

    _commentsVm!.getSinglePostById(widget.postCardData.id);
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(_onLayoutDone);
  }

  @override
  Widget build(BuildContext context) {
    _postVm = Provider.of<PostVm>(context, listen: false);
    _commentsVm = Provider.of<CommentsVm>(context, listen: false);
    return SystemBack(
        child: Scaffold(
      resizeToAvoidBottomInset: true,
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
                CommentsTitle(
                  callback: _back,
                ),
                Expanded(
                    child: CommentsBody(
                  postCardData: widget.postCardData,
                ))
              ],
            ),
          );
        },
      ),
    ));
  }

  void _back() {
    _postVm!.getSinglePostById(widget.postCardData.id);
    _commentsVm!.setScrollController(null);
    context.pop();
  }
}
