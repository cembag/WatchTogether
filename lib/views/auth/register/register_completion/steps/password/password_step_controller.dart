import 'package:ecinema_watch_together/views/auth/register/register_completion/register_completion_screen_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

const digitsLength = 6;

class PasswordStepController extends GetxController {

  @override
  void onInit() {
    focusNodes[0].requestFocus();
    super.onInit();
  }

  @override
  void onClose() {
    for(final node in focusNodes) {
      node.dispose();
    }
    for(final controller in textEditingControllers) {
      controller.dispose();
    }
    super.onClose();
  }

  final _completionController = Get.find<RegisterCompletionScreenController>();
  final focusNodes = List.generate(digitsLength, (index) => FocusNode());
  final textEditingControllers = List.generate(digitsLength, (index) => TextEditingController());
  final numKeys = ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9"];
  var isVisible = false.obs;
  var focusIndex = 0.obs;

   String get password => textEditingControllers.map((e) => e.text).join("");
  
  bool get canSubmit {
    var canSubmit = true;
    for(final controller in textEditingControllers) {
      if(controller.text.isEmpty) {
        canSubmit = false;
      }
    }
    return canSubmit;
  }

  void toggleVisibility() {
    isVisible.value = !isVisible.value;
    update();
  }

  void setFocus(int index) {
    if(index < 0 || index > digitsLength - 1) return;
    focusNodes[index].requestFocus();
    focusIndex.value = index;
    update();
  }

  void onTextFieldChanged(String text, int index) {
    textEditingControllers[index].text = text;
    update();
    if(index == digitsLength - 1 && text.isNotEmpty) {
      _completionController.complete(password);
    } else if (text.isNotEmpty) {
      setFocus(index + 1);
    } else {
      setFocus(index - 1);
    }
  }

  void previous() => _completionController.previous();
}