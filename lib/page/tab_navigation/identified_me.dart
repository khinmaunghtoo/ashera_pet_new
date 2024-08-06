import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

import '../../model/faces_detect_history.dart';
import '../../view_model/tab_bar.dart';
import '../../widget/identification_record/record_item.dart';

class IdentifiedMePage extends StatefulWidget{
  const IdentifiedMePage({super.key});

  @override
  State<StatefulWidget> createState() => _IdentifiedMePageState();
}

class _IdentifiedMePageState extends State<IdentifiedMePage> with AutomaticKeepAliveClientMixin{
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Selector<TabBarVm, List<FacesDetectHistoryModel>>(
      selector: (context, data) => data.whoSawMeList,
      shouldRebuild: (pre, next) => pre != next,
      builder: (context, data, _) => ListView.builder(
          padding: EdgeInsets.zero,
          itemCount: data.length,
          itemBuilder: (context, index) => RecordItem(
            data: data[index],
          )
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}