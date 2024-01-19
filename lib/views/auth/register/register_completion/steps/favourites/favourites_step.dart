import 'package:ecinema_watch_together/utils/app/app_colors.dart';
import 'package:ecinema_watch_together/utils/app/app_constants.dart';
import 'package:ecinema_watch_together/utils/app/app_spaces.dart';
import 'package:ecinema_watch_together/views/auth/register/register_completion/steps/favourites/favourites_step_controller.dart';
import 'package:ecinema_watch_together/widgets/buttons/custom_button.dart';
import 'package:ecinema_watch_together/widgets/text_styled.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FavouritesStep extends StatelessWidget {
  const FavouritesStep({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
      init: FavouritesStepController(),
      builder: (controller) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppConstants.mHorizontalPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              textStyled("Favorilerilerini seç", 36, AppColors.secondaryTextColor, fontWeight: FontWeight.w700, fontFamily: "Barlow", lineHeight: 1.1),
              AppSpaces.vertical6,
              textStyled("Favorin olan üç adet film türü seç, sonradan değiştirilebilir.", 16, AppColors.greyTextColor,),
              AppSpaces.vertical16,
              Expanded(
                child: ScrollConfiguration(
                  behavior: const ScrollBehavior(),
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.only(top: 8, bottom: 8),
                    child: GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: controller.movieCategories.length,
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, mainAxisSpacing: 8.0, crossAxisSpacing: 8.0, childAspectRatio: 2),
                      itemBuilder: (context, index) {
                        final category = controller.movieCategories[index];
                        final isSelected = controller.favourites.value.contains(category);
                        return GestureDetector(
                          onTap: () => controller.updateFavourites(category),
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              color: isSelected ? AppColors.themeColor.withOpacity(.1) : AppColors.onScaffoldBackgroundColor,
                            ),
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                Positioned(
                                  left: 24,
                                  bottom: 42,
                                  child: textStyled(category, 16, AppColors.secondaryTextColor, fontWeight: FontWeight.w600),
                                ),
                                Positioned(
                                  bottom: 12,
                                  right: 24,
                                  child: Image.asset("assets/images/ic_icon-${AppConstants.movieCategoriesEnglish[index].toLowerCase()}.png", width: 42, color: isSelected ? AppColors.themeColor : AppColors.blackGrey,),
                                ),
                                if(isSelected)
                                checkIcon(),
                                Positioned.fill(
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(12),
                                      color: Colors.transparent,
                                      border: Border.all(
                                        color: isSelected ? AppColors.themeColor : AppColors.cardColor,
                                        width: 2
                                      )
                                    ),
                                  ),
                                )
                              ],
                            )
                          ),
                        );
                      },
                    )
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
                text: controller.favourites.value.length < 3 ? "${controller.favourites.value.length}/3 SEÇİLDİ" : "DEVAM ET",
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