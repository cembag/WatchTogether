import 'dart:convert';
import 'package:ecinema_watch_together/entities/firestore/abuse_entity.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/foundation.dart';

class RemoteConfigService {
  static RemoteConfigService get instance => RemoteConfigService();
  static final FirebaseRemoteConfig _remoteConfigService = FirebaseRemoteConfig.instance;

  static Map<String, dynamic> get translations => jsonDecode(_remoteConfigService.getString('translations'));

  Future<void> initialize() async {
    try {
      final configSettings = RemoteConfigSettings(fetchTimeout: const Duration(seconds: 1), minimumFetchInterval: const Duration(seconds: !kReleaseMode ? 0 : 3600));
      await _remoteConfigService.setConfigSettings(configSettings);
      await _remoteConfigService.fetchAndActivate();
    } catch (err) {
      print("ERR WHEN INITIALIZE REMOTE CONFIG");
    }
  }

  // static Map<String, dynamic> _abuseMapFromCode(int abuseCode) => jsonDecode((translations['abuse_$abuseCode'] as String).replaceAll("'", '"'));
  static Map<String, dynamic> _abuseMapFromCode(int abuseCode) => translations['abuse_$abuseCode'];
  static AbuseEntity _abuseEntityFromMap(Map<String, dynamic> json) => AbuseEntity(name: json['name'], code: json['code'], mainAbuse: json['main_abuse'], description: json['description'], url: json['url'], notAlloweds: json['not_alloweds'] == null ? null : <String>[...json['not_alloweds']], subAbuses: json['sub_abuses'] == null ? null : (json['sub_abuses'] as List<dynamic>).map((e) => _abuseEntityFromMap(_abuseMapFromCode(e))).toList());

  AbuseEntity getAbuse(int abuseCode) {
    final json = _abuseMapFromCode(abuseCode);
    return _abuseEntityFromMap(json);
  }
}