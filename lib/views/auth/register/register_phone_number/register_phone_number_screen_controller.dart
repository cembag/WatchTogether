import 'package:ecinema_watch_together/controlllers/loading_controller.dart';
import 'package:ecinema_watch_together/dal/auth_dal.dart';
import 'package:ecinema_watch_together/services/app_services.dart';
import 'package:ecinema_watch_together/services/route_service.dart';
import 'package:ecinema_watch_together/services/time_service.dart';
import 'package:get_storage/get_storage.dart';
import 'package:country_picker/country_picker.dart';
import 'package:ecinema_watch_together/services/validator_sevice.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


const lastSentStorageKey = 'sms_last_sent_at';
const timePeriod = 90;

class RegisterPhoneNumberScreenController extends GetxController {

  late final FocusNode phoneFocusNode;
  late final TextEditingController phoneController;

  @override
  void onInit() {
    super.onInit();
    _setup();
    _initLocale();
    phoneFocusNode.addListener(_onPhoneFocusChange);
  }

  @override
  void onClose() {
    super.onClose();
    print("REGISTER_PHONE_NUMBER_DELETED");
    phoneFocusNode.removeListener(_onPhoneFocusChange);
    phoneController.dispose();
    phoneFocusNode.dispose();
  }

  final _storage = GetStorage();
  var loading = false.obs;
  var phoneNumber = "".obs;
  var phoneFieldHasFocus = false.obs;
  var selectedCountry = Rx<Country?>(null);
  var phoneFieldErrorText = "".obs;

  String get phone => '${selectedCountry.value!.phoneCode}${phoneNumber.value.replaceAll("(", "").replaceAll(")", "").replaceAll(" ", "")}';
  bool get canSubmit => phoneNumber.isNotEmpty && phoneFieldErrorText.isEmpty && !loading.value;

  void _setup() {
    phoneFocusNode = FocusNode();
    phoneController = TextEditingController();
  }

  Future<int> _getSMSRemainingTime() async {
    final now = DateTime.now();
    final lastSentString = await _storage.read(lastSentStorageKey);
    if(lastSentString == null) return 0;
    final lastSent = DateTime.parse(lastSentString);
    if(now.difference(lastSent).inSeconds > timePeriod) return 0;
    return timePeriod - now.difference(lastSent).inSeconds;
  }

  void _onPhoneFocusChange() {
    phoneFieldHasFocus.value = phoneFocusNode.hasFocus;
    update();
  }

  void _initLocale() {
    if(Get.context == null) return;
    final country = CountryService().findByCode(AppServices.locale.countryCode ?? 'US');
    if(country == null) return;
    setSelectedCountry(country);
  }

  void setSelectedCountry(Country country) {
    selectedCountry.value = country;
    update();
  }

  void setPhoneNumber(String text) {
    validPhoneNumber(text);
    phoneNumber.value = text;
    update();
  }

  void clearPhoneNumber() {
    FocusScope.of(Get.context!).unfocus();
    phoneController.text = "";
    phoneNumber.value = "";
    update();
  }

  void validPhoneNumber(String text) {
    final errorText = ValidatorService(text: text).validatePhoneNumber();
    phoneFieldErrorText.value = errorText;
  }

  void _startLoading() {
    loading.value = true;
    LoadingController.showLoading();
    update();
  }

  void _stopLoading() {
    loading.value = false;
    LoadingController.hideLoading();
    update();
  }

  Future<void> submit() async {
    if(!canSubmit) return;
    _startLoading();
    try {
      // final firebaseUser = (await FirebaseFunctions.instance.httpsCallable('getFirebaseUserByPhoneNumber').call({"phoneNumber": "+$phone"})).data;
      // if(firebaseUser != null) {
      //   final hasAccount = await UserDal.instance.hasAccount(firebaseUser['uid']);
      //   if(hasAccount) {
      //     print("TO_LOGIN");
      //     RouteService.toLogin();
      //   } else {
      //     print("SIGNED_IN");
      //     await AuthDal.instance.verifyPhoneNumber(phone);
      //   } 
      //   return _stopLoading();
      // }
      final remainingTime = await _getSMSRemainingTime();
      final lastSMSError = await _storage.read("last_sms_error");
      if(remainingTime == 0) {
        AuthDal.instance.verifyPhoneNumber(phone);
        RouteService.toRegisterVerify(phone, remainingTime);
      } else if(lastSMSError != null) {
        Get.snackbar("Hata", lastSMSError + "\n\nTekrar denemeye kalan süre: ${TimeService.secondsToMMss(remainingTime)}", backgroundColor: Colors.white);
      } else {
        RouteService.toRegisterVerify(phone, remainingTime);
      }
    } catch(err) {
      print("ERROR: $err");
    } finally {
      _stopLoading();
    }
  }
}