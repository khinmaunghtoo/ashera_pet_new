import 'package:ashera_pet_new/enum/tab_bar.dart';
import 'package:ashera_pet_new/utils/app_color.dart';
import 'package:ashera_pet_new/view_model/tab_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../page/tab_navigation/identified_me.dart';
import '../../page/tab_navigation/me_identified.dart';

class IdentificationRecordBody extends StatefulWidget {
  const IdentificationRecordBody({super.key});

  @override
  State<StatefulWidget> createState() => _IdentificationRecordBodyState();
}

class _IdentificationRecordBodyState extends State<IdentificationRecordBody> {
  TabBarVm? _barVm;
  late PageController _controller;

  final List<Widget> _children = [
    //看過我的
    const IdentifiedMePage(),
    //我看過的
    const MeIdentifiedPage()
  ];

  _onLayoutDone(_) {
    _barVm!.setPageController(_controller);
  }

  @override
  void initState() {
    super.initState();
    _controller = PageController();
    WidgetsBinding.instance.addPostFrameCallback(_onLayoutDone);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _barVm = Provider.of<TabBarVm>(context, listen: false);
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
              Expanded(child: _tabButton(TabBarEnum.identifiedMe)),
              const SizedBox(
                width: 20,
              ),
              Expanded(child: _tabButton(TabBarEnum.meIdentified))
            ],
          ),
        ),
        //pageView
        Expanded(
            child: PageView(
          controller: _controller,
          onPageChanged: _barVm!.onPageChanged,
          children: _children,
        ))
      ],
    );
  }

  Widget _tabButton(TabBarEnum value) {
    return Consumer<TabBarVm>(
      builder: (context, vm, _) {
        return GestureDetector(
          onTap: () => vm.setTabBar(value),
          child: Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 30),
            decoration: BoxDecoration(
                color: value != vm.tabBar
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
