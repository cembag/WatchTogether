import 'package:ecinema_watch_together/services/app_services.dart';
import 'package:ecinema_watch_together/utils/app/app_colors.dart';
import 'package:ecinema_watch_together/utils/app/app_constants.dart';
import 'package:ecinema_watch_together/utils/app/app_sizes.dart';
import 'package:ecinema_watch_together/utils/app/app_spaces.dart';
import 'package:ecinema_watch_together/views/auth/register/register_completion/register_completion_screen_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RegisterCompletionScreen extends StatelessWidget {
  const RegisterCompletionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final sizes = AppSizes(context);
    final appBarHeight = AppConstants.appBarHeight + sizes.statusBarHeight;
    return GetBuilder(
      init: RegisterCompletionScreenController(),
      builder: (controller) {
        return WillPopScope(
          onWillPop: controller.onWillPop,
          child: GestureDetector(
            onTap: AppServices.unfocus,
            child: Scaffold(
              appBar: _appBar(appBarHeight, sizes.statusBarHeight, controller.loader.value, controller),
              // backgroundColor: AppColors.scaffoldBackgroundColor,
              // backgroundColor: const Color.fromRGBO(20, 20, 24, 1),
              backgroundColor: AppColors.completionBackgroundColor,
              body: Padding(
                padding: EdgeInsets.only(top: 8, bottom: sizes.safePaddingBottom + 20),
                child: PageView.builder(
                  controller: controller.pageController,
                  physics: const NeverScrollableScrollPhysics(),
                  onPageChanged: controller.setStep,
                  itemCount: controller.steps.length,
                  itemBuilder: (context, index) {
                    return controller.steps[index];
                  },
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

PreferredSize _appBar(double appBarHeight, double statusBarHeight, double completion, RegisterCompletionScreenController controller) {
  return PreferredSize(
    preferredSize: Size.fromHeight(appBarHeight), 
    child: Container(
      width: Get.width,
      height: appBarHeight,
      padding: EdgeInsets.fromLTRB(AppConstants.mHorizontalPadding, statusBarHeight, AppConstants.mHorizontalPadding, 0),
      child: Row(
        children: [
          if(controller.currentStep.value > 1)
          Material(
            clipBehavior: Clip.hardEdge,
            color: AppColors.goBackButtonBackgroundColor,
            // color: AppColors.themeColor.withOpacity(.1),
            borderRadius: BorderRadius.circular(12),
            child: InkWell(
              onTap: controller.previous,
              highlightColor: Colors.transparent,
              splashFactory: InkRipple.splashFactory,
              // splashColor: AppColors.themeColor.withOpacity(.2),
              splashColor: AppColors.scaffoldSplashColor,
              child: const SizedBox(
                width: 40,
                height: 40,
                child: Center(
                  child: Icon(
                    Icons.arrow_back,
                    // color: AppColors.themeColor,
                    color: Colors.grey,
                    size: 20,
                  ),
                ),
              ),
            ),
          ),
          AppSpaces.expandedSpace,
          SizedBox(
            width: 24,
            height: 24,
            child: CircularProgressIndicator(
              backgroundColor: AppColors.scaffoldSplashColor,
              valueColor: const AlwaysStoppedAnimation(AppColors.themeColor),
              value: completion,
            ),
          )
        ],
      )
    ), 
  );
}
