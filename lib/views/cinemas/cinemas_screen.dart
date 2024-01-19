import 'package:ecinema_watch_together/views/cinemas/cinemas_screen_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/get_state_manager.dart';

class CinemasScreen extends StatelessWidget {
  const CinemasScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
      init: CinemasScreenController(),
      builder: (controller) {
        return Container(
          child: Text(
            "Cinemas Screen"
          ),
        );
      },
    );
  }
}