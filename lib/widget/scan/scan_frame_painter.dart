import 'package:flutter/material.dart';

class ScanFramePainter extends CustomPainter{
  const ScanFramePainter(/*{required this.lineMoveValue}*/);

  //百分比值，0-1, 然後計算Y座標
  //final double lineMoveValue;

  //默認定義掃描框為 260邊長正方形
  final Size frameSize = const Size.square(360.0);
  final double cornerLength = 40.0;

  @override
  void paint(Canvas canvas, Size size) {
    //按掃描框居中來計算 全屏尺寸與掃描框尺寸的差集 除以2 就是掃描框的位置
    Offset diff = size - frameSize as Offset;
    double leftTopX = diff.dx / 2;
    double leftTopY = diff.dy / 2;
    //根據左上角的座標和掃描框的大小 可得知掃描框矩形
    var rect =
    Rect.fromLTWH(leftTopX, leftTopY, frameSize.width, frameSize.height);
    //4點的座標
    Offset leftTop = rect.topLeft;
    Offset leftBottom = rect.bottomLeft;
    Offset rightTop = rect.topRight;
    Offset rightBottom = rect.bottomRight;

    Paint paint = Paint()
      ..color = const Color(0x40cccccc) //透明灰
      ..style = PaintingStyle.fill; //畫筆的模式，填充
    //左側矩形
    canvas.drawRect(Rect.fromLTRB(0, 0, leftTopX, size.height), paint);
    //右側矩形
    canvas.drawRect(
        Rect.fromLTRB(rightTop.dx, 0, size.width, size.height), paint);
    //中上矩形
    canvas.drawRect(Rect.fromLTRB(leftTopX, 0, rightTop.dx, leftTopY), paint);
    //中下矩形
    canvas.drawRect(
        Rect.fromLTRB(
            leftBottom.dx, leftBottom.dy, rightBottom.dx, size.height),
        paint);

    //重新設置畫筆
    paint
      ..color = Colors.white //顏色
      ..strokeWidth = 2.0 //畫筆線條寬度
      ..strokeCap = StrokeCap.square //解決因為線框導致交界處不是直角的問題
      ..style = PaintingStyle.stroke; //畫筆的模式，填充還是只繪製邊框

    //橫向線條的座標偏移
    Offset horizontalOffset = Offset(cornerLength, 0);
    //縱向線條的座標偏移
    Offset verticalOffset = Offset(0, cornerLength);
    //左上角
    canvas.drawLine(leftTop, leftTop + horizontalOffset, paint);
    canvas.drawLine(leftTop, leftTop + verticalOffset, paint);
    //左下角
    canvas.drawLine(leftBottom, leftBottom + horizontalOffset, paint);
    canvas.drawLine(leftBottom, leftBottom - verticalOffset, paint);
    //右上角
    canvas.drawLine(rightTop, rightTop - horizontalOffset, paint);
    canvas.drawLine(rightTop, rightTop + verticalOffset, paint);
    //右下角
    canvas.drawLine(rightBottom, rightBottom - horizontalOffset, paint);
    canvas.drawLine(rightBottom, rightBottom - verticalOffset, paint);

    //掃描線的移動值
    //var lineY = leftTopY + frameSize.height * lineMoveValue;

    /*paint
      ..strokeWidth = 8//修改畫筆線條寬度
      ..shader = const LinearGradient( //漸層設定
      begin: Alignment.centerLeft,
      end: Alignment.centerRight,
      colors: [
        Colors.transparent,
        Colors.white,
        Colors.transparent,
      ],
    ).createShader(rect);*/
    // 10 為線條與方框之間的間距，繪製掃描線
    /*canvas.drawLine(Offset(leftTopX + 10.0, lineY),
        Offset(rightTop.dx - 10.0, lineY), paint);*/
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}