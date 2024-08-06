import 'dart:io';

import 'package:ashera_pet_new/model/hero_view_params.dart';
import 'package:cached_video_player_plus/cached_video_player_plus.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../utils/app_color.dart';
import '../../utils/utils.dart';
import '../back_button.dart';

class VideoHeroView extends StatefulWidget {
  final HeroViewParamsModel paramsModel;
  const VideoHeroView({super.key, required this.paramsModel});
  @override
  State<StatefulWidget> createState() => _VideoHeroViewState();
}

class _VideoHeroViewState extends State<VideoHeroView> {
  HeroViewParamsModel get paramsModel => widget.paramsModel;
  late CachedVideoPlayerPlusController _controller;
  late Future<void> _initializeVideoPlayerFuture;

  @override
  void initState() {
    super.initState();
    _controller =
        CachedVideoPlayerPlusController.file(paramsModel.data as File);
    _initializeVideoPlayerFuture = _controller.initialize().then((value) {
      _controller.setVolume(0.0);
      _controller.play();
    });
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.appBackground,
      resizeToAvoidBottomInset: false,
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SizedBox(
            height: constraints.maxHeight,
            width: constraints.maxWidth,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                //title
                _title(),
                Expanded(
                  child: Center(
                    child: Hero(
                        tag: paramsModel.tag,
                        child: FutureBuilder(
                            future: _initializeVideoPlayerFuture,
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.done) {
                                return GestureDetector(
                                  onTap: () => _onTap(),
                                  child: AspectRatio(
                                    aspectRatio: _controller.value.aspectRatio,
                                    child: CachedVideoPlayerPlus(_controller),
                                  ),
                                );
                              } else {
                                return const Center(
                                  child: CircularProgressIndicator(
                                      color: AppColor.textFieldHintText),
                                );
                              }
                            })),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _title() {
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
            callback: () => context.pop(),
          )),
          Expanded(child: Container())
        ],
      ),
    );
  }

  void _onTap() {
    setState(() {
      _controller.value.isPlaying ? _controller.pause() : _controller.play();
    });
  }
}
