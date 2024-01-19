import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecinema_watch_together/controlllers/auth_controller.dart';
import 'package:ecinema_watch_together/entities/firestore/user_entity.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class AppLifecycleService {
  static AppLifecycleService get instance => AppLifecycleService();

  final authController = Get.find<AuthController>();

  User? get firebaseUser => authController.firebaseUser.value;
  UserEntity? get appUser => authController.appUser.value;
  String get userId => firebaseUser!.uid;

  Future<void> handleTransition(String transition) async {
    print("LIFECYCLESTATE: $transition");
    switch(transition) {
      case 'detach':
        return await _onDetach();
      case 'resume':
        return await _onResume();
      case 'inactive':
        return await _onInactive();
      case 'hide':
        return await _onHide();
      case 'restart':
        return await _onRestart();
      case 'pause':
        return await _onPause();
      case 'show':
        return await _onShow();
    }
  }

  Future<void> _onShow() async {

  }

  Future<void> _onRestart() async {

  }

  Future<void> _onPause() async {

  }
 
  Future<void> _onInactive() async {

  }
 
  Future<void> _onHide() async {

  }

  Future<void> _onDetach() async {
    if(firebaseUser == null) return;
    if(appUser!.isOnline) {
      await FirebaseFirestore.instance.collection('users').doc(userId).update({"is_online": false});
    }
  }

  Future<void> _onResume() async {
    if(!appUser!.isOnline) {
      await FirebaseFirestore.instance.collection('users').doc(userId).update({"is_online": true});
    }
  }
}