import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:ecinema_watch_together/services/app_services.dart';
import 'package:ecinema_watch_together/views/auth/register/register_completion/register_completion_screen_controller.dart';

class BirthdateStepController extends GetxController {

  @override
  void onInit() {
    birthdate.value = _completionController.user.value['birthdate'];
    initializeDateFormatting ('${AppServices.locale.languageCode}_${AppServices.locale.countryCode}');
    super.onInit();
  }
  var loading = false.obs;
  final _completionController = Get.find<RegisterCompletionScreenController>();
  var birthdate = Rx<DateTime?>(null);
  
  bool get canNext => birthdate.value != null && !loading.value;

  void setGender(DateTime date) {
    birthdate.value = date;
    update();
  }

  void previous() => _completionController.previous();

  Future<void> next() async {
    if(!canNext) return;
    _completionController.setUser({"birthdate": birthdate.value});
    _completionController.next();
  }

  Future<void> pickDate() async {
    const youngestAge = 8;
    const oldestAge = 120;
    final now = DateTime.now();
    final pickedDate = await showDatePicker(context: Get.context!, locale: AppServices.locale, initialEntryMode: DatePickerEntryMode.calendar, initialDate: birthdate.value ?? DateTime.now().add(const Duration(days: 365 * -youngestAge)), firstDate: now.add(const Duration(days: 365 * -oldestAge)), lastDate: now.add(const Duration(days: 365 * -youngestAge)));
    if(pickedDate == null) return;
    birthdate.value = pickedDate;
    update();
  }
}