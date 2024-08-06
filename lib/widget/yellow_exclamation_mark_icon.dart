import 'package:flutter/material.dart';

class YellowExclamationMarkIcon extends StatelessWidget{
  const YellowExclamationMarkIcon({super.key});
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 30,
      alignment: Alignment.center,
      decoration: const BoxDecoration(
          color: Colors.amber,
          shape: BoxShape.circle
      ),
      child: const Text(
        '!',
        style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold
        ),
      ),
    );
  }
}