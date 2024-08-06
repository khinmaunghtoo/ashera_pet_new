import 'package:ashera_pet_new/view_model/tab_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

import '../../model/faces_detect_history.dart';
import '../../widget/identification_record/record_item.dart';

class MeIdentifiedPage extends StatefulWidget {
  const MeIdentifiedPage({super.key});

  @override
  State<StatefulWidget> createState() => _MeIdentifiedPageState();
}

class _MeIdentifiedPageState extends State<MeIdentifiedPage>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Selector<TabBarVm, List<FacesDetectHistoryModel>>(
      selector: (context, data) => data.whoDidISeeList,
      shouldRebuild: (pre, next) => pre != next,
      builder: (context, data, _) => ListView.builder(
          padding: EdgeInsets.zero,
          itemCount: data.length,
          itemBuilder: (context, index) => RecordItem(
                data: data[index],
              )),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
