import 'package:ashera_pet_new/utils/app_color.dart';
import 'package:flutter/cupertino.dart';

import '../../utils/utils.dart';
import '../ashera_pet_text.dart';

//* chat page title bar
class ChatTitleBar extends StatelessWidget {
  const ChatTitleBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
      height: Utils.appBarHeight,
      alignment: Alignment.center,
      decoration: const BoxDecoration(color: AppColor.textFieldUnSelect),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [const Expanded(child: AsheraPetText()), Container()],
      ),
    );
  }
}
