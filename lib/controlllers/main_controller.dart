import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecinema_watch_together/controlllers/loading_controller.dart';
import 'package:ecinema_watch_together/dal/cinema_dal.dart';
import 'package:ecinema_watch_together/entities/firestore/cinema_entity.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class MainController extends GetxController {

  @override
  void onInit() {
    _setup();
    super.onInit();
  }

  // final authController = Get.find<AuthController>();

  // User? get firebaseUser => authController.firebaseUser.value;
  // UserEntity? get appUser => authController.appUser.value;

  var cinemas = Rx<List<CinemaEntity>?>(null);
  var hasCinemasInitialized = false.obs;
  var loading = false.obs;

  Future<void> _setup() async {
    if(loading.value) return;
    try {
      await _initCinemas();
    } on FirebaseException catch (err) {
      print("ERRROR: $err");
    }
  }

  Future<void> _initCinemas() async {
    print("INIT CINEMAS");
    cinemas.value = await CinemaDal.instance.getAll();
    hasCinemasInitialized.value = true;
    update();
  }

  void _startLoading() {
    LoadingController.showLoading();
    loading.value = true;
    update();
  }

  void _stopLoading() {
    LoadingController.showLoading();
    loading.value = false;
    update();
  }

  Future<void> addToCinemas() async {
    final cinemaDal = CinemaDal();
    await cinemaDal.insert(CinemaEntity.sampleCinema);
    print("Added to cinemas");
  }
}