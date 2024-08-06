import 'package:ashera_pet_new/view_model/video_vm.dart';
import 'package:ashera_pet_new/widget/video_widget.dart';
import 'package:cached_video_player_plus/cached_video_player_plus.dart';
import 'package:dismissible_page/dismissible_page.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../model/hero_view_params.dart';
import '../utils/api.dart';
import '../utils/app_color.dart';
import '../utils/utils.dart';
import 'back_button.dart';

class NetworkVideoHeroView extends StatefulWidget {
  final HeroViewParamsModel paramsModel;
  const NetworkVideoHeroView({super.key, required this.paramsModel});

  @override
  State<StatefulWidget> createState() => _NetworkVideoHeroViewState();
}

class _NetworkVideoHeroViewState extends State<NetworkVideoHeroView> {
  late CachedVideoPlayerPlusController _controller;

  @override
  void initState() {
    super.initState();
    _controller = CachedVideoPlayerPlusController.networkUrl(
      Uri.parse(
        Utils.getFilePath(widget.paramsModel.data),
      ),
      httpHeaders: {"authorization": "Bearer ${Api.accessToken}"},
    );
  }

  @override
  Widget build(BuildContext context) {
    return DismissiblePage(
        onDismissed: () => context.pop(),
        child: Scaffold(
          backgroundColor: AppColor.appBackground,
          resizeToAvoidBottomInset: false,
          body: LayoutBuilder(
            builder: (context, constraints) {
              return Container(
                height: constraints.maxHeight,
                width: constraints.maxWidth,
                padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).padding.bottom),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    _title(context),
                    Expanded(
                        child: Hero(
                      tag: widget.paramsModel.tag,
                      child: Consumer<VideoVm>(
                        builder: (context, vm, _) {
                          return VideoWidget(
                            videoController: _controller,
                            play: true,
                            controller: true,
                            volume: vm.volume,
                            isShare: false,
                            bottom: 15,
                            duration: widget.paramsModel.duration,
                          );
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

  Widget _title(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
      height: Utils.appBarHeight,
      alignment: Alignment.center,
      decoration: const BoxDecoration(color: AppColor.textFieldUnSelect),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
              child: TopCloseBackButton(
            alignment: Alignment.centerLeft,
            callback: () =>
                context.pop(_controller.value.position.inMilliseconds.round()),
          )),
          Expanded(child: Container())
        ],
      ),
    );
  }
}
