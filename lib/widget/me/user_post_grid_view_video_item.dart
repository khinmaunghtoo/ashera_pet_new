import 'dart:io';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:path_provider/path_provider.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

import '../../model/post.dart';
import '../../routes/route_name.dart';
import '../../utils/api.dart';
import '../../utils/app_color.dart';
import '../../utils/utils.dart';

class UserPostGridViewVideoItem extends StatefulWidget {
  final PostModel data;
  final String url;
  final bool isMultiple;
  const UserPostGridViewVideoItem({
    super.key,
    required this.data,
    required this.url,
    required this.isMultiple
  });

  @override
  State<StatefulWidget> createState() => _UserPostGridViewVideoItemState();
}
class _UserPostGridViewVideoItemState extends State<UserPostGridViewVideoItem> with AutomaticKeepAliveClientMixin{
  PostModel get data => widget.data;
  String get url => widget.url;
  bool get isMultiple => widget.isMultiple;

  late Future<String?> _pic;

  @override
  void initState() {
    super.initState();
    _pic = _getFileImage(url);
  }

  //儲存影片暫存圖
  Future<String?> _getFileImage(String image) async {
    String keepFileName = image.split('/').last.toString().split('.').first;
    String path = '${(await getTemporaryDirectory()).path}/$keepFileName.jpg';
    if (await File(path).exists()) {
      return path;
    } else {
      return await VideoThumbnail.thumbnailFile(
        headers: {"authorization": "Bearer ${Api.accessToken}"},
        video: Utils.getFilePath(image),
        thumbnailPath: (await getTemporaryDirectory()).path,
        imageFormat: ImageFormat.JPEG,
        maxHeight: 350,
        quality: 100,
      ) ??
          '';
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return GestureDetector(
      onTap: () => context.push(RouteName.comments, extra: data),
      child: Stack(
        alignment: Alignment.center,
        fit: StackFit.expand,
        children: [
          FutureBuilder(
              future: _pic,
              builder: (context, AsyncSnapshot<String?> snapshot){
                switch (snapshot.connectionState) {
                  case ConnectionState.none:
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
                              '這張相片\n發生了一些問題！',
                              textAlign: TextAlign.center,
                              style: TextStyle(color: AppColor.textFieldTitle),
                            ),
                          )
                        ],
                      ),
                    );
                  case ConnectionState.waiting:
                    /*return Container(
                      alignment: Alignment.center,
                      padding:
                      const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                      child: const CircularProgressIndicator(
                        color: AppColor.textFieldHintText,
                      ),
                    );*/
                    return Container();
                  case ConnectionState.active:
                    return Image(
                      fit: BoxFit.cover,
                      gaplessPlayback: true,
                      image: FileImage(File(snapshot.data!)),
                    );
                  case ConnectionState.done:
                    if(snapshot.data == null){
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
                                '這張相片\n發生了一些問題！',
                                textAlign: TextAlign.center,
                                style: TextStyle(color: AppColor.textFieldTitle),
                              ),
                            )
                          ],
                        ),
                      );
                    }
                    return Image(
                      fit: BoxFit.cover,
                      gaplessPlayback: true,
                      image: FileImage(File(snapshot.data!)),
                    );
                }
              }
          ),
          if(isMultiple)
            const Positioned(
                top: 5,
                right: 5,
                child: Icon(
                  Icons.filter,
                  color: AppColor.textFieldTitle,
                  size: 20,
                ))
        ],
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}