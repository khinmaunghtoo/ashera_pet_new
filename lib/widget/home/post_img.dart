import 'package:flutter/cupertino.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';

import '../../utils/utils.dart';

class PostImg extends StatefulWidget{
  final int id;
  final String imgUrl;
  const PostImg({super.key, required this.id, required this.imgUrl});

  @override
  State<StatefulWidget> createState() => _PostImgState();
}

class _PostImgState extends State<PostImg> with AutomaticKeepAliveClientMixin{
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
              tag: 'img_${widget.id}',
              child: Image(
                fit: BoxFit.cover,
                image: FileImage(
                  snapshot.data!.file
                ),
              ),
            );
          }
          return Container();
        });
  }

  @override
  bool get wantKeepAlive => true;
}