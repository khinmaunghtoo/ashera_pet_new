import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';

import '../../utils/app_color.dart';
import '../../utils/utils.dart';

class PostPic extends StatefulWidget {
  final int id;
  final String imgUrl;
  final bool isMultiple;
  const PostPic({super.key, required this.id, required this.imgUrl, required this.isMultiple});

  @override
  State<StatefulWidget> createState() => _PostPicState();
}

class _PostPicState extends State<PostPic> with AutomaticKeepAliveClientMixin{
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
        builder: (context, AsyncSnapshot<FileInfo> snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return SizedBox(
              height: 280,
              child: Hero(
                  tag: 'avatar${widget.id}',
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxHeight: 300),
                    child: Stack(
                      alignment: Alignment.center,
                      fit: StackFit.expand,
                      children: [
                        Image(
                          fit: BoxFit.cover,
                          image: FileImage(
                            snapshot.data!.file
                          ),
                        ),
                        if(widget.isMultiple)
                          const Positioned(
                              top: 5,
                              right: 5,
                              child: Icon(
                                Icons.filter,
                                color: AppColor.textFieldTitle,
                                size: 20,
                              )
                          )
                      ],
                    )),
              )
            );
          }
          return Container();
        });
  }

  @override
  bool get wantKeepAlive => true;
}
