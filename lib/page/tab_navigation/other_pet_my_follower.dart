import 'package:ashera_pet_new/widget/follower/body_list_item.dart';
import 'package:flutter/cupertino.dart';

import '../../model/follower.dart';

class OtherPetMyFollower extends StatefulWidget {
  final List<FollowerRequestModel> myFollower;
  const OtherPetMyFollower({super.key, required this.myFollower});

  @override
  State<StatefulWidget> createState() => _OtherPetMyFollowerState();
}

class _OtherPetMyFollowerState extends State<OtherPetMyFollower> {
  List<FollowerRequestModel> get myFollower => widget.myFollower;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        padding: EdgeInsets.zero,
        addAutomaticKeepAlives: true,
        itemCount: myFollower.length,
        itemBuilder: (context, index) {
          return BodyListItem(targetId: myFollower[index].followerId);
        });
  }
}
