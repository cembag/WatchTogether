import 'dart:async';
import 'package:ecinema_watch_together/entities/firestore/user_entity.dart';
import 'package:ecinema_watch_together/services/app_services.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/date_symbol_data_local.dart';

const _kBarVisibleTime = 2.5;

class ProfilePhotoScreenController extends GetxController {
  final UserEntity user;
  ProfilePhotoScreenController({required this.user});

  @override
  void onInit() {
    initializeDateFormatting(AppServices.locale.languageCode);
    Future.delayed(const Duration(milliseconds: 300), showBar);
    ever(visibleTime, _onVisibleTimeChanged);
    super.onInit();
  }

  Timer? _visibilityTimer;
  var visibleTime = _kBarVisibleTime.obs;
  var barVisibility = false.obs;

  void _onVisibleTimeChanged(double time) {
    if(time <= 0) {
      _hideBar();
    } else {
      _initVisibilityTimer();
    }
  }

  void _initVisibilityTimer() {
    _visibilityTimer ??= Timer.periodic(const Duration(milliseconds: 100), (timer) { 
      if(visibleTime.value - .1 <= 0) {
        visibleTime.value = 0;
        timer.cancel();
        _visibilityTimer = null;
      } else {
        visibleTime.value -= .1;
      }
      update();
    });
  }

  void _hideBar() {
    if(isClosed) return;
    barVisibility.value = false;
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.leanBack, overlays: [SystemUiOverlay.top]);
    update();
  }

  void showBar() {
    visibleTime.value = _kBarVisibleTime;
    barVisibility.value = true;
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: [SystemUiOverlay.top]);
    update();
  }

  void toggleBar() {
    if(visibleTime.value > 0) {
      visibleTime.value = 0;
      update();
    } else {
      showBar();
    }
  }
}