import 'package:ashera_pet_new/view_model/follower.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

import '../../widget/follower/body_list_follower_me.dart';

class FollowerMePage extends StatefulWidget {
  const FollowerMePage({super.key});

  @override
  State<StatefulWidget> createState() => _FollowerMePageState();
}

class _FollowerMePageState extends State<FollowerMePage> {
  @override
  Widget build(BuildContext context) {
    /*return Selector<FollowerVm, List<FollowerRequestModel>>(
      selector: (context, data) => data.followerMeList,
      shouldRebuild: (pre, next) => pre != next,
      builder: (context, list, _){
        return ListView.builder(
            padding: EdgeInsets.zero,
            addAutomaticKeepAlives: true,
            itemCount: list.length,
            itemBuilder: (context, index){
              return BodyListItem(
                targetId: list[index].memberId,
              );
            }
        );
      },
    );*/
    return Consumer<FollowerVm>(builder: (context, vm, _) {
      return ListView.builder(
        padding: EdgeInsets.zero,
        addAutomaticKeepAlives: true,
        itemCount: vm.followerMeList.length,
        itemBuilder: (context, index) {
          return BodyListFollowerMeItem(
            follower: vm.followerMeList[index],
          );
        },
      );
    });
  }
}
