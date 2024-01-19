import 'package:flutter/cupertino.dart';

class TapDownScaleAnimation extends StatefulWidget {
  final Widget child;
  final double? scale;
  final void Function()? onTap;
  const TapDownScaleAnimation({super.key, required this.child, this.scale, this.onTap});

  @override
  State<TapDownScaleAnimation> createState() => _TapDownScaleAnimationState();
}

class _TapDownScaleAnimationState extends State<TapDownScaleAnimation> {

  var isHolding = false;
  void _setHolding(bool val) {
    if(!mounted) return;
    isHolding = val;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        widget.onTap!.call();
        Future.delayed(const Duration(milliseconds: 50), () => _setHolding(false));
      },
      onTapDown: (details) => _setHolding(true),
      onTapCancel: () => _setHolding(false),
      child: AnimatedScale(
        duration: const Duration(milliseconds: 500),
        scale: isHolding ? widget.scale ?? .85 : 1,
        curve: Curves.elasticOut,
        child: widget.child,
      ),
    );
  }
}