import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

import '../../view_model/follower.dart';
import '../../widget/follower/body_list_item.dart';

class MyFollowerPage extends StatefulWidget{
  const MyFollowerPage({super.key});

  @override
  State<StatefulWidget> createState() => _MyFollowerPageState();
}
class _MyFollowerPageState extends State<MyFollowerPage>{
  @override
  Widget build(BuildContext context) {
    return Consumer<FollowerVm>(builder: (context, vm, _){
      return ListView.builder(
          padding: EdgeInsets.zero,
          addAutomaticKeepAlives: true,
          itemCount: vm.myFollowerList.length,
          itemBuilder: (context, index){
            return BodyListItem(
              targetId: vm.myFollowerList[index].followerId,
            );
          }
      );
    },);
    /*return Selector<FollowerVm, List<FollowerRequestModel>>(
      selector: (context, data) => data.myFollowerList,
      shouldRebuild: (pre, next) => pre != next,
      builder: (context, list, _){
        return ListView.builder(
            padding: EdgeInsets.zero,
            addAutomaticKeepAlives: true,
            itemCount: list.length,
            itemBuilder: (context, index){
              return BodyListItem(
                targetId: list[index].followerId,
              );
            }
        );
      },
    );*/
  }
}