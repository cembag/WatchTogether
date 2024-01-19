import 'package:firebase_auth/firebase_auth.dart';

class ErrorService {

  static String convertPhoneAuthError(FirebaseAuthException e) {
    switch(e.code) {
      case 'invalid-phone-number':
        return "Girilen numara geçerli bir numara değil.";
      case 'too-many-requests':
        return "Olağan dışı etkinlik nedeniyle bu cihazdan gelen tüm istekleri engelledik. Daha sonra tekrar deneyin.";
      default:
        return "Bir şeyler ters gitti, daha sonra tekrar deneyin.";
    } 
  }
}