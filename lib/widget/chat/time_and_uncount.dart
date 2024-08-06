import 'package:ashera_pet_new/utils/utils.dart';
import 'package:ashera_pet_new/widget/chat/un_read_count.dart';
import 'package:flutter/cupertino.dart';

import '../../utils/app_color.dart';

class TimeAndUnCount extends StatelessWidget {
  final String time;
  final int unCount;
  const TimeAndUnCount({super.key, required this.time, required this.unCount});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          Utils.sqlTimeToHHAndMM(time),
          style:
              const TextStyle(color: AppColor.textFieldHintText, fontSize: 12),
        ),
        UnReadCount(
          unReadCount: unCount,
        )
      ],
    );
  }
}
