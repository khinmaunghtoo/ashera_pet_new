import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';

import 'package:ashera_pet_new/enum/me_bar.dart';
import 'package:ashera_pet_new/routes/route_name.dart';
import 'package:ashera_pet_new/view_model/bottom_drawer.dart';
import 'package:ashera_pet_new/widget/me/body.dart';
import 'package:ashera_pet_new/widget/me/title.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';

import '../../model/post_card_media.dart';
import '../../utils/app_color.dart';
import '../../widget/new_post/image_picker.dart';

// 設置頁面
class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<StatefulWidget> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage>
    with AutomaticKeepAliveClientMixin {
  BottomDrawerVm? _bottomDrawerVm;

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    _bottomDrawerVm = Provider.of<BottomDrawerVm>(context);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: AppColor.appBackground,
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SizedBox(
            height: constraints.maxHeight,
            width: constraints.maxWidth,
            child: GestureDetector(
              onTap: () => _bottomDrawerVm!.close(),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  //title
                  SettingsPageTitle(
                    callback: _barTap,
                  ),
                  Expanded(
                      child: SettingsPageBody(
                    callback: _editProfile,
                  )),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  //title bar選項
  void _barTap(MeBar bar) async {
    switch (bar) {
      case MeBar.newPost:
        //關閉選單
        _bottomDrawerVm!.close();
        /*List<AssetEntity>? result = await pickAssets();
        if (result != null) {
          _jumpToNewPostPage(result);
        }*/
        context.push(RouteName.newPost, extra: 0);
        break;
      case MeBar.menu:
        _bottomDrawerVm!.open();
        break;
    }
  }

  //編輯個人資料
  void _editProfile() {
    context.push(RouteName.editPetProfile);
  }

  //打開相簿選擇器
  Future<List<AssetEntity>?> pickAssets() async {
    final PermissionState ps = await AssetPicker.permissionCheck();

    const int maxAssets = 10;
    late final ThemeData theme = AssetPicker.themeData(AppColor.appBackground);

    // use always same provider for `keepScrollOffset`
    late final DefaultAssetPickerProvider provider = DefaultAssetPickerProvider(
      maxAssets: maxAssets,
      requestType: RequestType.common,
    );

    final InstaAssetPickerBuilder builder = InstaAssetPickerBuilder(
      provider: provider,
      initialPermission: ps,
      pickerTheme: theme,
      keepScrollOffset: false,
      locale: const Locale('zh', 'TW'),
    );
    if (context.mounted) {
      return await AssetPicker.pickAssetsWithDelegate(
        context,
        delegate: builder,
      );
    }
    return null;
  }

  void _jumpToNewPostPage(List<AssetEntity> result, [int? sharedPostId]) async {
    //一定要先複製一份 不然原本的會被清掉(目前不知道原因..
    List<AssetEntity> r = List.from(result);
    List<PostCardMediaModel> postMediaList = [];
    await Future.forEach(r, (element) async {
      log('${element.title}');
      File? file = await element.file;
      Uint8List? thumbnailData = await element.thumbnailData;
      postMediaList.add(PostCardMediaModel(
          title: element.title,
          typeInt: element.typeInt,
          height: element.height,
          width: element.width,
          duration: element.duration,
          file: file,
          thumbnailData: thumbnailData,
          sharedPostId: sharedPostId ?? 0));
    });
    if (context.mounted) context.push(RouteName.newPost, extra: postMediaList);
  }
}
