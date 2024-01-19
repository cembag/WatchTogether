import 'package:ecinema_watch_together/widgets/custom_curves.dart';
import 'package:flutter/material.dart';

showAnimatedModal({required BuildContext context, required Widget child, required double width, required double height, int? duration, bool? autoClose, double? radius, Color? shadowColor}) async {
  await showDialog(
    context: context,
    barrierColor: shadowColor ?? Colors.black.withOpacity(.2),
    builder: (BuildContext context) => AnimatedModal(
      duration: duration,
      autoClose: autoClose,
      radius: radius,
      width: width,
      height: height,
      child: child,
    ),
  );
}

class AnimatedModal extends StatefulWidget {
  final Widget child;
  final double width;
  final double height;
  final int? duration;
  final bool? autoClose;
  final double? radius;
  const AnimatedModal({super.key, required this.child, required this.width, required this.height, this.autoClose, this.duration, this.radius});

  @override
  State<AnimatedModal> createState() => _AnimatedModalState();
}

class _AnimatedModalState extends State<AnimatedModal> with SingleTickerProviderStateMixin {

  late final AnimationController _animationController;
  late final Animation<double> _animation;
  var canSubmit = true;

  void b() {
    Navigator.of(context).pop(5);
  }

  @override
  void initState() {
    _animationController = AnimationController(vsync: this, duration: const Duration(milliseconds: 400));
    _animation = Tween<double>(begin: 0, end: 1).animate(CurvedAnimation(parent: _animationController, curve: const CustomEaseOutBackCurve()));
    _animationController.addListener(() {
      if(widget.autoClose != null && widget.autoClose!) {
        if(_animationController.isCompleted) {
          Future.delayed(Duration(seconds: widget.duration ?? 3), () {
            if(!mounted) return;
            setState(() {
              canSubmit = false;
            });
            _animationController.reverse();
            Future.delayed(const Duration(milliseconds: 220), () {
              if(!mounted) return;
              Navigator.of(context).pop();
            });
          });
        }
      }
      setState(() {});
    });
    _animationController.forward();
    super.initState();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _animation,
      child: Opacity(
        opacity: _animation.value >= 1 ? 1 : _animation.value,
        child: SizedBox(
          width: widget.width,
          height: widget.height,
          child: widget.child,
        )
      ),
    ); 
  }
}