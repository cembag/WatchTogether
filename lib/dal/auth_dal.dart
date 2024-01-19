import 'package:ecinema_watch_together/controlllers/auth_controller.dart';
import 'package:ecinema_watch_together/services/error_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class AuthDal {
  static AuthDal get instance => AuthDal();

  static final _firebaseAuth = FirebaseAuth.instance;
  static final _authController = Get.find<AuthController>();

  static User? get currentUser => _firebaseAuth.currentUser;
  final _storage = GetStorage();

  Future<void> signOut() async => await _firebaseAuth.signOut();

  Future<void> signInWithPhoneNumber(String phoneNumber) async => await _firebaseAuth.signInWithPhoneNumber(phoneNumber);

  Future<void> verifyPhoneNumber(String phoneNumber) async {
    await _firebaseAuth.verifyPhoneNumber(
      phoneNumber: '+$phoneNumber',
      verificationCompleted: (PhoneAuthCredential credential) async {
        await _firebaseAuth.signInWithCredential(credential);
      },
      verificationFailed: (FirebaseAuthException e) async {
        Get.back();
        final err = ErrorService.convertPhoneAuthError(e);
        print("ERROR_CODE: ${e.code}, ERROR_MESSAGE: ${e.message}");
        Get.snackbar("Hata", err, backgroundColor: Colors.white);
        await _storage.write("last_sms_error", err);
      },
      codeSent: (String verificationId, int? resendToken) async {
        _authController.verificationId.value = verificationId;
        await _storage.write("last_sms_error", null);
      },
      codeAutoRetrievalTimeout: (String verificationId) async {
        _authController.verificationId.value = verificationId;
        await _storage.write("last_sms_error", null);
      },
    );
  }

  Future<UserCredential> verifyOTP(String otp) async => await _firebaseAuth.signInWithCredential(PhoneAuthProvider.credential(verificationId: _authController.verificationId.value, smsCode: otp));
}