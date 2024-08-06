import 'package:ashera_pet_new/enum/like_content_type.dart';
import 'package:ashera_pet_new/utils/app_color.dart';
import 'package:ashera_pet_new/view_model/kanban.dart';
import 'package:ashera_pet_new/widget/like/body/be_like.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'body/like.dart';

class LikeBody extends StatefulWidget {
  const LikeBody({super.key});

  @override
  State<StatefulWidget> createState() => _LikeBodyState();
}

class _LikeBodyState extends State<LikeBody> {
  KanBanVm? _kanBanVm;

  late PageController _controller;

  final List<Widget> _children = [
    const Like(),
    const BeLike(),
  ];

  _onLayoutDone(_) {
    _kanBanVm!.getLikeMe();
    _kanBanVm!.setPageController(_controller);
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
    _kanBanVm!.likeDispose();
  }

  @override
  Widget build(BuildContext context) {
    _kanBanVm = Provider.of<KanBanVm>(context);
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
              Expanded(child: _tabButton(LikeContentType.like)),
              const SizedBox(
                width: 20,
              ),
              Expanded(child: _tabButton(LikeContentType.beLike))
            ],
          ),
        ),
        //pageView
        Expanded(
            child: PageView(
          physics: const NeverScrollableScrollPhysics(),
          controller: _controller,
          children: _children,
        ))
      ],
    );
  }

  Widget _tabButton(LikeContentType value) {
    return Consumer<KanBanVm>(
      builder: (context, vm, _) {
        return GestureDetector(
          onTap: () => vm.setLikeContentType(value),
          child: Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 30),
            decoration: BoxDecoration(
                color: value != vm.likeContentType
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
