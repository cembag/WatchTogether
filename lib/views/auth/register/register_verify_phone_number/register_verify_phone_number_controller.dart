import 'dart:async';
import 'package:ecinema_watch_together/controlllers/loading_controller.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:ecinema_watch_together/dal/auth_dal.dart';
import 'package:ecinema_watch_together/services/app_services.dart';
import 'package:get_storage/get_storage.dart';

const digitsLength = 6;
const timePeriod = 90;
const lastSentStorageKey = 'sms_last_sent_at';

class RegisterVerifyPhoneNumberScreenController extends GetxController {
  final String phoneNumber;
  final int remaining;
  RegisterVerifyPhoneNumberScreenController({required this.phoneNumber, required this.remaining});

  @override
  void onInit() {
    _init();
    super.onInit();
  }

  @override
  void onClose() {
    for(var focusNode in focusNodes) {
      focusNode.dispose();
    }
    for(var controller in textEditingControllers) {
      controller.dispose();
    }
    super.onClose();
  }

  Timer? counter;
  final storage = GetStorage();
  final focusNodes = List.generate(digitsLength, (index) => FocusNode());
  final textEditingControllers = List.generate(digitsLength, (index) => TextEditingController());
  final numKeys = ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9"];
  var loading = false.obs;
  var remainingTime = 0.obs;
  var focusIndex = 0.obs;

  String get otpCode => textEditingControllers.map((e) => e.text).join("");

  bool get canSubmit {
    if(loading.value) return false;
    var canSubmit = true;
    for(final controller in textEditingControllers) {
      if(controller.text.isEmpty) {
        canSubmit = false;
      }
    }
    return canSubmit;
  }

  Future<void> _init() async {
    focusNodes[0].requestFocus();
    setRemainingTime(remaining);
    if(remaining == 0) {
      return await sendSMS();
    }
  }

  void _createCounter() {
    counter ??= Timer.periodic(const Duration(seconds: 1), (timer) { 
      remainingTime.value -= 1;
      update();
      if(remainingTime.value == 0) {
        timer.cancel();
        counter = null;
      }
    });
  }

  Future<void> sendSMS() async {
    // send sms
    setRemainingTime(timePeriod);
    try {
      AuthDal.instance.verifyPhoneNumber(phoneNumber);
      await storage.write(lastSentStorageKey, DateTime.now().toIso8601String());
    } on FirebaseAuthException catch (e) {
      setRemainingTime(0);
      if(e.code == 'invalid-phone-number') {
        Get.snackbar("Hata", "Girilen numara geçerli bir numara değil.", backgroundColor: Colors.white);
      } else if(e.code == 'too-many-requests') {
        Get.snackbar("Hata", "Olağan dışı etkinlik nedeniyle bu cihazdan gelen tüm istekleri engelledik. Daha sonra tekrar deneyin.", backgroundColor: Colors.white);
      } else {
        print("ERROR: $e");
        Get.snackbar("Hata", "Bir şeyler ters gitti, daha sonra tekrar deneyin.", backgroundColor: Colors.white);
      }
    }
  }

  void setRemainingTime(int time) {
    remainingTime.value = time;
    update();
    if(time != 0) _createCounter();
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
    AppServices.unfocus();
    try {
      await AuthDal.instance.verifyOTP(otpCode);
      // final userCredential = await AuthDal.instance.verifyOTP(otpCode);
    } on FirebaseAuthException catch (err) {
      _onSubmitError(err);
    } finally {
      stopLoading();
    }
  }

  _onSubmitError(FirebaseAuthException err) {
    print("PHONE_AUTH_LOGIN_WITH_PHONE_NUMBER_ERROR: ${err.code}: ${err.message}");
    final errorMessage = _getErrorMessage(err);
    Get.snackbar("Hata", errorMessage, backgroundColor: Colors.white);
    clearDigits();
  }

  _getErrorMessage(FirebaseAuthException err) {
    print("ERR: ${err.message}");
    switch(err.code) {
      case 'channel-error':
        return 'Kanal doğrulama hatası, lütfen başka bir zaman tekrar deneyiniz';
      default:
        return "Doğrulama kodu hatalı";
    }
  }
}