import 'package:ecinema_watch_together/utils/app/app_colors.dart';
import 'package:ecinema_watch_together/utils/app/app_constants.dart';
import 'package:ecinema_watch_together/utils/app/app_spaces.dart';
import 'package:ecinema_watch_together/views/auth/register/register_completion/steps/birthdate/birthdate_step_controller.dart';
import 'package:ecinema_watch_together/widgets/buttons/custom_button.dart';
import 'package:ecinema_watch_together/widgets/text_styled.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class BirthdateStep extends StatelessWidget {
  const BirthdateStep({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
      init: BirthdateStepController(),
      builder: (controller) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppConstants.mHorizontalPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              textStyled("Doğum tarihin ne?", 36, AppColors.secondaryTextColor, fontWeight: FontWeight.w700, fontFamily: "Barlow", lineHeight: 1.1),
              AppSpaces.vertical6,
              textStyled("Watch Together sadece sekiz yaş üstü insanlar için kullanıma uygundur.", 16, AppColors.greyTextColor,),
              AppSpaces.vertical16,
              Expanded(
                child: Center(
                  child: controller.birthdate.value == null
                  ? OutlinedButton(
                    onPressed: () => controller.pickDate(),
                    child: textStyled("Doğum tarihini seç", 14, AppColors.themeColor),
                  )
                  : Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: AppColors.onScaffoldBackgroundColor
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                        child: textStyled(DateFormat("dd MMMM yyyy", "tr-TR").format(controller.birthdate.value!), 22, AppColors.whiteGrey2, fontWeight: FontWeight.w600),
                      ),
                      AppSpaces.vertical4,
                      TextButton(
                        onPressed: () => controller.pickDate(),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            textStyled("Doğum tarihini değiştir", 14, AppColors.themeColor),
                            AppSpaces.horizontal6,
                            const Icon(
                              Icons.edit,
                              size: 16,
                              color: AppColors.themeColor,
                            )
                          ],
                        )
                      )
                    ],
                  )
                )
              ),
              AppSpaces.vertical16,
              CustomButton(
                height: 52,
                fontSize: 22,
                onTap: controller.canNext ? controller.next : null,
                backgroundColor: controller.canNext ? AppColors.themeColor : AppColors.blackGrey,
                textColor: controller.canNext ? AppColors.primaryButtonTextColor : AppColors.greyTextColor,
                text: "DEVAM ET",
              ),
            ],
          ),
        );
      },
    );
  }
}

Widget checkIcon() {
  return Positioned(
    right: 24,
    child: Container(
      width: 20,
      height: 20,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        color: AppColors.themeColor,
      ),
      child: const Center(
        child: Icon(
          Icons.check,
          color: AppColors.cardColor,
          size: 16,
        ),
      ),
    ),
  );
}