import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';

import '../../utils/utils.dart';

class NoSearchPostText extends StatefulWidget{
  final String imgUrl;
  final String text;
  const NoSearchPostText({super.key, required this.text, required this.imgUrl});

  @override
  State<StatefulWidget> createState() => _NoSearchPostTextState();
}

class _NoSearchPostTextState extends State<NoSearchPostText> with AutomaticKeepAliveClientMixin{
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
            return AspectRatio(aspectRatio: 1, child: Container(
              height: 230,
              alignment: Alignment.center,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Image.file(
                    snapshot.data!.file,
                    alignment: Alignment.center,
                  ),
                  Text(
                    widget.text,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                        color: Colors.black,
                        fontSize: 16
                    ),
                  )
                ],
              ),
            ));
          }
          return Container();
        });
  }

  @override
  bool get wantKeepAlive => true;
}