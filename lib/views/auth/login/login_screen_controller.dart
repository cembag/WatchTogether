import 'package:ecinema_watch_together/controlllers/loading_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

const digitsLength = 6;

class LoginScreenController extends GetxController {

  final focusNodes = List.generate(digitsLength, (index) => FocusNode());
  final textEditingControllers = List.generate(digitsLength, (index) => TextEditingController());
  final numKeys = ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9"];
  var loading = false.obs;
  var failedTries = 0.obs;
  var focusIndex = 0.obs;

  bool get canSubmit {
    if(loading.value) return false;
    return hasDigitsFilled;
  }

  bool get hasFocus {
    var has = false;
    for(final node in focusNodes) {
      if(node.hasFocus) {
        has = true;
      }
    }
    return has;
  }

  bool get hasDigitsFilled {
    var hasFilled = true;
    for(final controller in textEditingControllers) {
      if(controller.text.isEmpty) {
        hasFilled = false;
      }
    }
    return hasFilled;
  }

  bool getCanFocus(int index) {
    print(index);
    var canFocus = true;
    if(index < 0 || index > digitsLength - 1) return false;
    for(var i = 0; i < index; i++) {
      if(textEditingControllers[i].text.isEmpty) {
        canFocus = false;
      }
    }
    for(var i = index + 1; i < digitsLength; i++) {
      if(textEditingControllers[i].text.isNotEmpty) {
        canFocus = false;
      }
    }
    return canFocus;
  } 

  void setFocus(int index) async {
    final canFocus = getCanFocus(index);
    if(!canFocus) {
      if(hasDigitsFilled) {
        focusNodes[digitsLength - 1].requestFocus();
      } else {
        focusNodes[index].unfocus();
      }
      return;
    }
    focusNodes[index].requestFocus();
    focusIndex.value = index;
    update();
  }

  void onTextFieldChanged(String text, int index) {
    textEditingControllers[index].text = text;
    update();
    if(index == 0) return;
    if(index == digitsLength - 1 && text.isNotEmpty) {
      submit();
    } else if (text.isNotEmpty) {
      setFocus(index + 1);
    } else {
      setFocus(index - 1);
    }
  }

  void clearDigits() {
    for(final controller in textEditingControllers) {
      controller.text = "";
    }
    update();
  }

  void onKey(RawKeyEvent event) {
    final label = event.data.logicalKey.keyLabel;
    if(label == "Backspace") {
      if(focusIndex.value == 0) return;
      if(textEditingControllers[focusIndex.value].text.isEmpty) {
        setFocus(focusIndex.value - 1);
      }
    } else if(numKeys.contains(label)){
      if(focusIndex.value == digitsLength - 1) return;
      if(focusIndex.value == 0 && textEditingControllers.first.text.isEmpty) {
        textEditingControllers.first.text = label;
        setFocus(focusIndex.value + 1);
      }
      if(textEditingControllers[focusIndex.value].text.isNotEmpty) {
        setFocus(focusIndex.value + 1);
      }
    }
  }

  void startLoading() {
    LoadingController.showLoading();
    loading.value = true;
  }

  void stopLoading() {
    LoadingController.hideLoading();
    loading.value = false;
  }

  Future<void> submit() async {
    if(!canSubmit) return;
    startLoading();
    // clearDigits();
    await Future.delayed(const Duration(seconds: 1));
    stopLoading();
    failedTries.value += 1;
    update();
  }
}