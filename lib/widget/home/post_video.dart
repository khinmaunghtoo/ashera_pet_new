import 'package:cached_video_player_plus/cached_video_player_plus.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../utils/app_color.dart';
import '../../view_model/video_vm.dart';

class PostVideoWidget extends StatefulWidget{
  final CachedVideoPlayerPlusController? videoController;
  final bool play;
  final bool controller;
  final double volume;
  final bool isShare;
  final double bottom;

  const PostVideoWidget({
    super.key,
    required this.videoController,
    required this.play,
    required this.controller,
    required this.volume,
    required this.isShare,
    required this.bottom
  });

  @override
  State<StatefulWidget> createState() =>_PostVideoWidgetState();
}

class _PostVideoWidgetState extends State<PostVideoWidget>{
  CachedVideoPlayerPlusController? get _controller => widget.videoController;
  Future<void>? _initializeVideoPlayerFuture;
  bool playVideo = false;
  double get volume => widget.volume;
  bool get isShare => widget.isShare;
  double get bottom => widget.bottom;
  VideoVm? _videoVm;

  _onLayoutDone(_){
    _videoVm!.addListener(_listener);
  }
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(_onLayoutDone);
    if(_controller != null){
      _initializeVideoPlayerFuture = _controller!.initialize().then((value) {
        _controller!.setVolume(volume);
        //_controller.play();
        _controller!.setLooping(true);
      });
    }
  }

  @override
  void didUpdateWidget(covariant PostVideoWidget oldWidget) {
    if(oldWidget.play != widget.play){
      if(widget.play){
        _controller?.play();
        _controller?.setLooping(true);
      } else {
        _controller?.pause();
      }
    }
    super.didUpdateWidget(oldWidget);
  }

  void _listener(){
    _controller?.setVolume(_videoVm!.volume);
  }

  @override
  void dispose() {
    _videoVm!.removeListener(_listener);
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _videoVm = Provider.of(context);
    return Stack(
      alignment: Alignment.center,
      children: [
        FutureBuilder(
            future: _initializeVideoPlayerFuture,
            builder: (context, snapshot){
              if(snapshot.connectionState == ConnectionState.done){
                if(snapshot.error == null){
                  return GestureDetector(
                    onTap: widget.controller ? (){
                      setState(() {
                        _controller!.value.isPlaying
                            ? _controller?.pause()
                            : _controller?.play();
                      });
                    } : null,
                    child: SizedBox(
                      width: 365.4,
                      height: 365.4,
                      child: FittedBox(
                        fit: BoxFit.cover,
                        clipBehavior: Clip.hardEdge,
                        child: SizedBox(
                          width: _controller?.value.size.width != 0
                              ? _controller?.value.size.width
                              : 365.4,
                          height: _controller?.value.size.height != 0
                              ? _controller?.value.size.height
                              : 365.4,
                          child: AspectRatio(
                              aspectRatio: 1,
                              child: CachedVideoPlayerPlus(_controller!)
                          ),
                        ),
                      ),
                    ),
                  );
                } else {
                  return const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.priority_high,
                          size: 40,
                          color: AppColor.required,
                        ),
                        FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Text(
                            '這部影片\n發生了一些問題！',
                            textAlign: TextAlign.center,
                            style: TextStyle(color: AppColor.textFieldTitle),
                          ),
                        )
                      ],
                    ),
                  );
                }
              } else {
                return const Center(
                  child: CircularProgressIndicator(color: AppColor.textFieldHintText),
                );
              }
            }
        ),
        Positioned(
            right: 5,
            bottom: bottom,
            child: Visibility(
              visible: !isShare,
              child: Consumer<VideoVm>(builder: (context, vm, _){
                return GestureDetector(
                  onTap: () => vm.setMute(!vm.isMute),
                  child: Container(
                    alignment: Alignment.center,
                    padding: const EdgeInsets.all(5),
                    decoration: const BoxDecoration(
                        color: AppColor.itemBackgroundColor,
                        shape: BoxShape.circle
                    ),
                    child: Icon(
                      vm.isMute ? Icons.volume_off : Icons.volume_up,
                      color: Colors.white,
                    ),
                  ),
                );
              },),
            )
        )
      ],
    );
  }
}