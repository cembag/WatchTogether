import 'package:ecinema_watch_together/services/time_service.dart';
import 'package:ecinema_watch_together/utils/app/app_colors.dart';
import 'package:ecinema_watch_together/utils/app/app_constants.dart';
import 'package:ecinema_watch_together/utils/app/app_sizes.dart';
import 'package:ecinema_watch_together/utils/app/app_spaces.dart';
import 'package:ecinema_watch_together/views/auth/register/register_verify_phone_number/register_verify_phone_number_controller.dart';
import 'package:ecinema_watch_together/widgets/buttons/custom_button.dart';
import 'package:ecinema_watch_together/widgets/text_styled.dart';
// import 'package:ecinema_watch_together/utils/app/app_constants.dart';
// import 'package:ecinema_watch_together/widgets/text_styled.dart';
// import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

const digitsLength = 6;
const maxDigitWidth = 52.0;
const digitPadding = 8.0;

class RegisterVerifyPhoneNumberScreen extends StatelessWidget {
  final String phoneNumber;
  final int remaining;
  const RegisterVerifyPhoneNumberScreen({super.key, required this.phoneNumber, required this.remaining});

  @override
  Widget build(BuildContext context) {
    final sizes = AppSizes(context);
    final appBarHeight = sizes.statusBarHeight + AppConstants.appBarHeight;
    final digitWidth = ((Get.width - AppConstants.mHorizontalPadding * 2) - ((digitsLength - 1) * digitPadding))/6 > maxDigitWidth ? maxDigitWidth : ((Get.width - AppConstants.mHorizontalPadding * 2) - ((digitsLength - 1) * digitPadding))/6;
    // final customKeyboardWidth =(Get.width - AppConstants.mHorizontalPadding * 2) > 420.0 ? 420.0 : Get.width - AppConstants.mHorizontalPadding * 2;
    // final customKeyboardPadding = (Get.width - customKeyboardWidth)/2;
    return GetBuilder(
      init: RegisterVerifyPhoneNumberScreenController(phoneNumber: phoneNumber,remaining: remaining),
      builder: (controller) {
        print("SET_STATE");
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
              backgroundColor: AppColors.scaffoldBackgroundColor,
              appBar: _appBar(appBarHeight, sizes.statusBarHeight),
              body: Container(
                width: Get.width,
                height: Get.height,
                padding: EdgeInsets.only(bottom: sizes.safePaddingBottom + 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    AppSpaces.vertical8,
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: AppConstants.mHorizontalPadding * 2),
                      child: Column(
                        children: [
                          textStyled("TELEFON NUMARANI DOĞRULA!", 36, AppColors.secondaryTextColor, fontWeight: FontWeight.w700, fontFamily: "Barlow", textAlign: TextAlign.center),
                          AppSpaces.vertical12,
                          RichText(
                            textAlign: TextAlign.center,
                            text: TextSpan(
                              text: "Lütfen ",
                              style: const TextStyle(
                                fontSize: 14,
                                color: AppColors.greyTextColor
                              ),
                              children: [
                                TextSpan(
                                  text: "+$phoneNumber ",
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w500,
                                    color: AppColors.whiteGrey
                                  )
                                ),
                                const TextSpan(
                                  text: " numaralı telefona gelen 6 haneli onay kodunu gir"
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
                    if(controller.remainingTime.value > 0) 
                    textStyled('${TimeService.secondsToMMss(controller.remainingTime.value)} saniye içinde tekrar gönderilebilir', 13, AppColors.greyTextColor),
                    if(controller.remainingTime.value <= 0)
                    OutlinedButton(
                      onPressed: controller.sendSMS, 
                      child: textStyled("Tekrar sms gönder", 14, AppColors.themeColor)
                    ),
                    // textStyled("Lütfen telefonuna gelen 6 haneli onay kodunu gir", 14, AppColors.greyTextColor,),
                    // AppSpaces.vertical12,
                    // textStyled("+$phoneNumber", 14, AppColors.primaryTextColor, fontWeight: FontWeight.w500),
                    AppSpaces.expandedSpace,
                    // SizedBox(
                    //   width: customKeyboardWidth,
                    //   // color: Colors.red,
                    //   child: GridView.builder(
                    //     itemCount: 12,
                    //     shrinkWrap: true,
                    //     gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3, mainAxisSpacing: 4.0, crossAxisSpacing: 8.0, childAspectRatio: 2.2),
                    //     padding: const EdgeInsets.all(0),
                    //     itemBuilder: (context, index) {
                    //       if(index == 9) return const SizedBox.shrink();
                    //       final char = index == 10 ? "0" : (index + 1).toString();
                    //       return Material(
                    //         clipBehavior: Clip.hardEdge,
                    //         color: Colors.black.withOpacity(.2),
                    //         borderRadius: BorderRadius.circular(customKeyboardWidth/32),
                    //         child: InkWell(
                    //           onTap: () {},
                    //           highlightColor: Colors.transparent,
                    //           splashFactory: InkRipple.splashFactory,
                    //           splashColor: Colors.black,
                    //           child: SizedBox(
                    //             child: Center(
                    //               child: index < 11
                    //               ? textStyled(char, 18, AppColors.whiteGrey, fontWeight: FontWeight.w500)
                    //               : const Icon(
                    //                 CupertinoIcons.delete_left,
                    //                 size: 22,
                    //                 color: AppColors.whiteGrey,
                    //               ),
                    //             ),
                    //           ),
                    //         ),
                    //       );
                    //     },
                    //   ),
                    // ),
                    AppSpaces.vertical20,
                    CustomButton(
                      height: 52,
                      fontSize: 22,
                      backgroundColor: controller.canSubmit ? AppColors.themeColor : AppColors.blackGrey,
                      textColor: controller.canSubmit ? AppColors.primaryButtonTextColor : AppColors.greyTextColor,
                      text: "DOĞRULA",
                      onTap: controller.canSubmit ? controller.submit : null,
                    )
                  ],
                ),
              )
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
      height: appBarHeight,
      width: Get.width,
      // decoration: const BoxDecoration(
      //   border: Border(
      //     bottom: BorderSide(
      //       color: AppColors.borderColor,
      //       width: 1
      //     )
      //   )
      // ),
      // color: Colors.red,
      padding: EdgeInsets.fromLTRB(AppConstants.mHorizontalPadding, statusBarHeight, AppConstants.mHorizontalPadding, 0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Material(
            clipBehavior: Clip.hardEdge,
            color: AppColors.goBackButtonBackgroundColor,
            // color: AppColors.themeColor.withOpacity(.1),
            borderRadius: BorderRadius.circular(12),
            child: InkWell(
              onTap: () => Get.back(),
              highlightColor: Colors.transparent,
              splashFactory: InkRipple.splashFactory,
              // splashColor: AppColors.themeColor.withOpacity(.2),
              splashColor: AppColors.scaffoldSplashColor,
              child: const SizedBox(
                width: 42,
                height: 42,
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
          // textStyled("Doğrulama", 14, AppColors.primaryTextColor, fontWeight: FontWeight.w500),
          // Image.asset(AppAssets.logoText, width: 140,),
          const SizedBox(
            width: 42,
            height: 42,
          )
        ],
      ),
    ),
  );
}

