import 'package:ecinema_watch_together/entities/firestore/user_entity.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';

class StorageService {

  static final _storage = GetStorage();

  Future<ThemeMode> get prefferedTheme async {
    final prefferedTheme_ = await _storage.read('preffered_theme');
    return _themeModeFromString(prefferedTheme_);
  }

  Future<String?> get prefferedLanguage async {
    final prefferedLanguage_ = await _storage.read('preffered_language');
    if(prefferedLanguage_ == null) return null;
    return prefferedLanguage_;
  }

  Future<UserEntity?> get user async {
    final user_ = await _storage.read('user');
    if(user_ == null) return null;
    return UserEntity.fromJson(user_);
  }

  Future<String?> get token async {
    final token_ = await _storage.read('token');
    if(token_ == null) return null;
    return token_;
  }

  Future<bool> get isFirst async {
    final isFirst_ = await _storage.read('is_first');
    if(isFirst_ == null) return true;
    return isFirst_;
  }

  Future<void> setPrefferedTheme(ThemeMode themeMode) async {
    await _storage.write('preffered_theme', _themeModeToString(themeMode));
    await _storage.save();
  }

  Future<void> setPrefferedLanguage(String language) async {
    await _storage.write('preffered_language', language);
    await _storage.save();
  }

  Future<void> setIsFirst(bool isFirst) async {
    await _storage.write('is_first', isFirst);
    await _storage.save();
  }

  Future<void> setUser(UserEntity? user) async {
    await _storage.write('user', user?.toJson);
    await _storage.save();
  }

  Future<void> deleteUser() async {
    await _storage.remove('user');
    await _storage.save();
  }

  Future<void> setToken(String token) async {
    await _storage.write('token', token);
    await _storage.save();
  }

  Future<void> deleteToken() async {
    await _storage.remove('token');
    await _storage.save();
  }
}

String _themeModeToString(ThemeMode themeMode) {
  switch(themeMode) {
    case ThemeMode.dark:
      return "dark";
    case ThemeMode.light:
      return "light";
    case ThemeMode.system:
      return "system";
  }
}

ThemeMode _themeModeFromString(String themeMode) {
  switch(themeMode) {
    case "dark":
      return ThemeMode.dark;
    case "light":
      return ThemeMode.light;
    case "system":
      return ThemeMode.system;
    default:
      return ThemeMode.system;
  }
} 