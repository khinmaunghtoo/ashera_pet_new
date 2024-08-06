import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:provider/provider.dart';

import '../../view_model/recommend_vm.dart';
import 'no_search_body.dart';

class NoSearch extends StatefulWidget{
  final FocusNode focusNode;
  const NoSearch({
    super.key,
    required this.focusNode
  });

  @override
  State<StatefulWidget> createState() => _NoSearchState();
}

class _NoSearchState extends State<NoSearch>{

  @override
  Widget build(BuildContext context) {
    return Consumer<RecommendVm>(builder: (context, vm, _){
      return SliverMasonryGrid.count(
        crossAxisCount: 2,
        mainAxisSpacing: 2,
        crossAxisSpacing: 2,
        childCount: vm.postData.length,
        itemBuilder: (context, index) => NoSearchBody(postData: vm.postData[index], focusNode: widget.focusNode,),
      );
    },);
  }
}