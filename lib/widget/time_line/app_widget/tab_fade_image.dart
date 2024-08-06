import 'package:flutter/cupertino.dart';

class TapFadeImage extends StatefulWidget{
  final VoidCallback onTap;

  final Color iconColor;

  final String img;

  final double size;

  const TapFadeImage({
    super.key,
    required this.onTap,
    required this.img,
    required this.iconColor,
    this.size = 22
  });

  @override
  State<StatefulWidget> createState() => _TapFadeImageState();
}

class _TapFadeImageState extends State<TapFadeImage>{
  late Color color = widget.iconColor;

  void handleTapDown(TapDownDetails _){
    setState(() {
      color = widget.iconColor.withOpacity(0.7);
    });
  }

  void handleTapUp(TapUpDetails _){
    setState(() {
      color = widget.iconColor;
    });
    widget.onTap();
  }

  @override
  void didUpdateWidget(covariant TapFadeImage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if(oldWidget.iconColor != widget.iconColor){
      color = widget.iconColor;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: handleTapDown,
      onTapUp: handleTapUp,
      child: Image(
        image: AssetImage(widget.img),
        color: color,
        width: widget.size,
        height: widget.size,
      ),
    );
  }
}