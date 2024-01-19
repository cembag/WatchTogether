import 'package:ecinema_watch_together/utils/app/app_colors.dart';
import 'package:ecinema_watch_together/utils/app/app_constants.dart';
import 'package:ecinema_watch_together/utils/app/app_spaces.dart';
import 'package:ecinema_watch_together/views/auth/register/register_completion/steps/name/name_step_controller.dart';
import 'package:ecinema_watch_together/widgets/buttons/custom_button.dart';
import 'package:ecinema_watch_together/widgets/text_styled.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class NameStep extends StatelessWidget {
  const NameStep({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
      init: NameStepController(),
      builder: (controller) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppConstants.mHorizontalPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              textStyled("Kullanıcı adın ne olsun?", 36, AppColors.secondaryTextColor, fontWeight: FontWeight.w700, fontFamily: "Barlow", lineHeight: 1.1),
              AppSpaces.vertical6,
              textStyled("Bu isimle tanınacaksın, sonradan değiştirilebilir.", 16, AppColors.greyTextColor,),
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    if(controller.focusNode.hasFocus) {
                      controller.focusNode.unfocus();
                    } else {
                      controller.focusNode.requestFocus();
                    }
                  },
                  child: Container(
                    width: Get.width,
                    color: Colors.transparent,
                    child: Center(
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: AppColors.onScaffoldBackgroundColor,
                        ),
                        child: IntrinsicWidth(
                          child: TextField(
                            focusNode: controller.focusNode,
                            controller: controller.textEditingController,
                            onSubmitted: (value) => controller.next(),
                            onChanged: controller.onTextChanged,
                            inputFormatters: [
                              FilteringTextInputFormatter.deny(RegExp(r'\s')),
                            ],
                            style: const TextStyle(
                              color: AppColors.whiteGrey2,
                              fontSize: 22,
                              fontWeight: FontWeight.w600,
                            ),
                            decoration: const InputDecoration(
                              contentPadding: EdgeInsets.only(bottom: 1),
                              enabledBorder: InputBorder.none,
                              focusedBorder: InputBorder.none
                            ),
                          ),
                        ),
                      )
                    ),
                  ),
                ),
              ),
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