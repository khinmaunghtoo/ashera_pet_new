import 'package:ashera_pet_new/widget/share_post/body.dart';
import 'package:ashera_pet_new/widget/single_post/title.dart';
import 'package:ashera_pet_new/widget/system_back.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../utils/app_color.dart';
import '../../../view_model/comments_vm.dart';

class SinglePost extends StatefulWidget {
  final String postId;

  const SinglePost({super.key, required this.postId});

  @override
  State<StatefulWidget> createState() => _SinglePostState();
}

class _SinglePostState extends State<SinglePost> {
  CommentsVm? _commentsVm;
  String get postId => widget.postId;

  ScrollController controller = ScrollController();

  _onLayoutDone(_) {
    _commentsVm!.getSinglePostById(int.parse(postId));
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(_onLayoutDone);
  }

  @override
  Widget build(BuildContext context) {
    _commentsVm = Provider.of<CommentsVm>(context);
    return SystemBack(
        child: Scaffold(
      resizeToAvoidBottomInset: false,
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
                SinglePostTitle(
                  callback: _back,
                ),
                //body
                Expanded(
                    child: Container(
                  padding: const EdgeInsets.only(top: 5, right: 15, left: 15),
                  child: Consumer<CommentsVm>(
                    builder: (context, vm, _) {
                      if (vm.postData
                          .where((element) => element.id == int.parse(postId))
                          .isEmpty) {
                        return Container();
                      }
                      return SharePostBody(list: [
                        vm.postData
                            .where((element) => element.id == int.parse(postId))
                            .first
                      ], controller: controller);
                    },
                  ),
                ))
              ],
            ),
          );
        },
      ),
    ));
  }

  //返回
  void _back() {
    context.pop();
  }
}
