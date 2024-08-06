import 'package:flutter/cupertino.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';

import '../../utils/utils.dart';

class PostBackgroundImg extends StatefulWidget{
  final String imgUrl;
  const PostBackgroundImg({super.key, required this.imgUrl});

  @override
  State<StatefulWidget> createState() => _PostBackgroundImgState();
}

class _PostBackgroundImgState extends State<PostBackgroundImg> with AutomaticKeepAliveClientMixin{
  late Future<FileInfo> _file;
  Future<FileInfo> _fileInfo() async {
    return await Utils.getBackgroundPicCacheManager(widget.imgUrl);
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
            return Image(
              fit: BoxFit.cover,
              image: FileImage(
                snapshot.data!.file
              ),
            );
          }
          return Container();
        });
  }

  @override
  bool get wantKeepAlive => true;
}