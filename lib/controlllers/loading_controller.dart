import 'package:ecinema_watch_together/utils/extensions/get_interface_extension.dart';
import 'package:ecinema_watch_together/widgets/animations/loading_animation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OverlayController {
  final Color? backgroundColor;
  late final Widget widget;
  OverlayController({this.backgroundColor, required this.widget});
  
  get _navigatorState => Navigator.of(Get.overlayContext!, rootNavigator: false);
  get _overlayState => _navigatorState.overlay!;

  late final _overlayEntryOpacity = OverlayEntry(builder: (context) {
    return  Container(
      color: backgroundColor ?? Colors.black.withOpacity(.5)
    );
  });

  late final _overlayEntryWidget = OverlayEntry(
    builder: (context) {
      return widget;
    },
  );

  bool isShowing = false;
  void show() {
    if(isShowing) return;
    Get.unfocus();
    _overlayState.insert(_overlayEntryOpacity);
    _overlayState.insert(_overlayEntryWidget);
    isShowing = true;
  }

  void hide() {
    if(!isShowing) return;
    Get.unfocus();
    _overlayEntryWidget.remove();
    _overlayEntryOpacity.remove();
    isShowing = false;
  }
}

class LoadingController {
  static final _loadingController = OverlayController(
    backgroundColor: const Color.fromRGBO(20, 20, 20, .5),
    widget: const LoadingAnimation()
  );

  static bool get isShowing => _loadingController.isShowing;

  static void showLoading() => _loadingController.show();
  static void hideLoading() => _loadingController.hide();
}

// class ToastController {
//   static String text = "";

//   static final _toastController = OverlayController(
//     backgroundColor: Colors.transparent,
//     widget: ToastAnimation(text: text)
//   );

//   static bool get isShowing => _toastController.isShowing;

//   static void showToast(String msg) {
//     text = msg;
//     _toastController.show();
//   }
//   static void hideToast() => _toastController.hide();
// }