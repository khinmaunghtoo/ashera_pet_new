import 'package:ashera_pet_new/model/member.dart';
import 'package:ashera_pet_new/model/tuple.dart';
import 'package:ashera_pet_new/utils/app_color.dart';
import 'package:ashera_pet_new/view_model/message_controller.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../enum/message_type.dart';
import '../../utils/api.dart';

class SendButton extends StatefulWidget {
  final TextEditingController input;
  final MemberModel userData;
  const SendButton({super.key, required this.input, required this.userData});

  @override
  State<StatefulWidget> createState() => _SendButtonState();
}

class _SendButtonState extends State<SendButton> {
  TextEditingController get input => widget.input;
  MemberModel get userData => widget.userData;
  late MemberModel other;

  @override
  void initState() {
    super.initState();
    _getOther();
    input.addListener(_listener);
  }

  void _getOther() async {
    Tuple<bool, String> r = await Api.getMemberData(userData.id);
    if (r.i1!) {
      other = MemberModel.fromJson(r.i2!);
    }
  }

  void _listener() {
    setState(() {});
  }

  @override
  void dispose() {
    input.removeListener(_listener);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<MessageControllerVm>(
      builder: (context, vm, _) {
        return GestureDetector(
          onTap: () {
            if (input.text.isNotEmpty) {
              vm.addMsg(other, input.text, MessageType.TEXT);
              input.clear();
            }
          },
          child: Icon(
            Icons.near_me_sharp,
            color: input.text.isEmpty
                ? AppColor.textFieldHintText
                : AppColor.button,
            size: 35,
          ),
        );
      },
    );
  }
}
