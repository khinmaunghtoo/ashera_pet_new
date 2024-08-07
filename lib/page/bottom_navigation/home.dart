import 'dart:developer';
import 'dart:io';

import 'package:ashera_pet_new/enum/home_bar.dart';
import 'package:ashera_pet_new/page/bottom_navigation/home/notify.dart';
import 'package:ashera_pet_new/page/bottom_navigation/home/search.dart';
import 'package:ashera_pet_new/routes/app_router.dart';
import 'package:ashera_pet_new/view_model/bottom_bar.dart';
import 'package:ashera_pet_new/view_model/notify.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';

import '../../dialog/cupertion_alert.dart';
import '../../model/post.dart';
import '../../model/post_card_media.dart';
import '../../routes/route_name.dart';
import '../../utils/app_color.dart';
import '../../view_model/member.dart';
import '../../view_model/post.dart';
import '../../widget/home/body.dart';
import '../../widget/home/title.dart';
import '../../widget/new_post/image_picker.dart';

//* 首頁, tab view的 第一個 page
class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  State<StatefulWidget> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with AutomaticKeepAliveClientMixin {
  PostVm? _postVm;
  NotifyVm? _notifyVm;
  MemberVm? _memberVm;
  BottomBarVm? _bottomBarProvider;

  ScrollController scrollController = ScrollController();

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    //*? 問題是, 每scroll一次都會重新設置一次controller????
    _bottomBarProvider!.setHomeScrollController(scrollController);
    if (scrollController.position.pixels == 0.0) {
      _postVm!.showBackTop(false);
    }
    if (scrollController.position.pixels >= 800) {
      _postVm!.showBackTop(true);
    }
    if (scrollController.offset == scrollController.position.maxScrollExtent) {
      log('到達底部');
      _postVm!.setOffset();
    }

    //*? 問題是, 每scroll一次都會重新設置一次controller????
    _postVm!.setHomeScrollController(scrollController);

    _postVm!.setPixels(scrollController.position.pixels);
  }

  @override
  void dispose() {
    scrollController.removeListener(_onScroll);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    _postVm = Provider.of<PostVm>(context, listen: false);
    _notifyVm = Provider.of<NotifyVm>(context, listen: false);
    _memberVm = Provider.of<MemberVm>(context, listen: false);
    _bottomBarProvider = Provider.of<BottomBarVm>(context, listen: false);
    log('Home刷新');
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
                HomeTitle(
                  callback: _barTap,
                ),

                // body
                Expanded(
                    child: Selector<PostVm, List<PostModel>>(
                  selector: (context, postVM) => postVM.postData.toList(),
                  shouldRebuild: (previous, next) => previous != next,
                  builder: (context, list, _) {
                    //*? 為什麼會判斷這裡？ 判斷不是bottomNavigation?
                    // 不是bottomNavigation, 不可能來到這個頁面吧？
                    if (AppRouter.currentLocation !=
                        RouteName.bottomNavigation) {
                      log('回傳空畫面');
                      return Container();
                    }

                    // 沒有貼文
                    if (list.isEmpty) {
                      return const Center(
                        child: Text(
                          '目前還沒有貼文',
                          style: TextStyle(color: AppColor.textFieldTitle),
                        ),
                      );
                    }

                    // body
                    return Container(
                      padding:
                          const EdgeInsets.only(top: 5, right: 15, left: 15),
                      child: HomeBody(
                        list: list,
                        atLast: _postVm!.atLast,
                        controller: scrollController,
                      ),
                    );
                  },
                ))
              ],
            ),
          );
        },
      ),
      floatingActionButton: Consumer<PostVm>(
        builder: (context, vm, _) {
          return Offstage(
            offstage: !vm.isShowBackTop,
            child: FloatingActionButton(
              heroTag: 'btn1',
              backgroundColor: Colors.blue,
              onPressed: () {
                scrollController.animateTo(0.0,
                    duration: const Duration(milliseconds: 500),
                    curve: Curves.decelerate);
              },
              child: const Icon(
                Icons.vertical_align_top_outlined,
                color: Colors.white,
              ),
            ),
          );
        },
      ),
    );
  }

  void _barTap(HomeBar bar) async {
    switch (bar) {
      case HomeBar.newPost:
        context.push(RouteName.newPost, extra: 0);
        break;
      case HomeBar.search:
        await context.push(RouteName.search);
        await Future.delayed(const Duration(milliseconds: 300));
        _postVm!.jumpToPixels();
        break;
      case HomeBar.notify:
        //通知
        //await _notifyVm!.getMessageNotifyPage();
        await _notifyVm!.getMessageNotify();
        if (mounted) await context.push(RouteName.notify);
        await Future.delayed(const Duration(milliseconds: 300));
        _postVm!.jumpToPixels();
        await _memberVm!.updateMessageNotifyStatus();
        break;
    }
  }

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

  void _showSearch() async {
    showDialog(
      context: context,
      builder: (BuildContext context) => const SearchPage(),
    );
  }

  void _showNotify() async {
    await _notifyVm!.getMessageNotifyPage();
    await showDialog(
      context: context,
      builder: (BuildContext context) => const NotifyPage(),
    );
    await _memberVm!.updateMessageNotifyStatus();
  }
}
