import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart';

class CustomYearAndMonthPicker extends DatePickerModel{
  CustomYearAndMonthPicker({required DateTime currentTime, required DateTime minTime,required DateTime maxTime,required LocaleType locale}): super(locale: locale, minTime: minTime, maxTime: maxTime, currentTime: currentTime);

  @override
  List<int> layoutProportions() {
    return[1,1,0];
  }
}