import 'package:flutter/material.dart';

class Indicator extends StatelessWidget{
  final int currentIndex;
  final int dotCount;
  final ValueChanged onItemTap;

  final Color dotColor;
  final Color dotSelectedColor;
  final double dotSize;
  final double dotPadding;

  const Indicator({
    super.key,
    required this.currentIndex,
    required this.dotCount,
    required this.dotColor,
    required this.dotSelectedColor,
    required this.dotSize,
    required this.dotPadding,
    required this.onItemTap
  });

  Widget _renderItem(int index){
    var color = currentIndex == index ? dotColor : dotSelectedColor;
    return GestureDetector(
      child: Padding(
        padding: EdgeInsets.all(dotPadding),
        child: Container(
          width: dotSize,
          height: dotSize,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: color
          ),
        ),
      ),
      onTap: () => onItemTap(index),
    );
  }

  double getWidth() {
    return dotSize * dotCount + dotPadding * (dotCount + 5);
  }

  double getHeight(){
    return dotSize + dotPadding * 2;
  }

  Widget _getItems(){
    return SizedBox(
      width: getWidth(),
      height: getHeight(),
      child: ListView.builder(
          padding: EdgeInsets.zero,
          itemCount: dotCount,
          scrollDirection: Axis.horizontal,
          itemBuilder: (context, index) => _renderItem(index)
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          height: getHeight(),
          color: Colors.transparent
        ),
        //dot list
        Container(
          alignment: Alignment.center,
          child: _getItems(),
        )
      ],
    );
  }
}