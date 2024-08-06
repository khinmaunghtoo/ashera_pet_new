import 'package:ashera_pet_new/widget/identification_list/list_item.dart';
import 'package:flutter/cupertino.dart';

import '../../model/face_detect.dart';

class IdentificationListBody extends StatefulWidget {
  final List<FaceDetectResponseModel> data;

  const IdentificationListBody({super.key, required this.data});

  @override
  State<StatefulWidget> createState() => _IdentificationListBodyState();
}

class _IdentificationListBodyState extends State<IdentificationListBody> {
  List<FaceDetectResponseModel> get data => widget.data;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
        padding: EdgeInsets.zero,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, childAspectRatio: 0.8),
        itemCount: data.length,
        itemBuilder: (context, index) {
          return IdentificationListItem(data: data[index]);
        });
  }
}
