import 'package:ecinema_watch_together/entities/app/content_type.dart';
import 'package:ecinema_watch_together/entities/firestore/abuse_entity.dart';
import 'package:ecinema_watch_together/entities/firestore/user_entity.dart';
import 'package:ecinema_watch_together/utils/app/app_colors.dart';
import 'package:ecinema_watch_together/utils/app/app_constants.dart';
import 'package:ecinema_watch_together/utils/app/app_sizes.dart';
import 'package:ecinema_watch_together/utils/app/app_spaces.dart';
import 'package:ecinema_watch_together/widgets/buttons/custom_button.dart';
import 'package:ecinema_watch_together/widgets/text_styled.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ReportAbuseBottomSheet extends StatefulWidget {
  final String content;
  final ContentType contentType;
  final UserEntity contentOwner;
  const ReportAbuseBottomSheet({super.key, required this.content, required this.contentType, required this.contentOwner});

  @override
  State<ReportAbuseBottomSheet> createState() => _ReportAbuseBottomSheetState();
}

class _ReportAbuseBottomSheetState extends State<ReportAbuseBottomSheet> {

  List<AbuseEntity> abuseHistory = [];
  AbuseEntity? selectedAbuse;

  bool get isMain => abuseHistory.isEmpty;
  bool get isReport => selectedAbuse != null && selectedAbuse!.subAbuses == null;

  void selectAbuse(AbuseEntity abuseEntity) {
    abuseHistory.add(abuseEntity);
    selectedAbuse = abuseEntity;
    setState(() {});
  }

  void goBack() {
    if(abuseHistory.length == 1) {
      selectedAbuse = null;
    } else {
      selectedAbuse = abuseHistory.last;
    }
    abuseHistory.removeLast();
    setState(() {});
    return;
  }

  @override 
  Widget build(BuildContext context) {
    final sizes = AppSizes(context);
    final abuses = selectedAbuse != null ? selectedAbuse?.subAbuses : _getAbuses(widget.contentType);
    final isReport = abuses == null;
    print("STATUS BAR HEİGHT: ${sizes.statusBarHeight}");
    return Container(
      width: Get.width,
      height: Get.height - sizes.statusBarHeight,
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
                      if(isMain)
                      const SizedBox(
                        width: 36,
                        height: 36,
                      ),
                      if(!isMain)
                      GestureDetector(
                        onTap: goBack,
                        child: const SizedBox(
                          width: 36,
                          height: 36,
                          child: Icon(
                            Icons.arrow_back,
                            size: 20,
                            color: AppColors.whiteGrey2,
                          ),
                        ),
                      ),
                      textStyled(isReport ? "Rapor et" : "Lütfen bir neden seçin", 18, AppColors.secondaryTextColor, fontWeight: FontWeight.w700),
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
                              size: 18,
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
          if(!isReport)
          Expanded(
            child: ScrollConfiguration(
              behavior: const ScrollBehavior().copyWith(overscroll: false),
              child: ListView.builder(
                itemCount: abuses.length,
                padding: EdgeInsets.only(bottom: sizes.safePaddingBottom + 24),
                itemBuilder: (context, index) {
                  final abuse = abuses[index];
                  return GestureDetector(
                    onTap: () => selectAbuse(abuse),
                    child: Container(
                      width: Get.width,
                      height: 52,
                      color: Colors.transparent,
                      padding: const EdgeInsets.symmetric(horizontal: AppConstants.mHorizontalPadding),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: textStyled(abuse.name, 16, AppColors.whiteGrey, fontWeight: FontWeight.w700, maxLines: 2, lineHeight: 1.2),
                          ),
                          AppSpaces.horizontal8,
                          const Icon(
                            Icons.keyboard_arrow_right,
                            size: 20,
                            color: AppColors.whiteGrey2,
                          )
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          if(isReport)
          Expanded(
            child: SizedBox(
              width: Get.width,
              child: Column(
                children: [
                  Expanded(
                    child: SizedBox(
                      width: Get.width,
                      child: ScrollConfiguration(
                        behavior: const ScrollBehavior().copyWith(overscroll: false),
                        child: SingleChildScrollView(
                          padding: const EdgeInsets.fromLTRB(AppConstants.mHorizontalPadding, AppConstants.mHorizontalPadding, AppConstants.mHorizontalPadding * 2, AppConstants.mHorizontalPadding),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              textStyled(selectedAbuse!.name, 18, AppColors.secondaryTextColor, fontWeight: FontWeight.w600),
                              AppSpaces.vertical16,
                              if(selectedAbuse!.notAlloweds != null)
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  textStyled("Aşağıdakilere izin verilmez:", 16, AppColors.whiteGrey2, fontWeight: FontWeight.w400),
                                  AppSpaces.vertical8,
                                  ListView.separated(
                                    shrinkWrap: true,
                                    itemCount: selectedAbuse!.notAlloweds!.length,
                                    separatorBuilder: (context, index) => AppSpaces.vertical8,
                                    itemBuilder: (context, index) {
                                      final notAllowedText = selectedAbuse!.notAlloweds![index];
                                      return Row(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          textStyled("\u2022", 18, AppColors.whiteGrey2, lineHeight: 1.4),
                                          AppSpaces.horizontal4,
                                          Expanded(
                                            child: textStyled(notAllowedText, 15, AppColors.whiteGrey2, lineHeight: 1.4),
                                          )
                                        ],
                                      );
                                    },
                                  )
                                ],
                              ),
                              if(selectedAbuse!.description != null)
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  textStyled("\u2022", 18, AppColors.whiteGrey2, lineHeight: 1.4),
                                  AppSpaces.horizontal4,
                                  Expanded(
                                    child: textStyled(selectedAbuse!.description!, 15, AppColors.whiteGrey2, lineHeight: 1.4),
                                  )
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  AppSpaces.vertical10,
                  CustomButton(
                    onTap: () {},
                    radius: 12,
                    text: "İlet",
                    fontSize: 18,
                  ),
                  AppSpaces.customHeight(sizes.safePaddingBottom + AppConstants.mHorizontalPadding)
                ],
              ),
            )
          )
        ],
      ),
    );
  }
}

void showReportAbuseBottomSheet(BuildContext context, String content, ContentType contentType, UserEntity contentOwner) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    useRootNavigator: true,
    backgroundColor: Colors.transparent,
    builder: (context) => ReportAbuseBottomSheet(
      content: content,
      contentType: contentType,
      contentOwner: contentOwner,
    )
  );
}


List<AbuseEntity> _getAbuses(ContentType contentType) {
  switch(contentType) {
    case ContentType.video:
      return AppConstants.reportVideoAbuses;
    case ContentType.image:
      return AppConstants.reportImageAbuses;
    case ContentType.text:
      return AppConstants.reportTextAbuses;
  }
}