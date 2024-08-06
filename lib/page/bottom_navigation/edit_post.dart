import 'dart:developer';

import 'package:ashera_pet_new/model/post.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svprogresshud/flutter_svprogresshud.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../model/tuple.dart';
import '../../utils/api.dart';
import '../../utils/app_color.dart';
import '../../view_model/post.dart';
import '../../widget/edit_post/body.dart';
import '../../widget/edit_post/title.dart';

class EditPostPage extends StatefulWidget {
  final PostModel model;
  const EditPostPage({super.key, required this.model});

  @override
  State<StatefulWidget> createState() => _EditPostPageState();
}

class _EditPostPageState extends State<EditPostPage> {
  PostVm? _postVm;
  PostModel get model => widget.model;

  FocusNode focusNodePostInput = FocusNode();
  final TextEditingController _postInput = TextEditingController();

  String oldText = '';

  @override
  void initState() {
    super.initState();
    _postInput.text = model.body;
    setState(() {});
    oldText = model.body;
  }

  @override
  Widget build(BuildContext context) {
    _postVm = Provider.of<PostVm>(context, listen: false);
    return Scaffold(
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
                EditPostTitle(
                  callback: _back,
                  doneCallBack: _done,
                ),
                //body
                Expanded(
                    child: EditPostBody(
                  model: model,
                  postInput: _postInput,
                  focusNodePostInput: focusNodePostInput,
                ))
              ],
            ),
          );
        },
      ),
    );
  }

  void _back() {
    if (mounted) context.pop();
  }

  void _done() async {
    if (mounted) SVProgressHUD.show();
    PostModel dto = model.copyWith(
        body: _postInput.text, postBackgroundId: _postVm!.postBackgroundId);
    Tuple<bool, String> r = await _editPostApi(dto);
    if (r.i1!) {
      log('替換內容外部：${dto.body}');
      _postVm!.setPostBody(dto);
      if (mounted) SVProgressHUD.dismiss();
      if (mounted) context.pop();
    } else {
      SVProgressHUD.dismiss();
      SVProgressHUD.showError(status: r.i2!);
    }
  }

  Future<Tuple<bool, String>> _editPostApi(PostModel dto) async {
    if (_postInput.text.trim().isEmpty) {
      return Tuple(false, '內文請勿空白');
    }
    Tuple<bool, String> r = await Api.editPost(dto.editPost());
    return r;
  }
}
