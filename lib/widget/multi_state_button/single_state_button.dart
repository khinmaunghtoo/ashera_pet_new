import 'package:flutter/material.dart';

import 'button_state.dart';

class SingleStateButton extends StatelessWidget {
  /// State for single state button
  final ButtonState buttonState;
  const SingleStateButton({super.key, required this.buttonState});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: buttonState.onPressed,
        child: Container(
          width: buttonState.size?.width,
          height: buttonState.size?.height,
          color: buttonState.decoration == null ? buttonState.color : null,
          decoration: buttonState.decoration,
          alignment: buttonState.alignment,
          clipBehavior: buttonState.clipBehavior,
          foregroundDecoration: buttonState.foregroundDecoration,
          transform: buttonState.transform,
          transformAlignment: buttonState.transformAlignment,
          child: buttonState.textStyle != null
              ? DefaultTextStyle(
              style: buttonState.textStyle!, child: buttonState.child)
              : buttonState.child,
        ));
  }
}