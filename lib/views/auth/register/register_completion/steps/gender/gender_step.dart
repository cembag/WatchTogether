import 'package:ecinema_watch_together/utils/app/app_assets.dart';
import 'package:ecinema_watch_together/utils/app/app_colors.dart';
import 'package:ecinema_watch_together/utils/app/app_constants.dart';
import 'package:ecinema_watch_together/utils/app/app_spaces.dart';
import 'package:ecinema_watch_together/widgets/buttons/custom_button.dart';
import 'package:ecinema_watch_together/widgets/text_styled.dart';
import 'package:flutter/material.dart';
import 'gender_step_controller.dart';
import 'package:get/get.dart';

class GenderStep extends StatelessWidget {
  const GenderStep({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
      init: GenderStepController(),
      builder: (controller) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppConstants.mHorizontalPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              textStyled("Cinsiyetin ne?", 36, AppColors.secondaryTextColor, fontWeight: FontWeight.w700, fontFamily: "Barlow", lineHeight: 1.1),
              AppSpaces.vertical6,
              textStyled("Cinsiyet bilgisini kullanıcı deneyimini iyileştirmek için kullanıyoruz.", 16, AppColors.greyTextColor,),
              AppSpaces.vertical16,
              Expanded(
                child: ScrollConfiguration(
                  behavior: const ScrollBehavior(),
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.only(top: 8, bottom: 8),
                    child: Column(
                      children: [
                        GestureDetector(
                          onTap: () => controller.setGender("W"),
                          child: Container(
                            height: 120,
                            width: double.infinity,
                            clipBehavior: Clip.hardEdge,
                            decoration: BoxDecoration(
                              // color: controller.selectedGender.value == "W" ? AppColors.themeColor.withOpacity(.1) : AppColors.onScaffoldBackgroundColor,
                              color: controller.selectedGender.value == "W" ? AppColors.themeColor.withOpacity(.1) : AppColors.completionCardColor,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                Positioned(
                                  left: 24,
                                  child: textStyled("Kadın", 16, AppColors.secondaryTextColor, fontWeight: FontWeight.w600),
                                ),
                                Positioned(
                                  bottom: -5,
                                  right: 12,
                                  child: SizedBox(
                                    width: 100,
                                    height: 100,
                                    child: Image.asset(AppAssets.iconFemale),
                                  )
                                ),
                                if(controller.selectedGender.value == "W")
                                checkIcon(),
                                Positioned.fill(
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(12),
                                      color: Colors.transparent,
                                      border: Border.all(
                                        color: controller.selectedGender.value == "W" ? AppColors.themeColor : AppColors.cardColor,
                                        width: 2
                                      )
                                    ),
                                  ),
                                )
                              ],
                            )
                          ),
                        ),
                        AppSpaces.vertical8,
                        GestureDetector(
                          onTap: () => controller.setGender("M"),
                          child: Container(
                            height: 120,
                            width: double.infinity,
                            clipBehavior: Clip.hardEdge,
                            decoration: BoxDecoration(
                              color: controller.selectedGender.value == "M" ? AppColors.themeColor.withOpacity(.1) : AppColors.onScaffoldBackgroundColor,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                Positioned(
                                  left: 24,
                                  child: textStyled("Erkek", 16, AppColors.secondaryTextColor, fontWeight: FontWeight.w600),
                                ),
                                Positioned(
                                  bottom: -5,
                                  right: 12,
                                  child: SizedBox(
                                    width: 100,
                                    height: 100,
                                    child: Image.asset(AppAssets.iconMale),
                                  )
                                ),
                                if(controller.selectedGender.value == "M")
                                checkIcon(),
                                Positioned.fill(
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(12),
                                      color: Colors.transparent,
                                      border: Border.all(
                                        color: controller.selectedGender.value == "M" ? AppColors.themeColor : AppColors.cardColor,
                                        width: 2
                                      )
                                    ),
                                  ),
                                )
                              ],
                            )
                          ),
                        ),
                        AppSpaces.vertical8,
                        GestureDetector(
                          onTap: () => controller.setGender("N"),
                          child: Container(
                            height: 80,
                            width: double.infinity,
                            clipBehavior: Clip.hardEdge,
                            decoration: BoxDecoration(
                              color: controller.selectedGender.value == "N" ? AppColors.themeColor.withOpacity(.1) : AppColors.onScaffoldBackgroundColor,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                Positioned(
                                  left: 24,
                                  child: textStyled("İkisi de değil", 16, AppColors.secondaryTextColor, fontWeight: FontWeight.w600),
                                ),
                                if(controller.selectedGender.value == "N")
                                checkIcon(),
                                Positioned.fill(
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(12),
                                      color: Colors.transparent,
                                      border: Border.all(
                                        color: controller.selectedGender.value == "N" ? AppColors.themeColor : AppColors.cardColor,
                                        width: 2
                                      )
                                    ),
                                  ),
                                )
                              ],
                            )
                          ),
                        ),
                        AppSpaces.vertical8,
                        GestureDetector(
                          onTap: () => controller.setGender(""),
                          child: Container(
                            height: 80,
                            width: double.infinity,
                            clipBehavior: Clip.hardEdge,
                            decoration: BoxDecoration(
                              color: controller.selectedGender.value == "" ? AppColors.themeColor.withOpacity(.1) : AppColors.onScaffoldBackgroundColor,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                Positioned(
                                  left: 24,
                                  child: textStyled("Söylememeyi tercih ediyorum", 16, AppColors.secondaryTextColor, fontWeight: FontWeight.w600)
                                ),
                                if(controller.selectedGender.value == "")
                                checkIcon(),
                                Positioned.fill(
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(12),
                                      color: Colors.transparent,
                                      border: Border.all(
                                        color: controller.selectedGender.value == "" ? AppColors.themeColor : AppColors.cardColor,
                                        width: 2
                                      )
                                    ),
                                  ),
                                )
                              ],
                            )
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
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
    top: 1,
    right: 1,
    child: Container(
      width: 28,
      height: 28,
      decoration: const BoxDecoration(
        color: AppColors.themeColor,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(12),
          topRight: Radius.circular(12)
        )
      ),
      child: Center(
        child: Icon(
          Icons.check,
          color: AppColors.onScaffoldBackgroundColor,
          size: 16,
        ),
      ),
    ),
  );
}