import 'package:ashera_pet_new/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';

class UserPostGridViewTextItem extends StatefulWidget {
  final String text;
  final String imgUrl;

  const UserPostGridViewTextItem(
      {super.key, required this.text, required this.imgUrl});

  @override
  State<StatefulWidget> createState() => _UserPostGridViewTextItemState();
}

class _UserPostGridViewTextItemState extends State<UserPostGridViewTextItem>
    with AutomaticKeepAliveClientMixin {
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
        builder: (context, AsyncSnapshot<FileInfo> snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return Stack(
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
                  style: const TextStyle(color: Colors.black, fontSize: 16),
                )
              ],
            );
          }
          return Container();
        });
  }

  @override
  bool get wantKeepAlive => true;
}
