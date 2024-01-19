import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class ChatScreenController extends GetxController {

  @override
  void onClose() {
    pageController.dispose();
    super.onClose();
  }

  final pageController = PageController();
  var currentScreen = 0.obs;

  Future<void> setScreen(int screen) async {
    pageController.animateToPage(screen, duration: const Duration(milliseconds: 300), curve: Curves.fastEaseInToSlowEaseOut);
    currentScreen.value = screen;
    update();
  }
}