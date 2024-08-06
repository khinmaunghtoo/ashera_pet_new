import 'package:ashera_pet_new/utils/app_color.dart';
import 'package:flutter/material.dart';

//長方形
class RectangleButton extends StatelessWidget {
  final Color color;
  final String text;
  final double padding;

  const RectangleButton(
      {super.key, required this.color, required this.text, this.padding = 15});

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      padding: EdgeInsets.symmetric(vertical: padding),
      decoration:
          BoxDecoration(color: color, borderRadius: BorderRadius.circular(15)),
      child: FittedBox(
        fit: BoxFit.scaleDown,
        child: Text(
          text,
          style: const TextStyle(
              color: AppColor.textFieldTitle, fontSize: 18, height: 1.1),
        ),
      ),
    );
  }
}

//Icon 長方形
class IconRectangleButton extends StatelessWidget {
  final Color color;
  final String text;
  final double padding;
  final Widget? icon;

  const IconRectangleButton(
      {super.key,
      required this.color,
      required this.text,
      this.padding = 15,
      this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      padding: EdgeInsets.symmetric(vertical: padding),
      decoration:
          BoxDecoration(color: color, borderRadius: BorderRadius.circular(15)),
      child: FittedBox(
        fit: BoxFit.scaleDown,
        child: Row(
          children: [
            Offstage(
              offstage: icon == null,
              child: icon,
            ),
            Offstage(
              offstage: icon == null,
              child: const SizedBox(
                width: 10,
              ),
            ),
            Text(
              text,
              style: const TextStyle(
                  color: AppColor.textFieldTitle, fontSize: 18, height: 1.1),
            ),
          ],
        ),
      ),
    );
  }
}

//藍色
Widget blueRectangleButton(String text, VoidCallback? callback,
    [double? padding]) {
  return GestureDetector(
    onTap: callback,
    child: RectangleButton(
      color: AppColor.button,
      text: text,
      padding: padding ?? 15,
    ),
  );
}

//灰色
Widget grayRectangleButton(String text, VoidCallback callback,
    [double? padding]) {
  return GestureDetector(
    onTap: callback,
    child: RectangleButton(
      color: AppColor.textFieldUnSelect,
      text: text,
      padding: padding ?? 15,
    ),
  );
}

//Icon 藍色
Widget iconBlueRectangleButton(String text, VoidCallback callback,
    [double? padding, Widget? icon]) {
  return GestureDetector(
    onTap: callback,
    child: IconRectangleButton(
      color: AppColor.button,
      text: text,
      padding: padding ?? 15,
      icon: icon,
    ),
  );
}

//Icon 灰色
Widget iconGrayRectangleButton(String text, VoidCallback callback,
    [double? padding, Widget? icon]) {
  return GestureDetector(
    onTap: callback,
    child: IconRectangleButton(
        color: AppColor.textFieldUnSelect,
        text: text,
        padding: padding ?? 15,
        icon: icon),
  );
}

//藍色圓形+
Widget blueAddButton(double size, VoidCallback callback,
    [Color? color = AppColor.button]) {
  return GestureDetector(
    onTap: callback,
    child: Container(
      width: size,
      height: size,
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
      child: Icon(
        Icons.add,
        size: size,
        color: AppColor.textFieldTitle,
      ),
    ),
  );
}

//黃色圓形！
Widget yellowButton(double size, VoidCallback callback) {
  return GestureDetector(
    onTap: callback,
    child: Container(
      width: size,
      height: size,
      alignment: Alignment.center,
      decoration:
          const BoxDecoration(color: Colors.amber, shape: BoxShape.circle),
      child: const Text(
        '!',
        style: TextStyle(
            color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold),
      ),
    ),
  );
}

class CircleButton extends StatelessWidget {
  final String iconData;
  final VoidCallback callback;
  const CircleButton(
      {super.key, required this.iconData, required this.callback});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => callback(),
      child: Container(
        padding: const EdgeInsets.all(8),
        alignment: Alignment.center,
        decoration: const BoxDecoration(
            shape: BoxShape.circle, color: AppColor.circleButtonColor),
        child: Image(
          width: 30,
          image: AssetImage(iconData),
        ),
      ),
    );
  }
}
