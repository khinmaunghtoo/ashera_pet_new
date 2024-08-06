import 'package:flutter/cupertino.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:photo_view/photo_view.dart';

import '../../../utils/utils.dart';

class PhotoAndVideoViewPic extends StatefulWidget{
  final String imgUrl;
  const PhotoAndVideoViewPic({super.key, required this.imgUrl});

  @override
  State<StatefulWidget> createState() => _PhotoAndVideoViewPicState();
}

class _PhotoAndVideoViewPicState extends State<PhotoAndVideoViewPic> with AutomaticKeepAliveClientMixin{
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
    super.build(context);
    return FutureBuilder(future: _file,
        builder: (context, AsyncSnapshot<FileInfo> snapshot){
          if(snapshot.connectionState == ConnectionState.done){
            return PhotoView(
                minScale: PhotoViewComputedScale.contained,
                imageProvider: FileImage(
                  snapshot.data!.file
                )
            );
          }
          return Container();
        });
  }
  @override
  bool get wantKeepAlive => true;
}