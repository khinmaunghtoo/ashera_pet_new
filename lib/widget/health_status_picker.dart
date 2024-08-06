import 'package:ashera_pet_new/utils/app_color.dart';
import 'package:flutter/cupertino.dart';

import '../enum/health_status.dart';

class HealthStatusPicker extends StatefulWidget {
  final Function(int) callback;
  const HealthStatusPicker({super.key, required this.callback});

  @override
  State<StatefulWidget> createState() => _HealthStatusPickerState();
}

class _HealthStatusPickerState extends State<HealthStatusPicker> {
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
                child: const Text(
                  '取消',
                  style: TextStyle(
                      color: AppColor.textFieldHintText, fontSize: 16),
                ),
                onPressed: () => Navigator.of(context).pop(false),
              ),
              //確定
              CupertinoButton(
                  child: const Text(
                    '確定',
                    style: TextStyle(color: AppColor.button, fontSize: 16),
                  ),
                  onPressed: () => Navigator.of(context).pop(true))
            ],
          ),
        ),
        Container(
          height: 300,
          decoration: const BoxDecoration(
            color: AppColor.appBackground,
          ),
          child: CupertinoPicker(
            onSelectedItemChanged: widget.callback,
            itemExtent: 25,
            diameterRatio: 30,
            useMagnifier: true,
            magnification: 1.3,
            squeeze: 0.7,
            children: HealthStatus.values.map((e) => _item(e)).toList(),
          ),
        )
      ],
    );
  }

  Widget _item(HealthStatus healthStatusEnum) {
    return Text(
      healthStatusEnum.zh,
      style: const TextStyle(fontSize: 18, color: AppColor.textFieldTitle),
    );
  }
}
