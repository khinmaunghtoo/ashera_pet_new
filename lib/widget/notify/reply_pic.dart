import 'package:flutter/cupertino.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';

import '../../utils/utils.dart';

class ReplyPic extends StatefulWidget{
  final String imgUrl;
  const ReplyPic({super.key, required this.imgUrl});

  @override
  State<StatefulWidget> createState() => _ReplyPicState();
}

class _ReplyPicState extends State<ReplyPic> with AutomaticKeepAliveClientMixin{
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
            return Image(
              width: 50,
              height: 50,
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