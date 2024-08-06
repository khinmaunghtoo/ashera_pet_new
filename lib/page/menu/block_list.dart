import 'package:ashera_pet_new/view_model/blacklist.dart';
import 'package:ashera_pet_new/widget/system_back.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../data/blacklist.dart';
import '../../utils/app_color.dart';
import '../../widget/block/block_item.dart';
import '../../widget/title_bar.dart';

class BlockList extends StatefulWidget {
  const BlockList({super.key});

  @override
  State<BlockList> createState() => _BlockListState();
}

class _BlockListState extends State<BlockList> {
  @override
  Widget build(BuildContext context) {
    return SystemBack(
        child: Scaffold(
      backgroundColor: AppColor.appBackground,
      resizeToAvoidBottomInset: false,
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SizedBox(
            height: constraints.maxHeight,
            width: constraints.maxWidth,
            child: Column(
              children: [
                TitleBar("封鎖名單", left: [backButton()]),
                const SizedBox(
                  height: 10,
                ),
                //訊息列表
                Expanded(child: Consumer<BlackListVm>(
                  builder: (context, vm, _) {
                    if (BlackList.blacklist.isEmpty) {
                      return const Center(
                        child: Text(
                          '目前還沒有封鎖對象',
                          style: TextStyle(color: AppColor.textFieldTitle),
                        ),
                      );
                    }
                    return ListView.builder(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 0),
                        itemCount: BlackList.blacklist.length,
                        itemBuilder: (context, index) {
                          return BlockItem(
                            data: BlackList.blacklist[index],
                          );
                        });
                  },
                )),
              ],
            ),
          );
        },
      ),
    ));
  }

  Widget backButton() {
    return GestureDetector(
      onTap: () {
        context.pop();
      },
      child: TitleBarWidget.backButtonWidget(),
    );
  }
}
