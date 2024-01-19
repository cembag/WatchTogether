import 'package:ecinema_watch_together/utils/app/app_colors.dart';
import 'package:ecinema_watch_together/utils/app/app_constants.dart';
import 'package:ecinema_watch_together/utils/app/app_spaces.dart';
import 'package:ecinema_watch_together/views/auth/register/register_completion/register_completion_screen_controller.dart';
import 'package:ecinema_watch_together/views/auth/register/register_completion/steps/password/password_step_controller.dart';
import 'package:ecinema_watch_together/widgets/buttons/custom_button.dart';
import 'package:ecinema_watch_together/widgets/text_styled.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

const digitsLength = 6;
const maxDigitWidth = 52.0;
const digitPadding = 8.0;

class PasswordStep extends StatelessWidget {
  const PasswordStep({super.key});

  @override
  Widget build(BuildContext context) {
     final digitWidth = ((Get.width - AppConstants.mHorizontalPadding * 2) - ((digitsLength - 1) * digitPadding))/6 > maxDigitWidth ? maxDigitWidth : ((Get.width - AppConstants.mHorizontalPadding * 2) - ((digitsLength - 1) * digitPadding))/6;
    return GetBuilder(
      init: PasswordStepController(),
      builder: (controller) {
        final registerCompletionController = RegisterCompletionScreenController();
        final digits = List.generate(digitsLength, (index) {
          return Container(
            width: digitWidth,
            height: digitWidth,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: AppColors.primaryTextColor,
                width: 2
              ),
              color: controller.focusNodes[index].hasFocus ? AppColors.blackGrey : Colors.grey,
            ),
            child: TextField(
              focusNode: controller.focusNodes[index],
              controller: controller.textEditingControllers[index],
              onChanged: (value) => controller.onTextFieldChanged(value, index),
              obscureText: !controller.isVisible.value,
              style: const TextStyle(
                color: AppColors.primaryTextColor,
                fontSize: 28,
                fontWeight: FontWeight.w500
              ),
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly
              ],
              textAlign: TextAlign.center,
              maxLength: 1,
              showCursor: false,
              decoration: const InputDecoration(
                contentPadding: EdgeInsets.all(0),
                counterText: "",
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none
              ),
            ),
          );
        });


        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppConstants.mHorizontalPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              textStyled("Dijital parolanı oluştur", 32, AppColors.secondaryTextColor, fontWeight: FontWeight.w700, fontFamily: "Barlow", lineHeight: 1.1),
              AppSpaces.vertical6,
              textStyled("Giriş yaparken kullanacağın altı haneli şifreni gir.", 16, AppColors.greyTextColor,),
              AppSpaces.vertical24,
              // AppSpaces.vertical30,
              SizedBox(
                width: Get.width,
                height: digitWidth,
                child: Center(
                  child: ListView.separated(
                    shrinkWrap: true,
                    itemCount: digitsLength,
                    scrollDirection: Axis.horizontal,
                    separatorBuilder: (context, index) => AppSpaces.customWidth(digitPadding),
                    itemBuilder: (context, index) => digits[index],
                  ),
                ),
              ),
              AppSpaces.vertical12,
              GestureDetector(
                onTap: controller.toggleVisibility,
                child: Align(
                  alignment: Alignment.centerRight,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      textStyled(controller.isVisible.value ? "Gizle" : "Göster", 14, AppColors.greyTextColor, fontWeight: FontWeight.w600),
                      AppSpaces.horizontal10,
                      Material(
                        clipBehavior: Clip.hardEdge,
                        color: AppColors.greyTextColor.withOpacity(.1),
                        borderRadius: BorderRadius.circular(8),
                        child: InkWell(
                          onTap: controller.toggleVisibility,
                          splashFactory: InkRipple.splashFactory,
                          highlightColor: Colors.transparent,
                          splashColor: AppColors.greyTextColor.withOpacity(.1),
                          child: SizedBox(
                            width: 36,
                            height: 36,
                            child: Center(
                              child: Icon(
                                controller.isVisible.value ? CupertinoIcons.eye_slash : CupertinoIcons.eye,
                                size: 20,
                                color: AppColors.greyTextColor,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  )
                ),
              ),
              AppSpaces.expandedSpace,
              AppSpaces.vertical16,
              CustomButton(
                height: 52,
                fontSize: 22,
                onTap: () => controller.canSubmit ? registerCompletionController.complete(controller.password) : null,
                backgroundColor: controller.canSubmit ? AppColors.themeColor : AppColors.blackGrey,
                textColor: controller.canSubmit ? AppColors.primaryButtonTextColor : AppColors.greyTextColor,
                text: "KAYDINI TAMAMLA"
              ),
            ],
          ),
        );
      },
    );
  }
}