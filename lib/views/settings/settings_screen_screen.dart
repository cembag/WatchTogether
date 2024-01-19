import 'package:ecinema_watch_together/views/settings/settings_screen_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
      init: SettingScreenController(),  
      builder: (controller) {
        return Container(
          child: Text(
            "Settings Screen"
          ),
        );
      },
    );
  }
}