import 'dart:io';

import 'package:ashera_pet_new/data/member.dart';
import 'package:ashera_pet_new/model/post.dart';
import 'package:ashera_pet_new/utils/app_color.dart';
import 'package:ashera_pet_new/widget/system_back.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svprogresshud/flutter_svprogresshud.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';
import '../../../dialog/cupertion_alert.dart';
import '../../../view_model/post.dart';
import '../../../widget/new_post/body.dart';
import '../../../widget/new_post/title.dart';

class NewPostPage extends StatefulWidget {
  final int sharedPostId;
  const NewPostPage({super.key, required this.sharedPostId});

  @override
  State<StatefulWidget> createState() => _NewPostPageState();
}

class _NewPostPageState extends State<NewPostPage> {
  PostVm? _postVm;
  FocusNode focusNodePostInput = FocusNode();
  final TextEditingController _postInput = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void didUpdateWidget(oldWidget) {
    super.didUpdateWidget(oldWidget);
    //防止鍵盤聚焦
    FocusScopeNode currentFocus = FocusScope.of(context);
    if (!currentFocus.hasPrimaryFocus) {
      currentFocus.focusedChild?.unfocus();
    }
  }

  @override
  Widget build(BuildContext context) {
    _postVm = Provider.of<PostVm>(context, listen: false);
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
                NewPostTitle(
                  callback: _back,
                  postCallback: _newPost,
                  cropCallback: _cropImage,
                ),
                Expanded(child: Consumer<PostVm>(
                  builder: (context, vm, _) {
                    return NewPostBody(
                        focusNodePostInput: focusNodePostInput,
                        postInput: _postInput,
                        postMediaList: vm.postMediaList,
                        sharedPostId: widget.sharedPostId);
                  },
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
    _postVm!.closeNewPost();
    context.pop();
  }

  //圖片裁切
  void _cropImage() async {
    if (_postVm!.postMediaList.isEmpty) {
      _showAlert('未選擇圖片');
      return;
    }
    if (_postVm!.postMediaList
        .where((element) => element.typeInt == AssetType.video.index)
        .isNotEmpty) {
      //有影片 需先提示影片無法裁切
      bool r = await showCupertinoAlert(
          context: context,
          title: '裁切',
          content: '選擇的檔案中有影片，影片目前無法裁切是否繼續？',
          cancel: true,
          confirmation: true);
      if (r) {
        //繼續
        List<File> cropFile = [];
        _postVm!.postMediaList.forEach((element) async {
          if (element.file != null) {
            if (element.typeInt != AssetType.video.index) {
              cropFile.add(element.file!);
            }
          }
        });
        // TODO: 這個套件有問題
        // MultiImageCrop.startCropping(
        //     context: context,
        //     files: _cropFile,
        //     aspectRatio: 1,
        //     callBack: (List<File> images) => _postVm!.setCropPostMediaList(images)
        // );
      }
    } else {
      //直接進入裁切
      List<File> cropFile = [];
      _postVm!.postMediaList.forEach((element) async {
        if (element.file != null) {
          cropFile.add(element.file!);
        }
      });

      // TODO: 這個套件有問題
      // MultiImageCrop.startCropping(
      //     context: context,
      //     files: _cropFile,
      //     aspectRatio: 1,
      //     callBack: (List<File> images) => _postVm!.setCropPostMediaList(images)
      // );
    }
  }

  //發布貼文
  void _newPost() async {
    if (await _judgmentData()) {
      return;
    }

    SVProgressHUD.show();
    PostModel dto = PostModel(
        body: _postInput.text,
        disableMessage: false,
        memberId: Member.memberModel.id,
        pics: await _postVm!.getPics(_postVm!.postMediaList),
        publish: true,
        sharePostId: widget.sharedPostId,
        postBackgroundId: _postVm!.postBackgroundId);
    bool? r = await _postVm!.addNewPost(dto);
    if (r != null) {
      if (r) {
        _uploadPostSuccess();
      } else {
        _uploadPostFail();
      }
    } else {
      _uploadPostFail();
    }
  }

  void _uploadPostSuccess() async {
    SVProgressHUD.dismiss();
    await _showAlert('上傳完成');
    if (mounted) context.pop();
  }

  void _uploadPostFail() async {
    SVProgressHUD.dismiss();
    await _showAlert('上傳失敗');
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<bool> _judgmentData() async {
    if (_postInput.text.trim().isEmpty) {
      return await _showAlert('文章內容不可為空');
    }
    await Future.forEach(_postVm!.postMediaList, (element) async {
      if (element.file != null) {
        double sizeInBytes = element.file!.lengthSync() / (1024 * 1024);
        if (sizeInBytes > 50) {
          return await _showAlert('檔案過大請重新選擇或刪除現有影片或照片');
        }
      }
    });
    return false;
  }

  Future<bool> _showAlert(String text) async {
    Future.delayed(const Duration(milliseconds: 1800),
        () => Navigator.of(context).pop(true));
    return await showCupertinoAlert(
        context: context, content: text, cancel: false, confirmation: false);
  }
}
