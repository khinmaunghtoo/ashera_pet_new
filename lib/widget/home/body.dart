import 'dart:developer';

import 'package:ashera_pet_new/model/post.dart';
import 'package:ashera_pet_new/view_model/post.dart';
import 'package:ashera_pet_new/widget/home/post_card.dart';
import 'package:flutter/material.dart';
import 'package:inview_notifier_list/inview_notifier_list.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh_pro/pull_to_refresh_pro.dart';

// home page body
class HomeBody extends StatefulWidget {
  final List<PostModel> list;
  final ScrollController controller;
  final bool atLast;
  const HomeBody(
      {super.key,
      required this.list,
      required this.controller,
      required this.atLast});

  @override
  State<StatefulWidget> createState() => _HomeBodyState();
}

class _HomeBodyState extends State<HomeBody> {
  List<PostModel> get list => widget.list;
  ScrollController get controller => widget.controller;
  bool get atLast => widget.atLast;

  //*? 沒用到
  PostVm? _postVm;

  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  //*? 沒用到
  void _onRefresh() async {
    // monitor network fetch
    //await Future.delayed(const Duration(milliseconds: 1000));
    // if failed,use refreshFailed()
    log('onRefresh');
    bool r = await _postVm!.findAllByPage0Desc();
    if (r) {
      _refreshController.refreshCompleted();
    } else {
      _refreshController.refreshFailed();
    }
  }

  //*? 沒用到
  void _onLoading() async {
    // monitor network fetch
    await Future.delayed(const Duration(milliseconds: 1000));
    // if failed,use loadFailed(),if no data return,use LoadNodata()
    log('onLoading');
    _refreshController.loadComplete();
  }

  @override
  Widget build(BuildContext context) {
    //*? 沒用到
    _postVm = Provider.of<PostVm>(context, listen: false);

    return InViewNotifierList(
      controller: controller,
      padding: EdgeInsets.zero,
      physics: const ClampingScrollPhysics(),
      scrollDirection: Axis.vertical,
      addAutomaticKeepAlives: true,
      isInViewPortCondition:
          (double deltaTop, double deltaBottom, double viewPortDimension) {
        return deltaTop < (0.3 * viewPortDimension) &&
            deltaBottom > (0.7 * viewPortDimension);
      },
      itemCount: atLast ? list.length : list.length + 1,
      builder: (context, index) {
        if (index < list.length) {
          return PostCard(
            key: ValueKey('post-${list[index].id}'),
            postCardData: list[index],
          );
        }
        return Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.all(10.0),
          margin: const EdgeInsets.only(bottom: 30),
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                '載入中..',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(
                width: 10,
              ),
              SizedBox(
                width: 30,
                height: 30,
                child: CircularProgressIndicator(
                  strokeWidth: 1,
                ),
              )
            ],
          ),
        );
      },
    );
  }
}
