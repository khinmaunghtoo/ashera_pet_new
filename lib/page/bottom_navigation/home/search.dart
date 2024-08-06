import 'package:ashera_pet_new/utils/app_color.dart';
import 'package:ashera_pet_new/widget/search/title.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../widget/search/body.dart';
import '../../../widget/system_back.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<StatefulWidget> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  @override
  Widget build(BuildContext context) {
    return SystemBack(
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: AppColor.appBackground,
        body: LayoutBuilder(
          builder: (context, constraints) {
            return SizedBox(
              height: constraints.maxHeight,
              width: constraints.maxWidth,
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  //title
                  SearchTitle(callback: _back),
                  const Expanded(child: SearchBody())
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  //返回
  void _back() {
    context.pop();
    //Navigator.of(context).pop();
  }
}
