import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';

import '../../utils/utils.dart';

class ReplyTextPostBackground extends StatefulWidget{
  final String imgUrl;
  final String text;
  const ReplyTextPostBackground({super.key, required this.imgUrl, required this.text});

  @override
  State<StatefulWidget> createState() => _ReplyTextPostBackgroundState();
}

class _ReplyTextPostBackgroundState extends State<ReplyTextPostBackground> with AutomaticKeepAliveClientMixin{
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
            return Container(
              height: 50,
              width: 50,
              alignment: Alignment.center,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Image.file(
                    snapshot.data!.file,
                    alignment: Alignment.center,
                  ),
                  FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      widget.text,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                          color: Colors.black,
                          fontSize: 16
                      ),
                    ),
                  )
                ],
              ),
            );
          }
          return Container();
        });
  }
  @override
  bool get wantKeepAlive => true;
}