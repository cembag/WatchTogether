import 'package:flutter/animation.dart';

class CustomEaseOutBackCurve extends Curve {
  final double overshoot;

  const CustomEaseOutBackCurve({this.overshoot = .6});

  @override
  double transformInternal(double t) {
    t = 1.0 - t;
    return 1.0 - (t * t * ((overshoot + 1) * t - overshoot));
  }
}