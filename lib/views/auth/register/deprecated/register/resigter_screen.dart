import 'package:ecinema_watch_together/services/app_services.dart';
import 'package:ecinema_watch_together/utils/app/app_colors.dart';
import 'package:ecinema_watch_together/utils/app/app_sizes.dart';
import 'package:ecinema_watch_together/views/auth/register/deprecated/register/register_screen_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final sizes = AppSizes(context);
    return GetBuilder(
      init: RegisterScreenController(),
      builder: (controller) {
        return GestureDetector(
          onTap: () => AppServices.unfocus(),
          child: Scaffold(
            backgroundColor: AppColors.scaffoldBackgroundColor,
            body: Padding(
              padding: EdgeInsets.only(top: sizes.statusBarHeight, bottom: sizes.safePaddingBottom + 20),
              child: const Column(
                children: [
                  
                ],
              ),
            )
          ),
        );
      },
    );
  }
}