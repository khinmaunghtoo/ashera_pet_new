import 'dart:convert';
import 'dart:developer';

import 'package:ashera_pet_new/utils/app_color.dart';
import 'package:ashera_pet_new/widget/me/user_post_grid_view.dart';
import 'package:ashera_pet_new/widget/search_pet/profile_header.dart';
import 'package:flutter/cupertino.dart';

import '../../model/member.dart';
import '../../model/post.dart';
import '../../model/tuple.dart';
import '../../utils/api.dart';

class SearchPetBody extends StatefulWidget {
  final MemberModel userData;
  const SearchPetBody({super.key, required this.userData});

  @override
  State<StatefulWidget> createState() => _SearchPetBodyState();
}

class _SearchPetBodyState extends State<SearchPetBody> {
  MemberModel get userData => widget.userData;
  late Future<List<PostModel>> mePostData;

  @override
  void initState() {
    super.initState();
    mePostData = _getPostModel();
    log('其他人是這頁嗎？${userData.toMap()}');
  }

  Future<List<PostModel>> _getPostModel() async {
    Tuple<bool, String> r = await Api.getPostByMemberId(userData.id);
    if (r.i1!) {
      log('對方：${r.i2}');
      List list = json.decode(r.i2!);
      List<PostModel> postModels =
          List.from(list.map((e) => PostModel.fromMap(e)).toList());
      postModels.sort((f, l) => l.createdAt.compareTo(f.createdAt));
      return postModels;
    }
    return [];
  }

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        //其他寵物
        SliverToBoxAdapter(
          child: SearchPetProfileHeader(
            userData: userData,
          ),
        ),
        FutureBuilder(
            future: mePostData,
            builder: (context, snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.none:
                  return const SliverFillRemaining(
                    child: Center(
                      child: Text(
                        '目前還沒有貼文',
                        style: TextStyle(color: AppColor.textFieldTitle),
                      ),
                    ),
                  );
                case ConnectionState.waiting:
                  return const SliverFillRemaining(
                    child: Center(
                      child: Text(
                        '貼文載入中',
                        style: TextStyle(color: AppColor.textFieldTitle),
                      ),
                    ),
                  );
                case ConnectionState.active:
                  return const SliverFillRemaining(
                    child: Center(
                      child: Text(
                        '貼文載入中',
                        style: TextStyle(color: AppColor.textFieldTitle),
                      ),
                    ),
                  );
                case ConnectionState.done:
                  if (snapshot.data!.isEmpty) {
                    //沒資料
                    return const SliverFillRemaining(
                      child: Center(
                        child: Text(
                          '目前還沒有貼文',
                          style: TextStyle(color: AppColor.textFieldTitle),
                        ),
                      ),
                    );
                  }
                  //有資料
                  return UserPostGridView(imgList: snapshot.data!);
              }
            }),
      ],
    );
  }
}
