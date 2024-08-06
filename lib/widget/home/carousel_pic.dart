import 'package:flutter/cupertino.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';

import '../../utils/utils.dart';

class CarouselPic extends StatefulWidget{
  final String tag;
  final String imgUrl;

  const CarouselPic({super.key, required this.tag, required this.imgUrl});

  @override
  State<StatefulWidget> createState() => _CarouselPicState();
}

class _CarouselPicState extends State<CarouselPic> with AutomaticKeepAliveClientMixin{
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
    return FutureBuilder(
        future: _file,
        builder: (context, AsyncSnapshot<FileInfo> snapshot){
          if(snapshot.connectionState == ConnectionState.done){
            return Hero(
              tag: widget.tag,
              child: Image(
                fit: BoxFit.cover,
                image: FileImage(
                    snapshot.data!.file
                ),
              ),
            );
          }
          return Container();
        }
    );
  }

  @override
  bool get wantKeepAlive => true;
}