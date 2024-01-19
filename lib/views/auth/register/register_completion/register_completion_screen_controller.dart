import 'dart:async';
import 'dart:math';
import 'package:ecinema_watch_together/controlllers/auth_controller.dart';
import 'package:ecinema_watch_together/dal/user_dal.dart';
import 'package:ecinema_watch_together/entities/firestore/user_entity.dart';
import 'package:ecinema_watch_together/services/password_service.dart';
import 'package:ecinema_watch_together/utils/app/app_constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:ecinema_watch_together/views/auth/register/register_completion/steps/password/password_step.dart';
import 'package:ecinema_watch_together/controlllers/loading_controller.dart';
import 'package:ecinema_watch_together/views/auth/register/register_completion/steps/birthdate/birthdate_step.dart';
import 'package:ecinema_watch_together/views/auth/register/register_completion/steps/favourites/favourites_step.dart';
import 'package:ecinema_watch_together/views/auth/register/register_completion/steps/gender/gender_step.dart';
import 'package:ecinema_watch_together/views/auth/register/register_completion/steps/name/name_step.dart';

class RegisterCompletionScreenController extends GetxController {

  @override
  void onInit() {
    animateLoader(false);
    super.onInit();
  }

  PageController pageController = PageController();
  var user = Rx<Map<String, dynamic>>({
    "username": "",
    "gender": null,
    "birthdate": null,
    "favourites": <String>[]
  });

  var currentStep = 1.obs;
  var loader = (0.0).obs;
  var loading = false.obs;

  final steps = const [
    NameStep(),
    GenderStep(),
    BirthdateStep(),
    FavouritesStep(),
    PasswordStep(),
  ];

  void setUser(Map<String, dynamic> data) {
    user.value = {...user.value, ...data};
    update();
  }

  void setStep(int index) {
    final isBack = currentStep.value > index + 1;
    currentStep.value = index + 1;
    animateLoader(isBack);
    update();
  }

  void animateLoader(bool isBack) {
    final startStep = isBack ? currentStep.value + 1 : currentStep.value - 1;
    final start = (startStep/steps.length).toDouble();
    final end = ((currentStep.value)/steps.length).toDouble();
    final diff = end - start;
    print("START: $start, END: $end, DIFF: $diff, DIFF_/_10: ${diff/10}");
    loader.value = start;
    update();
    Timer.periodic(const Duration(milliseconds: 20), (timer) {
      final willAdd = diff/10;
      if(isBack) {
        if(loader.value + willAdd <= end) {
          loader.value = end;
          print("LOADER_VALUE: ${loader.value}");
          update();
          return timer.cancel();
        }
      } else {
        if(loader.value + willAdd >= end) {
          loader.value = end;
          print("LOADER_VALUE: ${loader.value}");
          update();
          return timer.cancel();;
        }
      }
      loader.value += diff/10;
      print("LOADER_VALUE: ${loader.value}");
      update();
    });
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

  Future<bool> onWillPop() async {
    if(currentStep.value > 0) {
      previous();
    }
    return false;
  }

  void next() => pageController.nextPage(duration: const Duration(milliseconds: 500), curve: Curves.fastEaseInToSlowEaseOut);
  void previous() => pageController.previousPage(duration: const Duration(milliseconds: 500), curve: Curves.fastEaseInToSlowEaseOut);

  String _getRandomAvatar(String gender) {
    var rg = Random();
    switch(gender) {
      case 'M':
        final avatar = AppConstants.manAvatarsStartingPoint + rg.nextInt(AppConstants.manAvatars);
        return avatar.toString();
      case 'W':
        final avatar = AppConstants.womanAvatarsStartingPoint + rg.nextInt(AppConstants.womanAvatars);
        return avatar.toString();
      case 'N' || '':
        final avatar = AppConstants.noGenderAvatarsStartingPoint + rg.nextInt(AppConstants.noGenderAvatars);
        return avatar.toString();
      default:
        final avatar = AppConstants.noGenderAvatarsStartingPoint + rg.nextInt(AppConstants.noGenderAvatars);
        return avatar.toString();
    }
  }

  Future<void> complete(String password) async {
    _startLoading();
    try {
      final authController = Get.find<AuthController>();
      final firebaseUser = authController.firebaseUser.value;
      print("CURRENT_USER: ${FirebaseAuth.instance.currentUser}");
      final passwordService = PasswordService();
      final hashedPassword = passwordService.encrypt(password);
      final UserEntity appUser = UserEntity(id: firebaseUser!.uid, username: user.value['username'].toString().trim(), phoneNumber: firebaseUser.phoneNumber!, gender: user.value['gender'], bio: "", avatar: _getRandomAvatar(user.value['gender']), useAvatar: true, profilePhotos: null, profilePhotoAvatar: null, notificationDetails: NotificationDetails(message: true, visitor: false, promotion: true, system: true), isVerified: false, isPremium: false, coins: 0, matchDetail: MatchDetail(match: "", isMatching: false), hashedPassword: hashedPassword, birthdate: user.value['birthdate'], isOnline: true, lastLoggedAt: DateTime.now(), lastLoggedOutAt: null, createdAt: DateTime.now(), updatedAt: null);
      await firebaseUser.updateDisplayName(user.value['username']);
      await UserDal.instance.insertById(firebaseUser.uid, appUser);
      authController.appUser.value = appUser;
    } catch (err) {
      print("ERROR_WHEN_SAVE_USER_TO_FIREBASE: $err");
      Get.snackbar("Hata", "Bir hata ile karşılaşıldı, lütfen tekrar deneyin.", backgroundColor: Colors.white);
    } finally {
      _stopLoading();
    }
  }
}