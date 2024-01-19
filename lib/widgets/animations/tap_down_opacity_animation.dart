import 'package:flutter/cupertino.dart';

class TapDownOpacityAnimation extends StatefulWidget {
  final Widget child;
  final double? opacity;
  final void Function()? onTap;
  final void Function()? onLongPress;
  final void Function(DragEndDetails endDetails)? onPanEnd;
  final void Function(DragStartDetails startDetails)? onPanStart;
  final void Function(DragUpdateDetails details)? onPanUpdate;
  final void Function(DragStartDetails details)? onHorizontalDragStart;
  final void Function(DragUpdateDetails details)? onHorizontalDragUpdate;
  final void Function(DragEndDetails details)? onHorizontalDragEnd;
  const TapDownOpacityAnimation({super.key, required this.child, this.opacity, this.onTap, this.onLongPress, this.onPanEnd, this.onPanStart, this.onPanUpdate, this.onHorizontalDragEnd, this.onHorizontalDragStart, this.onHorizontalDragUpdate});

  @override
  State<TapDownOpacityAnimation> createState() => _TapDownOpacityAnimationState();
}

class _TapDownOpacityAnimationState extends State<TapDownOpacityAnimation> {

  var isHolding = false;
  void _setHolding(bool val) => setState(() => isHolding = val);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        widget.onTap!.call();
        Future.delayed(const Duration(milliseconds: 50), () => _setHolding(false));
      },
      onLongPress: widget.onLongPress,
      onPanUpdate: widget.onPanUpdate,
      onPanStart: widget.onPanStart,
      onPanEnd: widget.onPanEnd,
      onHorizontalDragStart: widget.onHorizontalDragStart,
      onHorizontalDragEnd: widget.onHorizontalDragEnd,
      onHorizontalDragUpdate: widget.onHorizontalDragUpdate,
      onTapDown: (details) => _setHolding(true),
      onTapCancel: () => _setHolding(false),
      child: AnimatedOpacity(
        duration: const Duration(milliseconds: 200),
        opacity: isHolding ? widget.opacity ?? .8 : 1,
        curve: Curves.fastEaseInToSlowEaseOut,
        child: widget.child,
      ),
    );
  }
}