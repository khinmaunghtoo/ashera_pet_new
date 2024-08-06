import 'dart:developer';

import 'package:ashera_pet_new/view_model/post.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';

import '../../dialog/cupertion_alert.dart';
import '../../model/hero_view_params.dart';
import '../../model/post_card_media.dart';
import '../../routes/route_name.dart';
import '../../utils/app_color.dart';
import 'image_picker.dart';

class MediaItem extends StatefulWidget {
  final PostCardMediaModel? model;
  final int sharedPostId;
  const MediaItem({super.key, required this.model, required this.sharedPostId});

  @override
  State<StatefulWidget> createState() => _MediaItemState();
}

class _MediaItemState extends State<MediaItem>
    with AutomaticKeepAliveClientMixin {
  PostCardMediaModel? get model => widget.model;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    if (model == null) {
      return Consumer<PostVm>(
        builder: (context, vm, _) {
          return GestureDetector(
            onTap: () async {
              List<AssetEntity>? result = await pickAssets();
              if (result != null) {
                vm.setPostMediaList(result, widget.sharedPostId);
              }
            },
            child: AspectRatio(
              aspectRatio: 1,
              child: Container(
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.white, width: 3)),
                child: const Icon(
                  Icons.add,
                  color: Colors.white,
                  size: 20,
                ),
              ),
            ),
          );
        },
      );
    } else {
      switch (model?.type) {
        case AssetType.image:
          if (model?.file != null) {
            return Consumer<PostVm>(
              builder: (context, vm, _) {
                return Stack(
                  children: [
                    Container(
                      margin: const EdgeInsets.symmetric(
                          vertical: 2, horizontal: 0),
                      child: GestureDetector(
                        onTap: () => context.push(RouteName.fileHeroView,
                            extra: HeroViewParamsModel(
                                tag: 'post${model?.title}',
                                data: model?.file!,
                                index: 0)),
                        child: Hero(
                          tag: 'post${model?.title}',
                          child: Container(
                            alignment: Alignment.center,
                            child: Image(
                              fit: BoxFit.cover,
                              image: FileImage(model!.file!),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                        top: 0,
                        right: 0,
                        child: GestureDetector(
                          onTap: () async {
                            bool r = await _isDeleteImage();
                            if (r) {
                              //vm.postMediaList.remove(model);
                              vm.deleteThumbnailImage(model);
                            }
                          },
                          child: const Icon(
                            Icons.close,
                            color: Colors.red,
                            size: 20,
                          ),
                        )),
                  ],
                );
              },
            );
          } else {
            //如果沒有圖片
            return Container();
          }
        case AssetType.video:
          if (model?.thumbnailData != null) {
            return Consumer<PostVm>(
              builder: (context, vm, _) {
                return Stack(
                  children: [
                    Container(
                      margin: const EdgeInsets.symmetric(
                          vertical: 2, horizontal: 0),
                      child: GestureDetector(
                        onTap: () => context.push(RouteName.videoHeroView,
                            extra: HeroViewParamsModel(
                                tag: 'post${model?.title}',
                                data: model?.file!,
                                index: 0)),
                        child: Hero(
                          tag: 'post${model?.title}',
                          child: Container(
                            alignment: Alignment.center,
                            child: Image(
                              fit: BoxFit.cover,
                              image: MemoryImage(model!.thumbnailData!),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                        top: 0,
                        right: 0,
                        child: GestureDetector(
                          onTap: () async {
                            bool r = await _isDeleteImage();
                            if (r) {
                              //vm.postMediaList.remove(model);
                              vm.deleteThumbnailImage(model);
                            }
                          },
                          child: const Icon(
                            Icons.close,
                            color: Colors.red,
                            size: 20,
                          ),
                        )),
                  ],
                );
              },
            );
          } else {
            //如果沒有圖片
            return Container();
          }
        default:
          return Container();
      }
    }
  }

  @override
  bool get wantKeepAlive => true;

  //打開相簿選擇器
  Future<List<AssetEntity>?> pickAssets() async {
    late PermissionState ps;
    try {
      ps = await AssetPicker.permissionCheck();
    } catch (e) {
      log('this: ${e.toString()}');
      ps = PermissionState.denied;
    }
    if (ps == PermissionState.denied) {
      log('請至設定開啟權限');
      if (mounted) {
        await showCupertinoAlert(
          title: '提示',
          content: '請至設定開啟相簿權限',
          context: context,
          cancel: false,
          confirmation: true,
        );
      }
      return null;
    }

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

  Future<bool> _isDeleteImage() async {
    return await showCupertinoAlert(
        context: context,
        title: '刪除',
        content: '確認要刪除此相片？',
        cancel: true,
        confirmation: true);
  }

  Future<bool> _isDeleteVideo() async {
    return await showCupertinoAlert(
        context: context,
        title: '刪除',
        content: '確認要刪除此影片？',
        cancel: true,
        confirmation: true);
  }
}
