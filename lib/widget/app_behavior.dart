import 'package:flutter/cupertino.dart';

//*? 這裡好像又沒有變動？
class AppBehavior extends ScrollBehavior{
  @override
  Widget buildOverscrollIndicator(BuildContext context, Widget child, ScrollableDetails details) {
    return child;
  }
}