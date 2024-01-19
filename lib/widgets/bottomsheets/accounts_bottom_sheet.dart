import 'package:ecinema_watch_together/dal/auth_dal.dart';
import 'package:ecinema_watch_together/entities/firestore/user_entity.dart';
import 'package:ecinema_watch_together/utils/app/app_colors.dart';
import 'package:ecinema_watch_together/utils/app/app_constants.dart';
import 'package:ecinema_watch_together/utils/app/app_spaces.dart';
import 'package:ecinema_watch_together/widgets/buttons/custom_button.dart';
import 'package:ecinema_watch_together/widgets/modals/snackbar_modal.dart';
import 'package:ecinema_watch_together/widgets/text_styled.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AccountsBottomSheet extends StatefulWidget {
  final UserEntity user;
  const AccountsBottomSheet({super.key, required this.user});

  @override
  State<AccountsBottomSheet> createState() => _AccountsBottomSheetState();
}

class _AccountsBottomSheetState extends State<AccountsBottomSheet> {

  int selectedQuestionIndex = -1;

  void setSelectedQuestionIndex(int index) {
    if(index == selectedQuestionIndex) {
      setState(() {
        selectedQuestionIndex = -1;
      });
    } else {
      setState(() {
        selectedQuestionIndex = index;
      });
    }
  }

  @override 
  Widget build(BuildContext context) {
    final safePaddingBottom = MediaQuery.of(context).padding.bottom;
    return Container(
      width: Get.width,
      height: 274 + safePaddingBottom,
      decoration: const BoxDecoration(
        color: AppColors.cardColor,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(12),
          topRight: Radius.circular(12)
        ),
      ),
      child: Column(
        children: [
          SizedBox(
            width: Get.width,
            height: 60,
            child: Column(
              children: [
                const SizedBox(height: 5),
                Center(
                  child: Container(
                    width: 50,
                    height: 5,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: AppColors.blackGrey
                    ),
                  ),
                ),
                Container(
                  width: Get.width,
                  height: 50,
                  padding: const EdgeInsets.fromLTRB(20, 0, 10, 0),
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color: AppColors.borderColor,
                        width: 1
                      )
                    )
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      textStyled("Hesabım", 17, AppColors.whiteGrey2, fontWeight: FontWeight.w700),
                      Material(
                        color: Colors.transparent,
                        clipBehavior: Clip.hardEdge,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50),
                        ),
                        child: InkWell(
                          highlightColor: Colors.transparent,
                          splashFactory: InkRipple.splashFactory,
                          splashColor: Colors.black26,
                          onTap: () => Navigator.of(context).pop(),
                          child: const SizedBox(
                            width: 42,
                            height: 42,
                            child: Icon(
                              Icons.close,
                              color: AppColors.greyTextColor,
                              size: 24,
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
          Container(
            width: double.infinity,
            height: 84,
            padding: const EdgeInsets.all(AppConstants.mHorizontalPadding),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: AppColors.borderColor,
                  width: 1
                ),
              )
            ),
            child: Row(
              children: [
                // ClipOval(
                //   child: widget.user.profilePhoto == null ? Image.asset("assets/images/avatars/ic_icon-avatar${widget.user.avatar}.png", width: 52, height: 52, fit: BoxFit.cover,) : Image.network(widget.user.avatar, width: 52, height: 52, fit: BoxFit.cover,),
                // ),
                AppSpaces.horizontal16,
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      textStyled(widget.user.username, 18, AppColors.secondaryTextColor, fontWeight: FontWeight.w600),
                      AppSpaces.vertical4,
                      textStyled(widget.user.phoneNumber, 15, AppColors.greyTextColor, fontWeight: FontWeight.w500),
                    ],
                  ),
                ),
                // Material(
                //   clipBehavior: Clip.hardEdge,
                //   color: AppColors.errorColor,
                //   borderRadius: BorderRadius.circular(12),
                //   child: InkWell(
                //     onTap: AuthDal.instance.signOut,
                //     splashColor: Colors.black26,
                //     highlightColor: Colors.transparent,
                //     splashFactory: InkRipple.splashFactory,
                //     child: const SizedBox(
                //       width: 42,
                //       height: 42,
                //       child: Center(
                //         child: Icon(
                //           Icons.logout,
                //           size: 18,
                //           color: AppColors.whiteGrey2,
                //         ),
                //       ),
                //     ),
                //   ),
                // )
              ],
            ),
          ),
          // AppSpaces.vertical16,
          // ScreenSection(
          //   header: "Ayarlar",
          //   showHeader: false,
          //   verticalPadding: 0,
          //   child: Column(
          //     children: [
          //       _setting(AppAssets.iconUser, "Bilgilerimi güncelle", () {}, hasBorder: true),
          //       // _setting(AppAssets.iconQuestion, "Sık sorulan sorular", () {}),
          //       _quitButton(context),
          //       // _deleteButton(context),
          //     ],
          //   )
          // ),
          AppSpaces.vertical24,
          CustomButton(
            onTap: () => _showAreYouSureToQuitModal(context),
            height: 42,
            backgroundColor: Colors.red,
            text: "Çıkış yap",
          ),
          AppSpaces.vertical6,
          CustomButton(
            onTap: () => _showDeleteAccountModal(context),
            height: 42,
            backgroundColor: const Color.fromARGB(255, 134, 24, 14),
            text: "Hesabı sil",
          ),
          AppSpaces.customHeight(safePaddingBottom + AppConstants.mHorizontalPadding),
          // Expanded(
          //   child: ScrollConfiguration(
          //     behavior: const ScrollBehavior(),
          //     child: GlowingOverscrollIndicator(
          //       showTrailing: false,
          //       showLeading: false,
          //       axisDirection: AxisDirection.down,
          //       color: Colors.transparent,
          //       child: ListView.builder(
          //         scrollDirection: Axis.vertical,
          //         physics: const ClampingScrollPhysics(),
          //         padding: EdgeInsets.only(bottom: safePaddingBottom + 30),
          //         itemCount: sampleFrequentlyAskedQuestions.length,
          //         itemBuilder: (context, index) {
          //           final question = sampleFrequentlyAskedQuestions[index];
          //           final isSelected = selectedQuestionIndex == index;
          //           return _questionWidget(question, index, isSelected);
          //         },
          //       )
          //     ),
          //   ),
          // ),
        ],
      ),
    );
  }
}

