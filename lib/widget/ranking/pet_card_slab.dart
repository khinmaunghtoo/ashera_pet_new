import 'package:flutter/cupertino.dart';

import '../../utils/app_color.dart';
import '../../utils/app_image.dart';

class RankPetCardSlab extends StatefulWidget{
  final int number;

  const RankPetCardSlab({
    super.key,
    required this.number,
  });

  @override
  State<StatefulWidget> createState() => _RankPetCardSlabState();
}
class _RankPetCardSlabState extends State<RankPetCardSlab>{
  int get number => widget.number;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      child: Row(
        children: [
          if(number < 3)
            Padding(
              padding: const EdgeInsets.only(right: 12),
              child: Text(
                  (number + 1).toString().padLeft(2, '0'),
                style: TextStyle(
                    color: _getNumberColor(number),
                    fontSize: 16
                ),
              ),
            ),
          if(number < 3)
            Image(
              width: 50,
              image: AssetImage(_getNumberCrown(number)),
            )
        ],
      ),
    );
  }

  //皇冠
  String _getNumberCrown(int value){
    switch(value){
      case 0:
        return AppImage.rank1;
      case 1:
        return AppImage.rank2;
      case 2:
        return AppImage.rank3;
      default:
        return '';
    }
  }

  Color _getNumberColor(int value){
    switch(value){
      case 0:
        return AppColor.firstPlace;
      case 1:
        return AppColor.secondPlace;
      case 2:
        return AppColor.thirdPlace;
      default:
        return AppColor.textFieldTitle;
    }
  }
}