import 'package:ashera_pet_new/enum/animal.dart';
import 'package:ashera_pet_new/utils/app_color.dart';
import 'package:flutter/cupertino.dart';

class AnimalTypePicker extends StatefulWidget {
  final Function(int) callback;
  final VoidCallback success;
  final VoidCallback cancel;
  const AnimalTypePicker(
      {super.key,
      required this.callback,
      required this.success,
      required this.cancel});

  @override
  State<StatefulWidget> createState() => _AnimalTypePickerState();
}

class _AnimalTypePickerState extends State<AnimalTypePicker> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Container(
          decoration: const BoxDecoration(color: AppColor.appBackground),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              //取消
              CupertinoButton(
                  onPressed: widget.cancel,
                  child: const Text(
                    '取消',
                    style: TextStyle(
                        color: AppColor.textFieldHintText, fontSize: 16),
                  )),
              //確定
              CupertinoButton(
                  onPressed: widget.success,
                  child: const Text(
                    '確定',
                    style: TextStyle(color: AppColor.button, fontSize: 16),
                  ))
            ],
          ),
        ),
        Container(
          height: 300,
          decoration: const BoxDecoration(color: AppColor.appBackground),
          child: CupertinoPicker(
            onSelectedItemChanged: widget.callback,
            itemExtent: 25,
            diameterRatio: 30,
            useMagnifier: true,
            magnification: 1.3,
            squeeze: 0.7,
            children: AnimalType.values.map((e) => _item(e)).toList(),
          ),
        )
      ],
    );
  }

  Widget _item(AnimalType animalTypeEnum) {
    return Text(animalTypeEnum.zh,
        style: const TextStyle(fontSize: 18, color: AppColor.textFieldTitle));
  }
}
