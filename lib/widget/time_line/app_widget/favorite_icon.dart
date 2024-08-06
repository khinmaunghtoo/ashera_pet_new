import 'package:flutter/material.dart';

import '../../../utils/app_color.dart';
import '../../like_button/painter/bubbles_painter.dart';
import '../../like_button/painter/circle_painter.dart';
import '../../like_button/utils/like_button_model.dart';

///貼文 - 愛心
class FavoriteIconButton extends StatefulWidget {
  ///喜歡或不喜歡
  final bool isLiked;

  ///Icon大小尺寸
  final double size;

  ///onTap 回調。返回一個值以指示是否喜歡。
  final Function(bool val) onTap;

  final double bubblesSize;

  final BubblesColor bubblesColor;

  final double circleSize;

  final CircleColor circleColor;

  /// {@macro favorite_icon_button}
  const FavoriteIconButton(
      {
        super.key,
        required this.isLiked,
        this.size = 22,
        required this.onTap,
        double? bubblesSize,
        double? circleSize,
        this.bubblesColor = const BubblesColor(
          dotPrimaryColor: Color(0xFFFFC107),
          dotSecondaryColor: Color(0xFFFF9800),
          dotThirdColor: Color(0xFFFF5722),
          dotLastColor: Color(0xFFF44336),
        ),
        this.circleColor =
        const CircleColor(start: Color(0xFFFF5722), end: Color(0xFFFFC107)),
      })
      : bubblesSize = bubblesSize ?? size * 2.0,
        circleSize = circleSize ?? size * 0.8;

  @override
  State<StatefulWidget> createState() => _FavoriteIconButtonState();
}

class _FavoriteIconButtonState extends State<FavoriteIconButton> with TickerProviderStateMixin{
  late bool isLiked = widget.isLiked;

  AnimationController? _controller;
  late Animation<double> _outerCircleAnimation;
  late Animation<double> _innerCircleAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<double> _bubblesAnimation;

  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(duration: const Duration(milliseconds: 1000), vsync: this);
    _initAnimations();
  }

  @override
  void dispose() {
    _controller!.dispose();
    super.dispose();
  }

  void _handleTap(){
    if(mounted){
      setState(() {
        if(!isLiked){
          _controller!.reset();
          _controller!.forward();
        }
        isLiked = !isLiked;
      });
    }
    widget.onTap(isLiked);
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
        animation: _controller!,
        builder: (context, child){
          return Stack(
            clipBehavior: Clip.none,
            children: [
              Positioned(
                  top: (widget.size - widget.bubblesSize) / 2.0,
                  left: (widget.size - widget.bubblesSize) / 2.0,
                  child: CustomPaint(
                  size: Size(widget.bubblesSize, widget.bubblesSize),
                  painter: BubblesPainter(
                    currentProgress: _bubblesAnimation.value,
                    color1: widget.bubblesColor.dotPrimaryColor,
                    color2: widget.bubblesColor.dotSecondaryColor,
                    color3: widget.bubblesColor.dotThirdColorReal,
                    color4: widget.bubblesColor.dotLastColorReal,
                  ),
                ),
              ),
              Positioned(
                top: (widget.size - widget.circleSize) / 2.0,
                left: (widget.size - widget.circleSize) / 2.0,
                child: CustomPaint(
                  size: Size(widget.circleSize, widget.circleSize),
                  painter: CirclePainter(
                    innerCircleRadiusProgress: _innerCircleAnimation.value,
                    outerCircleRadiusProgress: _outerCircleAnimation.value,
                    circleColor: widget.circleColor,
                  ),
                ),
              ),
              Container(
                width: widget.size,
                height: widget.size,
                alignment: Alignment.center,
                child: Transform.scale(
                  scale: ((isLiked) && _controller!.isAnimating)
                      ? _scaleAnimation.value
                      : 1.0,
                  child: SizedBox(
                    height: widget.size,
                    width: widget.size,
                    child: GestureDetector(
                      onTap: _handleTap,
                      child: AnimatedCrossFade(
                        firstCurve: Curves.easeIn,
                        secondCurve: Curves.easeOut,
                        firstChild: Icon(
                          Icons.favorite,
                          color: AppColor.like,
                          size: widget.size,
                        ),
                        secondChild: Icon(
                          Icons.favorite_outline,
                          color: AppColor.textFieldTitle,
                          size: widget.size,
                        ),
                        crossFadeState:
                        isLiked ? CrossFadeState.showFirst : CrossFadeState.showSecond,
                        duration: const Duration(milliseconds: 200),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        }
    );
  }

  void _initAnimations(){
    _initControlAnimation();
  }

  void _initControlAnimation(){
    _outerCircleAnimation = Tween<double>(
      begin: 0.1,
      end: 1.0,
    ).animate(
      CurvedAnimation(
        parent: _controller!,
        curve: const Interval(
          0.0,
          0.3,
          curve: Curves.ease,
        ),
      ),
    );
    _innerCircleAnimation = Tween<double>(
      begin: 0.2,
      end: 1.0,
    ).animate(
      CurvedAnimation(
        parent: _controller!,
        curve: const Interval(
          0.2,
          0.5,
          curve: Curves.ease,
        ),
      ),
    );
    final Animation<double> animate = Tween<double>(
      begin: 0.2,
      end: 1.0,
    ).animate(
      CurvedAnimation(
        parent: _controller!,
        curve: const Interval(
          0.35,
          0.7,
          curve: OvershootCurve(),
        ),
      ),
    );
    _scaleAnimation = animate;
    _bubblesAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(
      CurvedAnimation(
        parent: _controller!,
        curve: const Interval(
          0.1,
          1.0,
          curve: Curves.decelerate,
        ),
      ),
    );
  }
}