_showDeleteAccountModal(BuildContext context) {
  showSnackbarModal(
    context: context,
    title: "Hesap sil",
    message: "Şu anda bu özelliğimiz kullanılamamaktadır, hesabınızı silmek istiyorsanız bizimle iletişime geçebilirsiniz",
    content: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(40),
            border: Border.all(
              color: AppColors.borderColor,
              width: 1
            )
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.mail,
                size: 14,
                color: AppColors.whiteGrey2,
              ),
              AppSpaces.horizontal6,
              textStyled("howtocenteradiv@gmail.com", 14, const Color.fromRGBO(160, 160, 160, 1), fontWeight: FontWeight.w500)
            ],
          ),
        ),
        AppSpaces.vertical4,
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(40),
            border: Border.all(
              color: AppColors.borderColor,
              width: 1
            )
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.phone,
                size: 14,
                color: AppColors.secondaryTextColor,
              ),
              AppSpaces.horizontal6,
              textStyled("905378688105", 14, const Color.fromRGBO(160, 160, 160, 1), fontWeight: FontWeight.w500)
            ],
          ),
        )
      ],
    )
  );
}

_showAreYouSureToQuitModal(BuildContext context) {
  showSnackbarModal(
    context: context, 
    title: "Çıkış yap",
    message: "Çıkış yapmak istediğinize emin misiniz?",
    actions: [
      SnackbarAction(
        onTap: AuthDal.instance.signOut,
        text: "Eminim, çıkış yap",
        backgroundColor: Colors.red,
      ),
      SnackbarAction(
        onTap: () => Navigator.of(context).pop(),
        text: "İptal",
        backgroundColor: AppColors.blackGrey
      ),
    ]
  );
}

Widget _setting(String iconPath, String text, void Function() onTap, {bool hasBorder = false}) {
  return Material(
    color: const Color.fromARGB(255, 20, 20, 20),
    child: InkWell(
      onTap: onTap,
      highlightColor: Colors.transparent,
      splashFactory: InkRipple.splashFactory,
      splashColor: AppColors.scaffoldSplashColor,
      child: Container(
        width: double.infinity,
        height: 50,
        padding: const EdgeInsets.symmetric(horizontal: AppConstants.mHorizontalPadding),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: AppColors.borderColor,
              width: 1
            ),
            top: BorderSide(
              color: hasBorder ? AppColors.borderColor : Colors.transparent,
              width: 1
            )
          )
        ),
        child: Row(
          children: [
            Image.asset(iconPath, height: 18, color: AppColors.whiteGrey,),
            AppSpaces.horizontal20,
            textStyled(text, 14, AppColors.whiteGrey, fontWeight: FontWeight.w600)
          ],
        ),
      ),
    ),
  );
}

Widget _quitButton(BuildContext context) {
  return Material(
    color: const Color.fromARGB(255, 20, 20, 20),
    child: InkWell(
      onTap: AuthDal.instance.signOut,
      splashColor: const Color(0xFFFF8686).withOpacity(.2),
      highlightColor: Colors.transparent,
      splashFactory: InkRipple.splashFactory,
      child: Container(
        width: double.infinity,
        height: 50,
        decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: AppColors.borderColor,
            width: 1
          )
        )
      ),
        padding: const EdgeInsets.symmetric(horizontal: AppConstants.mHorizontalPadding),
        child: Row(
          children: [
            const Icon(
              Icons.logout,
              color: Color(0xFFFF8686),
              size: 22,
            ),
            AppSpaces.horizontal20,
            textStyled("Çıkış yap", 14, const Color(0xFFFF8686), fontWeight: FontWeight.w600)
          ],
        ),
      ),
    ),
  );
}

void showAccountsBottomSheet(BuildContext context, UserEntity user) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    useRootNavigator: true,
    backgroundColor: Colors.transparent,
    builder: (context) => AccountsBottomSheet(
      user: user,
    )
  );
}

