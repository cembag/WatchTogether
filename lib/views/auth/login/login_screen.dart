import 'package:ecinema_watch_together/services/route_service.dart';
import 'package:ecinema_watch_together/utils/app/app_assets.dart';
import 'package:ecinema_watch_together/utils/app/app_colors.dart';
import 'package:ecinema_watch_together/utils/app/app_constants.dart';
import 'package:ecinema_watch_together/utils/app/app_sizes.dart';
import 'package:ecinema_watch_together/utils/app/app_spaces.dart';
import 'package:ecinema_watch_together/views/auth/login/login_screen_controller.dart';
import 'package:ecinema_watch_together/widgets/buttons/custom_button.dart';
import 'package:ecinema_watch_together/widgets/text_styled.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

const digitsLength = 6;
const maxDigitWidth = 52.0;
const digitPadding = 8.0;

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final sizes = AppSizes(context);
    final appBarHeight = sizes.statusBarHeight + AppConstants.appBarHeight;
    final digitWidth = ((Get.width - AppConstants.mHorizontalPadding * 2) - ((digitsLength - 1) * digitPadding))/6 > maxDigitWidth ? maxDigitWidth : ((Get.width - AppConstants.mHorizontalPadding * 2) - ((digitsLength - 1) * digitPadding))/6;
    return GetBuilder(
      init: LoginScreenController(),
      builder: (controller) {

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
              color: controller.focusNodes[index].hasFocus ? AppColors.greyTextColor : Colors.grey,
            ),
            child: TextField(
              onTap: () => controller.setFocus(index),
              focusNode: controller.focusNodes[index],
              controller: controller.textEditingControllers[index],
              onChanged: (value) => controller.onTextFieldChanged(value, index),
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

        return GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: RawKeyboardListener(
            autofocus: true,
            focusNode: FocusNode(),
            onKey: controller.onKey,
            child: Scaffold(
              appBar: _appBar(appBarHeight, sizes.statusBarHeight),
              backgroundColor: AppColors.scaffoldBackgroundColor,
              body: Container(
                width: Get.width,
                height: Get.height - appBarHeight,
                padding: EdgeInsets.only(bottom: sizes.safePaddingBottom + 20),
                child: Column(
                  children: [
                    Expanded(
                      child: SizedBox(
                        width: Get.width,
                        child: ScrollConfiguration(
                          behavior: const ScrollBehavior(),
                          child: GlowingOverscrollIndicator(
                            showLeading: false,
                            showTrailing: false,
                            color: AppColors.themeColor,
                            axisDirection: AxisDirection.down,
                            child: SingleChildScrollView(
                              physics: const ClampingScrollPhysics(),
                              padding: const EdgeInsets.only(top: 30, bottom: 30),
                              child: Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: AppConstants.mHorizontalPadding * 2),
                                    child: Column(
                                      children: [
                                        textStyled("GİRİŞ YAP", 36, AppColors.secondaryTextColor, fontWeight: FontWeight.w700, fontFamily: "Barlow", textAlign: TextAlign.center),
                                        AppSpaces.vertical12,
                                        RichText(
                                          textAlign: TextAlign.center,
                                          text: const TextSpan(
                                            text: "Lütfen oluşturduğun 6 haneli ",
                                            style: TextStyle(
                                              fontSize: 14,
                                              color: AppColors.greyTextColor
                                            ),
                                            children: [
                                              TextSpan(
                                                text: "dijital kodu ",
                                                style: TextStyle(
                                                  fontWeight: FontWeight.w500,
                                                  color: AppColors.whiteGrey
                                                )
                                              ),
                                              TextSpan(
                                                text: "gir"
                                              )
                                            ]
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  AppSpaces.vertical30,
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
                                  AppSpaces.vertical16,
                                  // Container(
                                  //   height: 30,
                                  //   padding: EdgeInsets.symmetric(horizontal: (Get.width - digitWidth * 6 - digitPadding * 5)/2),
                                  //   child: Align(
                                  //     alignment: Alignment.center,
                                  //     child: controller.failedTries.value > 0 
                                  //     ? Row(
                                  //       mainAxisSize: MainAxisSize.min,
                                  //       children: [
                                  //         Container(
                                  //           padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                                  //           decoration: BoxDecoration(
                                  //             borderRadius: BorderRadius.circular(6),
                                  //             color: controller.failedTries.value == 1 ? Colors.yellow.shade900.withOpacity(.1) : AppColors.errorColor.withOpacity(.1),
                                  //           ),
                                  //           child: Row(
                                  //             children: [
                                  //               // const Icon(
                                  //               //   CupertinoIcons.exclamationmark_circle,
                                  //               //   size: 14,
                                  //               //   color: AppColors.errorColor,
                                  //               // ),
                                  //               // AppSpaces.horizontal4,
                                  //               textStyled("${controller.failedTries.value} Başarısız deneme", 12, controller.failedTries.value == 1 ? Colors.yellow.shade900 : AppColors.errorColor, fontWeight: FontWeight.w500)
                                  //             ],
                                  //           )
                                  //         )
                                  //       ],
                                  //     ) : const SizedBox.shrink(),
                                  //   )
                                  // ),
                                  if(controller.failedTries.value > 0)
                                  Padding(
                                    padding: EdgeInsets.symmetric(horizontal: (Get.width - digitWidth * 6 - digitPadding * 5)/2),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(6),
                                            color: controller.failedTries.value == 1 ? Colors.yellow.shade900.withOpacity(.1) : AppColors.errorColor.withOpacity(.1),
                                          ),
                                          child: textStyled("${controller.failedTries.value} Başarısız deneme", 12, controller.failedTries.value == 1 ? Colors.yellow.shade900 : AppColors.errorColor, fontWeight: FontWeight.w500)
                                        ),
                                        AppSpaces.vertical8,
                                        Container(
                                          width: double.infinity,
                                          padding: const EdgeInsets.all(AppConstants.mHorizontalPadding),
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(12),
                                            color: AppColors.onScaffoldBackgroundColor
                                          ),
                                          child: textStyled("Hesap güvenliğiniz adına art arda 3 defa yapılan şifre denemesinden sonra hesabınız 1(bir) günlüğüne kilitlenecektir. Eğer şifrenizin doğruluğundan emin değilseniz lütfen şifremi unuttum butonuna tıklayınız.", 12, Colors.grey, fontWeight: FontWeight.w500),
                                        ),
                                      ],
                                    ),
                                  ),
                                  AppSpaces.vertical12,
                                  OutlinedButton(
                                    onPressed: RouteService.toLogin,
                                    child: textStyled("Şifremi unuttum", 14, AppColors.themeColor),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    AppSpaces.vertical10,
                    // AnimatedOpacity(
                    //   duration: const Duration(milliseconds: 200),
                    //   opacity: controller.hasFocus ? 0 : 1,
                    //   child: Column(
                    //     children: [
                    //       textStyled("Bir hesaba sahip değil misin?", 14, AppColors.greyTextColor,),
                    //       AppSpaces.vertical4,
                    //       OutlinedButton(
                    //         onPressed: Get.back,
                    //         child: textStyled("Kayıt ol", 14, AppColors.themeColor),
                    //       ),
                    //     ],
                    //   ),
                    // ),
                    // AppSpaces.vertical30,
                    CustomButton(
                      height: 52,
                      fontSize: 22,
                      backgroundColor: controller.canSubmit ? AppColors.themeColor : AppColors.blackGrey,
                      textColor: controller.canSubmit ? AppColors.primaryButtonTextColor : AppColors.greyTextColor,
                      text: "GİRİŞ YAP",
                      onTap: controller.canSubmit ? controller.submit : null,
                    ),
                  ],
                ),
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
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: AppColors.borderColor,
            width: 1
          )
        )
      ),
      padding: EdgeInsets.fromLTRB(AppConstants.mHorizontalPadding, statusBarHeight, AppConstants.mHorizontalPadding, 0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Material(
          //   clipBehavior: Clip.hardEdge,
          //   color: AppColors.blackGrey,
          //   // color: AppColors.themeColor.withOpacity(.1),
          //   borderRadius: BorderRadius.circular(12),
          //   child: InkWell(
          //     onTap: () => Get.back(),
          //     highlightColor: Colors.transparent,
          //     splashFactory: InkRipple.splashFactory,
          //     // splashColor: AppColors.themeColor.withOpacity(.2),
          //     splashColor: AppColors.scaffoldSplashColor,
          //     child: const SizedBox(
          //       width: 42,
          //       height: 42,
          //       child: Center(
          //         child: Icon(
          //           Icons.arrow_back,
          //           // color: AppColors.themeColor,
          //           color: Colors.grey,
          //           size: 20,
          //         ),
          //       ),
          //     ),
          //   ),
          // ),
          // textStyled("Giriş yap", 16, AppColors.primaryTextColor, fontWeight: FontWeight.w500,),
          const SizedBox(
            width: 42,
            height: 42,
          ),
          Image.asset(AppAssets.logoText, width: 160,),
          const SizedBox(
            width: 42,
            height: 42,
          )
        ],
      ),
    ),
  );
}