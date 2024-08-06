import 'package:ashera_pet_new/page/tab_navigation/other_pet_follower_me.dart';
import 'package:ashera_pet_new/page/tab_navigation/other_pet_my_follower.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

import '../../enum/tab_bar.dart';
import '../../model/follower.dart';
import '../../utils/app_color.dart';
import '../../view_model/tab_bar.dart';

class OtherPetFollowerBody extends StatefulWidget {
  final OtherPetFollowerModel data;
  const OtherPetFollowerBody({super.key, required this.data});

  @override
  State<StatefulWidget> createState() => _OtherPetFollowerBodyState();
}

class _OtherPetFollowerBodyState extends State<OtherPetFollowerBody> {
  OtherPetFollowerModel get data => widget.data;

  TabBarVm? _barVm;
  late PageController _controller;

  final List<Widget> _children = [];

  _onLayoutDone(_) {
    _barVm!.setFollowerPageController(_controller, widget.data.type);
  }

  @override
  void initState() {
    super.initState();
    _controller = PageController();
    _children.add(OtherPetFollowerMe(followerMe: data.followerMeList));
    _children.add(OtherPetMyFollower(myFollower: data.myFollowerList));
    WidgetsBinding.instance.addPostFrameCallback(_onLayoutDone);
  }

  @override
  Widget build(BuildContext context) {
    _barVm = Provider.of<TabBarVm>(context, listen: false);
    if (ModalRoute.of(context)?.isCurrent ?? false) {
      _barVm!.refresh(_controller);
    }
    return Column(
      children: [
        //tab_button
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(child: _tabButton(FollowerTabBarEnum.followerMe)),
              const SizedBox(
                width: 20,
              ),
              Expanded(child: _tabButton(FollowerTabBarEnum.myFollower))
            ],
          ),
        ),
        //pageView
        Expanded(
            child: PageView(
          controller: _controller,
          onPageChanged: _barVm!.onFollowerPageChanged,
          children: _children,
        ))
      ],
    );
  }

  Widget _tabButton(FollowerTabBarEnum value) {
    return Consumer<TabBarVm>(
      builder: (context, vm, _) {
        return GestureDetector(
          onTap: () => vm.setFollowerTabBar(value),
          child: Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 30),
            decoration: BoxDecoration(
                color: value != vm.followerTabBar
                    ? AppColor.textFieldUnSelect
                    : AppColor.button,
                borderRadius: BorderRadius.circular(10)),
            child: Text(
              value.zh,
              style: const TextStyle(
                  color: AppColor.textFieldTitle, fontSize: 15, height: 1.1),
            ),
          ),
        );
      },
    );
  }
}
