import 'package:ashera_pet_new/widget/me/animted_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:go_router/go_router.dart';

import '../../model/post.dart';
import '../../routes/route_name.dart';
import '../../utils/app_color.dart';
import '../../utils/utils.dart';

class UserPostGridViewPicView extends StatefulWidget {
  final PostModel data;
  final String url;
  final bool isMultiple;
  const UserPostGridViewPicView(
      {super.key,
      required this.data,
      required this.url,
      required this.isMultiple});

  @override
  State<StatefulWidget> createState() => _UserPostGridViewPicViewState();
}

class _UserPostGridViewPicViewState extends State<UserPostGridViewPicView>
    with AutomaticKeepAliveClientMixin {
  PostModel get data => widget.data;
  String get url => widget.url;
  bool get isMultiple => widget.isMultiple;

  OverlayEntry? _popupDialog;
  late Future<FileInfo> _file;

  Future<FileInfo> _fileInfo() async {
    return await Utils.getFileCacheManager(url);
  }

  @override
  void initState() {
    super.initState();
    _file = _fileInfo();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return GestureDetector(
      onTap: () => context.push(RouteName.comments, extra: data),
      onLongPress: () => _onLongPress(),
      onLongPressEnd: (_) => _popupDialog?.remove(),
      child: Stack(
        alignment: Alignment.center,
        fit: StackFit.expand,
        children: [
          FutureBuilder(
              future: _file,
              builder: (context, AsyncSnapshot<FileInfo> snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  if (snapshot.data != null) {
                    return Image(
                      fit: BoxFit.cover,
                      image: FileImage(snapshot.data!.file),
                    );
                  } else {
                    return const Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.priority_high,
                            size: 40,
                            color: AppColor.required,
                          ),
                          FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Text(
                              '這張相片\n發生了一些問題！',
                              textAlign: TextAlign.center,
                              style: TextStyle(color: AppColor.textFieldTitle),
                            ),
                          )
                        ],
                      ),
                    );
                  }
                }
                return Container();
              }),
          if (isMultiple)
            const Positioned(
                top: 5,
                right: 5,
                child: Icon(
                  Icons.filter,
                  color: AppColor.textFieldTitle,
                  size: 20,
                ))
        ],
      ),
    );
  }

  void _onLongPress() {
    _popupDialog = _createPopupDialog(url);
    Overlay.of(context).insert(_popupDialog!);
  }

  OverlayEntry _createPopupDialog(String url) {
    return OverlayEntry(
        builder: (context) => AnimatedDialog(child: _createPopupContent()));
  }

  Widget _createPopupContent() => Container(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(15),
          child: FutureBuilder(
              future: _file,
              builder: (context, AsyncSnapshot<FileInfo> snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  return Image(
                    fit: BoxFit.cover,
                    image: FileImage(snapshot.data!.file),
                  );
                }
                return Container();
              }),
        ),
      );

  @override
  bool get wantKeepAlive => true;
}
