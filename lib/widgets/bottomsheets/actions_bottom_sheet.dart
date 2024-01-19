import 'package:ecinema_watch_together/entities/app/content_type.dart';
import 'package:ecinema_watch_together/entities/firestore/user_entity.dart';
import 'package:ecinema_watch_together/utils/app/app_assets.dart';
import 'package:ecinema_watch_together/utils/app/app_colors.dart';
import 'package:ecinema_watch_together/utils/app/app_constants.dart';
import 'package:ecinema_watch_together/utils/app/app_sizes.dart';
import 'package:ecinema_watch_together/utils/app/app_spaces.dart';
import 'package:ecinema_watch_together/widgets/bottomsheets/report_abuse_bottom_sheet.dart';
import 'package:ecinema_watch_together/widgets/text_styled.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ActionsBottomSheet extends StatelessWidget {
  final String content;
  final ContentType contentType;
  final UserEntity contentOwner;
  const ActionsBottomSheet({super.key, required this.content, required this.contentType, required this.contentOwner});

  @override 
  Widget build(BuildContext context) {
    final sizes = AppSizes(context);
    final safePaddingBottom = MediaQuery.of(context).padding.bottom;

    final List<_Action> actions = [
      _Action(iconPath: AppAssets.iconExclamation, text: "Bildir", onTap: () => showReportAbuseBottomSheet(context, content, contentType, contentOwner)),
      _Action(iconPath: AppAssets.iconFriends, text: "Gönder", onTap: () {}),
    ];

    return Container(
      width: Get.width,
      height: 170 + safePaddingBottom,
      padding: EdgeInsets.only(top: AppConstants.mHorizontalPadding, bottom: sizes.safePaddingBottom),
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
            height: 86,
            child: ScrollConfiguration(
              behavior: const ScrollBehavior().copyWith(overscroll: false),
              child: ListView.separated(
                itemCount: actions.length,
                scrollDirection: Axis.horizontal,
                separatorBuilder: (context, index) => AppSpaces.horizontal12,
                padding: const EdgeInsets.symmetric(horizontal: AppConstants.mHorizontalPadding),
                itemBuilder: (context, index) {
                  final action = actions[index];
                  return _action(action.iconPath, action.text, action.onTap);
                },
              ),
            ),
          ),
          AppSpaces.vertical16,
          Material(
            color: AppColors.cardColor,
            child: InkWell(
              onTap: () => Navigator.of(context).pop(),
              splashColor: Colors.black26,
              highlightColor: Colors.transparent,
              splashFactory: InkRipple.splashFactory,
              child: Container(
                width: Get.width,
                height: 52,
                decoration: BoxDecoration(
                  border: Border(
                    top: BorderSide(
                      color: AppColors.borderColor,
                      width: 1
                    )
                  )
                ),
                child: Center(
                  child: textStyled("İptal", 16, AppColors.secondaryTextColor, fontFamily: "Barlow", fontWeight: FontWeight.w700),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}

Widget _action(String iconPath, String text, void Function()? onTap) {
  return GestureDetector(
    onTap: onTap,
    child: SizedBox(
      width: 52,
      height: 86,
      child: Column(
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: AppColors.onScaffoldBackgroundColor,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Image.asset(iconPath, width: 24, height: 24, color: AppColors.whiteGrey,),
            )
          ),
          AppSpaces.vertical8,
          textStyled(text, 13, AppColors.whiteGrey, fontWeight: FontWeight.w400, textAlign: TextAlign.center, maxLines: 2, overflow: TextOverflow.ellipsis, lineHeight: 1.2)
        ],
      ),
    ),
  );
}

void showActionsBottomSheet(BuildContext context, String content, ContentType contentType, UserEntity contentOwner) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    useRootNavigator: true,
    backgroundColor: Colors.transparent,
    builder: (context) => ActionsBottomSheet(
      content: content,
      contentType: contentType,
      contentOwner: contentOwner,
    )
  );
}

class _Action {
  final String iconPath;
  final String text;
  final void Function()? onTap;

  _Action({required this.iconPath, required this.text, required this.onTap});
}

