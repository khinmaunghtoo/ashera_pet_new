import 'package:ashera_pet_new/widget/button.dart';
import 'package:flutter/cupertino.dart';

class SendSmsButton extends StatelessWidget {
  final String text;
  final VoidCallback callback;
  const SendSmsButton({super.key, required this.callback, required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 10),
      child: blueRectangleButton(text, callback),
    );
  }
}
