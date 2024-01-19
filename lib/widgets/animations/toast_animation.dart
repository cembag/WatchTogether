// import 'dart:async';

// import 'package:ecinema_watch_together/utils/app/app_colors.dart';
// import 'package:ecinema_watch_together/widgets/text_styled.dart';
// import 'package:flutter/material.dart';

// class ToastAnimation extends StatefulWidget {
//   final String text;
//   const ToastAnimation({super.key, required this.text});

//   @override
//   State<ToastAnimation> createState() => _ToastAnimationState();
// }

// class _ToastAnimationState extends State<ToastAnimation>  with SingleTickerProviderStateMixin {

//   late final AnimationController _animationController;
//   late final Animation<double> _animation;

//   @override
//   void initState() {
//     _animationController = AnimationController(vsync: this, duration: const Duration(milliseconds: 500));
//     _animation = Tween<double>(begin: 0, end: 1).animate(CurvedAnimation(parent: _animationController, curve: Curves.fastLinearToSlowEaseIn));
//     _animationController.addListener(() {
//       setState(() {});
//     });
//     _animationController.forward();
//     super.initState();
//   }
  
//   @override
//   void dispose() {
//     _animationController.dispose();
//     super.dispose();
//   }

//   // Timer? timer;
//   // var time = 0.0;

//   // @override
//   // void initState() {
//   //   timer = Timer.periodic(const Duration(milliseconds: 500), (timer) {
//   //     time += .5;
//   //     setState(() {});
//   //     if(time >= 3) {
//   //       timer.cancel();
//   //     }
//   //   });
//   //   super.initState();
//   // }

//   @override
//   Widget build(BuildContext context) {
//     return Stack(
//       alignment: Alignment.center,
//       children: [
//         Positioned(
//           bottom: 120 + (40 * _animation.value),
//           child: Opacity(
//             opacity: _animation.value,
//             child: ScaleTransition(
//               scale: _animation,
//               // scale: mounted ? 1 : 0,
//               // duration: const Duration(milliseconds: 500),
//               // curve: Curves.fastEaseInToSlowEaseOut,
//               child: Container(
//                 decoration: BoxDecoration(
//                   color: Colors.black,
//                   borderRadius: BorderRadius.circular(6)
//                 ),
//                 padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 10),
//                 child: textStyled(widget.text, 14, AppColors.greyTextColor),
//               ),
//             ),
//           )
//         )
//       ],
//     );
//   }
// }