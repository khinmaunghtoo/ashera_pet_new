import 'package:flutter/cupertino.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:photo_view/photo_view.dart';

import '../../utils/utils.dart';

class HeroViewPic extends StatefulWidget{
  final String tag;
  final String imgUrl;
  const HeroViewPic({super.key, required this.tag, required this.imgUrl});

  @override
  State<StatefulWidget> createState() => _HeroViewPicState();
}

class _HeroViewPicState extends State<HeroViewPic>{
  late Future<FileInfo> _file;

  Future<FileInfo> _fileInfo() async {
    return await Utils.getFileCacheManager(widget.imgUrl);
  }

  @override
  void initState() {
    super.initState();
    _file = _fileInfo();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _file,
        builder: (context, AsyncSnapshot<FileInfo> snapshot){
          if(snapshot.connectionState == ConnectionState.done){
            return Hero(
              tag: widget.tag,
              child: PhotoView(
                minScale: PhotoViewComputedScale.contained,
                imageProvider: FileImage(snapshot.data!.file) /*CachedNetworkImageProvider(
                  Utils.getFilePath(paramsModel.data as String),
                  headers: {"authorization": "Bearer ${Api.accessToken}"},
                )*/,
              ),
            );
          }
          return Container();
        });
  }

}