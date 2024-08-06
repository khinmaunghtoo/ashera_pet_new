import 'package:ashera_pet_new/model/follower.dart';
import 'package:ashera_pet_new/widget/follower/body_list_item.dart';
import 'package:flutter/cupertino.dart';

class OtherPetFollowerMe extends StatefulWidget {
  final List<FollowerRequestModel> followerMe;
  const OtherPetFollowerMe({super.key, required this.followerMe});

  @override
  State<StatefulWidget> createState() => _OtherPetFollowerMeState();
}

class _OtherPetFollowerMeState extends State<OtherPetFollowerMe> {
  List<FollowerRequestModel> get followerMe => widget.followerMe;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        padding: EdgeInsets.zero,
        addAutomaticKeepAlives: true,
        itemCount: followerMe.length,
        itemBuilder: (context, index) {
          return BodyListItem(targetId: followerMe[index].memberId);
        });
  }
}
