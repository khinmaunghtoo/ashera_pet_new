import 'package:flutter/cupertino.dart';

/// {@template tap_fade_icon}
/// A tappable icon that fades colors when tapped and held.
/// {@endTemplate}
class TapFadeIcon extends StatefulWidget{
  ///Callback to handle tap.
  final VoidCallback onTap;
  /// Color of the icon.
  final Color iconColor;
  /// Type of icon.
  final IconData icon;
  /// Icon size.
  final double size;

  /// {@macro tap_fade_icon}
  const TapFadeIcon({
    super.key,
    required this.onTap,
    required this.icon,
    required this.iconColor,
    this.size = 22
  });

  @override
  State<StatefulWidget> createState() => _TapFadeIconState();
}

class _TapFadeIconState extends State<TapFadeIcon>{
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
  void didUpdateWidget(covariant TapFadeIcon oldWidget) {
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
      child: Icon(
        widget.icon,
        color: color,
        size: widget.size,
      ),
    );
  }
}