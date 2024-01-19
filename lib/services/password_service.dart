import 'package:ecinema_watch_together/utils/app/app_environment.dart';
import 'package:encrypt/encrypt.dart';

class PasswordService {
  
  static Key get _key => Key.fromUtf8(AppEnvironment.passwordKey);
  final encrypter = Encrypter(AES(_key));
  final iv = IV.fromLength(16);

  String encrypt(String text) => encrypter.encrypt(text, iv: iv).base64;
  String decrypt(String base64) => encrypter.decrypt(Encrypted.from64(base64), iv: iv);
}