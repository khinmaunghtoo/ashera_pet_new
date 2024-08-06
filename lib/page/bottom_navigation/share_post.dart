import 'package:ashera_pet_new/utils/api.dart';
import 'package:ashera_pet_new/utils/app_color.dart';
import 'package:ashera_pet_new/widget/share_post/body.dart';
import 'package:ashera_pet_new/widget/system_back.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../model/post.dart';
import '../../model/tuple.dart';
import '../../widget/share_post/title.dart';

//分享的文章
class SharePost extends StatefulWidget {
  final String postId;

  const SharePost({super.key, required this.postId});

  @override
  State<StatefulWidget> createState() => _SharePostState();
}

class _SharePostState extends State<SharePost> {
  String get postId => widget.postId;

  ScrollController controller = ScrollController();

  late Future<PostModel?> _post;

  @override
  void initState() {
    super.initState();
    _post = _getPostByPostId();
  }

  Future<PostModel?> _getPostByPostId() async {
    Tuple<bool, String> r = await Api.getPostByIdNotIso(int.parse(postId));
    //Tuple<bool, String> r = await Api.getPostById(int.parse(postId));
    if (r.i1!) {
      return PostModel.fromJson(r.i2!);
    } else {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
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
                SharePostTitle(
                  callback: _back,
                ),
                //body
                Expanded(
                    child: Container(
                  padding: const EdgeInsets.only(top: 5, right: 15, left: 15),
                  child: FutureBuilder(
                    future: _post,
                    builder: (context, snapshot) {
                      switch (snapshot.connectionState) {
                        case ConnectionState.done:
                          return SharePostBody(
                            list: [snapshot.data!],
                            controller: controller,
                          );
                        default:
                          return Container();
                      }
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
