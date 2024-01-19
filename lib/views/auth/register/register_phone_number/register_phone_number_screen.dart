import 'package:country_flags/country_flags.dart';
import 'package:country_picker/country_picker.dart';
import 'package:ecinema_watch_together/services/app_services.dart';
import 'package:ecinema_watch_together/utils/app/app_assets.dart';
import 'package:ecinema_watch_together/utils/app/app_colors.dart';
import 'package:ecinema_watch_together/utils/app/app_constants.dart';
import 'package:ecinema_watch_together/utils/app/app_sizes.dart';
import 'package:ecinema_watch_together/utils/app/app_spaces.dart';
import 'package:ecinema_watch_together/views/auth/register/register_phone_number/register_phone_number_screen_controller.dart';
import 'package:ecinema_watch_together/widgets/buttons/custom_button.dart';
import 'package:ecinema_watch_together/widgets/text_styled.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_multi_formatter/flutter_multi_formatter.dart';
import 'package:get/get.dart';

class RegisterPhoneNumberScreen extends StatelessWidget {
  const RegisterPhoneNumberScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final sizes = AppSizes(context);
    final appBarHeight = sizes.statusBarHeight + AppConstants.appBarHeight;
    return GetBuilder(
      init: RegisterPhoneNumberScreenController(),
      builder: (controller) {
        final phoneFieldHasFocus = controller.phoneFieldHasFocus.value;
        final phoneNumber = controller.phoneNumber.value;
        final hasFocus = phoneNumber.isNotEmpty ? true : phoneFieldHasFocus;
        final errorText = controller.phoneFieldErrorText.value;
        final hasError = phoneNumber.isNotEmpty && errorText.isNotEmpty && !phoneFieldHasFocus;
        return GestureDetector(
          onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
          child: Scaffold(
            appBar: _appBar(appBarHeight, sizes.statusBarHeight),
            resizeToAvoidBottomInset: true,
            backgroundColor: AppColors.scaffoldBackgroundColor,
            body: Container(
              width: Get.width,
              height: Get.height - appBarHeight,
              padding: EdgeInsets.only(bottom: sizes.safePaddingBottom + 20),
              child: Column(
                children: [
                  Expanded(
                    child: GlowingOverscrollIndicator(
                      showLeading: false,
                      showTrailing: false,
                      axisDirection: AxisDirection.down,
                      color: AppColors.themeColor.withOpacity(.1),
                      child: SingleChildScrollView(
                        physics: const ClampingScrollPhysics(),
                        padding: const EdgeInsets.symmetric(vertical: 30),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SizedBox(width: Get.width,),
                            textStyled("HOŞGELDİN!", 36, AppColors.secondaryTextColor, fontWeight: FontWeight.w700, fontFamily: "Barlow"),
                            AppSpaces.vertical12,
                            textStyled("Kesintisiz deneyim için hemen giriş yap", 16, AppColors.greyTextColor,),
                            AppSpaces.vertical30,
                            GestureDetector(
                              onTap: () => showCountryPicker(
                                context: context,
                                favorite: [AppServices.locale.countryCode!],
                                countryListTheme: CountryListThemeData(
                                  bottomSheetHeight: Get.height * .8 <= 500 ? 500 : Get.height * .8,
                                  borderRadius: const BorderRadius.only(
                                    topLeft: Radius.circular(16),
                                    topRight: Radius.circular(16)
                                  ),
                                  searchTextStyle: const TextStyle(
                                    fontSize: 16,
                                    color: AppColors.whiteGrey,
                                    fontWeight: FontWeight.w500
                                  ),
                                  inputDecoration: InputDecoration(
                                    hintText: "Bir ülke kodu ara",
                                    hintStyle: const TextStyle(
                                      color: AppColors.greyTextColor,
                                      fontSize: 16
                                    ),
                                    prefixIcon: const Icon(
                                      CupertinoIcons.search,
                                      color: AppColors.whiteGrey,
                                      size: 22,
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      borderSide: const BorderSide(
                                        color: AppColors.blackGrey,
                                        width: 1
                                      )
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      borderSide: const BorderSide(
                                        color: AppColors.themeColor,
                                        width: 1
                                      )
                                    )
                                  ),
                                  textStyle: const TextStyle(
                                    color: AppColors.whiteGrey,
                                    fontSize: 16,
                                  )
                                ),
                                onSelect: controller.setSelectedCountry,
                              ),
                              child: Container(
                                height: 60.0,
                                width: Get.width - AppConstants.mHorizontalPadding * 2,
                                padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 10.0),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(
                                    color: AppColors.blackGrey,
                                    width: 1
                                  )
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          textStyled("Ülke", 14, AppColors.greyTextColor,),
                                          AppSpaces.vertical4,
                                          Expanded(
                                            child: Row(
                                              children: [
                                                CountryFlag.fromCountryCode(controller.selectedCountry.value?.countryCode ?? 'TR', width: 20, height: 15, borderRadius: 4,),
                                                AppSpaces.horizontal8,
                                                textStyled("+${controller.selectedCountry.value?.phoneCode} (${controller.selectedCountry.value?.name})", 16, AppColors.whiteGrey, fontWeight: FontWeight.w500)
                                              ],
                                            )
                                          )
                                        ],
                                      ),
                                    ),
                                    AppSpaces.horizontal20,
                                    const Icon(
                                      Icons.keyboard_arrow_down,
                                      color: AppColors.greyTextColor,
                                    )
                                  ],
                                )
                              ),
                            ),
                            AppSpaces.vertical12,
                            GestureDetector(
                              onTap: () => FocusScope.of(context).requestFocus(controller.phoneFocusNode),
                              child: Container(
                                height: 60.0,
                                width: Get.width - AppConstants.mHorizontalPadding * 2,
                                padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 10.0),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  // border: Border.all(
                                  //   color: hasError ? AppColors.errorColor.withOpacity(.4) : AppColors.borderColor,
                                    
                                  //   width: 1
                                  // ),
                                  border: Border.all(
                                    color: AppColors.blackGrey,
                                    width: 1
                                  )
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Stack(
                                        fit: StackFit.expand,
                                        children: [
                                          Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              AppSpaces.vertical16,
                                              Expanded(
                                                child: TextField(
                                                  // validator: (String? value) {
                                                  //   if(value == null) "Telefon numarası boş bırakılamaz";
                                                  //   return value!.length < 10 ? 'Minimum character length is 8' : null;
                                                  // },
                                                  onChanged: controller.setPhoneNumber,
                                                  keyboardType: TextInputType.phone,
                                                  focusNode: controller.phoneFocusNode,
                                                  controller: controller.phoneController,
                                                  onSubmitted: (value) => controller.submit(),
                                                  inputFormatters: <TextInputFormatter>[
                                                    MaskedInputFormatter('(###) ### ## ##', allowedCharMatcher: RegExp('[0-9]')),
                                                  ],
                                                  style: const TextStyle(
                                                    fontSize: 18,
                                                    fontFamily: "Roboto",
                                                    // color:  hasError ? AppColors.errorColor : AppColors.whiteGrey,
                                                    color:AppColors.whiteGrey,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                  decoration: const InputDecoration(
                                                    enabledBorder: InputBorder.none,
                                                    focusedBorder: InputBorder.none,
                                                    contentPadding: EdgeInsets.only(bottom: 13),
                                                  ),
                                                )
                                              )
                                            ],
                                          ),
                                          AnimatedPadding(
                                            duration: const Duration(milliseconds: 300),
                                            curve: Curves.fastEaseInToSlowEaseOut,
                                            padding: EdgeInsets.only(top: hasFocus ? 0 : 16),
                                            child: AnimatedScale(
                                              duration: const Duration(milliseconds: 300),
                                              curve: Curves.fastEaseInToSlowEaseOut,
                                              alignment: Alignment.centerLeft,
                                              scale: hasFocus ? .8 : 1,
                                              child:  textStyled("Telefon numarası", 18, hasFocus ? AppColors.greyTextColor : AppColors.whiteGrey, lineHeight: .6)
                                            ),
                                          ),
                                        ],
                                      )
                                    ),
                                    AppSpaces.horizontal20,
                                    AnimatedScale(
                                      scale: phoneNumber.isNotEmpty ? 1 : 0,
                                      curve: Curves.fastEaseInToSlowEaseOut,
                                      duration: const Duration(milliseconds: 300),
                                      child: Material(
                                        clipBehavior: Clip.hardEdge,
                                        borderRadius: BorderRadius.circular(8),
                                        color: AppColors.themeColor.withOpacity(.1),
                                        child: InkWell(
                                          onTap: controller.clearPhoneNumber,
                                          highlightColor: Colors.transparent,
                                          splashColor: Colors.black.withOpacity(.2),
                                          splashFactory: InkRipple.splashFactory,
                                          child: SizedBox(
                                            width: 30,
                                            height: 30,
                                            child: Center(
                                              child: Icon(
                                                Icons.close,
                                                color: AppColors.themeColor.withOpacity(.5),
                                                size: 16,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    )
                                  ],
                                )
                              ),
                            ),
                            AppSpaces.vertical10,
                            SizedBox(
                              height: 20,
                              child: hasError ? Align(
                                alignment: Alignment.topLeft,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: AppConstants.mHorizontalPadding),
                                  child: Row(
                                    children: [
                                      const Icon(
                                        CupertinoIcons.exclamationmark_circle,
                                        size: 14,
                                        color: AppColors.errorColor,
                                      ),
                                      AppSpaces.horizontal4,
                                      textStyled(errorText, 12, AppColors.errorColor)
                                    ],
                                  ),
                                )
                              ) : const SizedBox.shrink(),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  AppSpaces.vertical10,
                  // AnimatedOpacity(
                  //   duration: const Duration(milliseconds: 200),
                  //   opacity: phoneFieldHasFocus ? 0 : 1,
                  //   child: Column(
                  //     children: [
                  //       textStyled("Zaten bir hesabınız var mı?", 14, AppColors.greyTextColor,),
                  //       AppSpaces.vertical4,
                  //       OutlinedButton(
                  //         onPressed: RouteService.toLogin,
                  //         child: textStyled("Giriş yap", 14, AppColors.themeColor),
                  //       ),
                  //     ],
                  //   ),
                  // ),
                  // AppSpaces.vertical30,
                  CustomButton(
                    height: 52,
                    fontSize: 22,
                    onTap: controller.submit,
                    backgroundColor: controller.canSubmit ? AppColors.themeColor : AppColors.blackGrey,
                    textColor: controller.canSubmit ? AppColors.primaryButtonTextColor : AppColors.greyTextColor,
                    text: "DEVAM ET",
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

PreferredSize _appBar(double appBarHeight, double statusBarHeight) {
  return PreferredSize(
    preferredSize: Size.fromHeight(appBarHeight), 
    child: Container(
      width: Get.width,
      height: appBarHeight,
      padding: EdgeInsets.fromLTRB(AppConstants.mHorizontalPadding, statusBarHeight, AppConstants.mHorizontalPadding, 0),
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: AppColors.blackGrey,
            width: 1
          )
        )
      ),
      child: Center(
        child: Image.asset(AppAssets.logoText, width: 160,),
      ),
    ), 
  );
}