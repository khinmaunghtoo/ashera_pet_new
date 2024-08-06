import 'package:flutter/cupertino.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';

import '../../utils/utils.dart';

class NewPostTextBackgroundImg extends StatefulWidget{
  final String imgUrl;
  const NewPostTextBackgroundImg({super.key, required this.imgUrl});

  @override
  State<StatefulWidget> createState() => _NewPostTextBackgroundImgState();
}

class _NewPostTextBackgroundImgState extends State<NewPostTextBackgroundImg> with AutomaticKeepAliveClientMixin{
  late Future<FileInfo> _file;
  Future<FileInfo> _fileInfo() async {
    return await Utils.getBackgroundPicCacheManager(widget.imgUrl);
  }


  @override
  Widget build(BuildContext context) {
    super.build(context);
    return FutureBuilder(
        future: _fileInfo(),
        builder: (context, AsyncSnapshot<FileInfo> snapshot){
          if(snapshot.connectionState == ConnectionState.done){
            return Container(
              width: MediaQuery.of(context).size.width,
              height: 350,
              alignment: Alignment.center,
              child: Image(
                fit: BoxFit.cover,
                image: FileImage(
                  snapshot.data!.file,
                ),
              ),
            );
          }
          return SizedBox(
            width: MediaQuery.of(context).size.width,
            height: 350,
          );
        });
  }

  @override
  bool get wantKeepAlive => true;
}