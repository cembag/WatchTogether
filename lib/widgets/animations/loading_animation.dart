import 'package:ecinema_watch_together/utils/app/app_assets.dart';
import 'package:ecinema_watch_together/utils/app/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

const deg = 3.1415927 / 180;
const rotateAngle = 120.0;
const boxWidth = 140.0;
const boxWidthStepTwo = 60.0;
const boxWidthStepThree = 140.0;
const boxHeightStepThree = 20.0;
const loaderWidth = 100.0;

class LoadingAnimation extends StatefulWidget {
  const LoadingAnimation({super.key});

  @override
  State<LoadingAnimation> createState() => _LoadingAnimationState();
}

class _LoadingAnimationState extends State<LoadingAnimation> with TickerProviderStateMixin {

  late AnimationController _controller1;
  late Animation<double> _animation1;
  late AnimationController _controller2;
  late Animation<double> _animation2;
  late AnimationController _controller3;
  late Animation<double> _animation3;
  late AnimationController _controller4;
  late Animation<double> _animation4;

  @override
  void initState() {
    _controller1 = AnimationController(duration: const Duration(milliseconds: 320), vsync: this);
    _animation1 = Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(parent: _controller1, curve: Curves.easeOutBack));
    _controller2 = AnimationController(duration: const Duration(milliseconds: 220), vsync: this);
    _animation2 = Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(parent: _controller2, curve: Curves.decelerate));
    _controller3 = AnimationController(duration: const Duration(milliseconds: 220), vsync: this);
    _animation3 = Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(parent: _controller3, curve: Curves.decelerate));
    _controller4 = AnimationController(duration: const Duration(milliseconds: 1000), vsync: this);
    _animation4 = Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(parent: _controller4, curve: Curves.easeInOutQuart));
    _controller1.addListener(() {
      setState(() {});
      if(_controller1.status == AnimationStatus.completed) {
        _controller1.removeListener(() { });
        _controller2.forward();
        _controller2.addListener(() { 
          setState(() {});
          if(_controller2.status == AnimationStatus.completed) {
            _controller2.removeListener(() { });
            _controller3.forward();
            _controller3.addListener(() { 
              setState(() {});
              if(_controller3.status == AnimationStatus.completed) {
                _controller3.removeListener(() { });
                _controller4.forward();
                _controller4.addListener(() {
                  setState(() {});
                  if(_controller4.status == AnimationStatus.completed) {
                     Future.delayed(const Duration(milliseconds: 300), () {
                      if(mounted) {
                        _controller4.forward(from: 0.0);
                      }
                     });
                  }
                });
              }
            });
          }
        });
      }
     });
    _controller1.forward();
    super.initState();
  }

  @override
  void dispose() {
    _controller1.dispose();
    _controller2.dispose();
    _controller3.dispose();
    _controller4.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final img = Image.asset(AppAssets.animationLogo);
    final stepOne = !_animation1.isCompleted;
    final stepTwo = _animation1.isCompleted && !_animation2.isCompleted;
    final stepThree = _animation1.isCompleted && _animation2.isCompleted && !_animation3.isCompleted;
    final stepFour = _animation1.isCompleted && _animation2.isCompleted && _animation3.isCompleted;
    return SizedBox(
      width: Get.width,
      height: Get.height,
      child: Center(
        child: Opacity(
          opacity: stepOne ? _animation1.value >= 1 ? 1 : _animation1.value : 1,
          child: Transform.rotate(
            angle: (rotateAngle - (_animation1.value * rotateAngle)) * deg,
            child: Container(
              clipBehavior: Clip.hardEdge,
              width: stepFour ? boxWidthStepThree : stepThree ? boxWidthStepTwo + ((boxWidthStepThree - boxWidthStepTwo) * _animation3.value) : stepTwo ? boxWidth - ((boxWidth - boxWidthStepTwo) * _animation2.value) : _animation1.value * boxWidth,
              height: stepFour ? boxHeightStepThree : stepThree ? boxWidthStepTwo - ((boxWidthStepTwo - boxHeightStepThree) * _animation3.value) : stepTwo ? boxWidth - ((boxWidth - boxWidthStepTwo) * _animation2.value) : _animation1.value * boxWidth,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(120),
                color: Colors.black,
                // gradient: const LinearGradient(colors: [AppColors.scaffoldSplashColor, Colors.black], begin: Alignment.topCenter, end: Alignment.bottomRight,)
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  /// IMAGE
                  Padding(
                    padding: const EdgeInsets.all(32),
                    child: Opacity(
                      opacity: stepTwo ? 1 - _animation2.value : _animation1.value >= 1 ? 1 : stepOne ? _animation1.value : 0,
                      child: img
                    ),
                  ),
                  /// Loader
                  if(stepFour)
                  Positioned(
                    bottom: 0,
                    left: ((boxWidthStepThree + loaderWidth) * _animation4.value) - loaderWidth,
                    child: Container(
                      width: loaderWidth,
                      height: boxHeightStepThree,
                      decoration:  BoxDecoration(
                        borderRadius: BorderRadius.circular(60),
                        gradient: const LinearGradient(colors: [Color.fromARGB(255, 224, 145, 27), AppColors.themeColor], begin: Alignment.centerLeft, end: Alignment.centerRight)
                      ),
                    ),
                  )
                ],
              )
            ),
          ),
        ),
      ),
    );
  }
}