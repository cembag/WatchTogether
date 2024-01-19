import 'package:ecinema_watch_together/dal/auth_dal.dart';
import 'package:ecinema_watch_together/services/app_services.dart';
import 'package:ecinema_watch_together/utils/app/app_colors.dart';
import 'package:ecinema_watch_together/utils/app/app_constants.dart';
import 'package:ecinema_watch_together/views/chat/chat_screen.dart';
import 'package:ecinema_watch_together/views/home/home_screen.dart';
import 'package:ecinema_watch_together/views/profile/profile_screen.dart';
import 'package:ecinema_watch_together/widgets/animations/tap_down_scale_animation.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';

const pages = [
  HomeScreen(),
  HomeScreen(),
  ChatScreen(),
  ProfileScreen()
  // Consultantcreen(),
  // TreatmentsScreen(),
  // ProfileScreen(),
];

class PageNavigatorScreen extends StatefulWidget {
  final int index;
  const PageNavigatorScreen({this.index = 0,Key? key}) : super(key: key);

  @override
  State<PageNavigatorScreen> createState() => _PageNavigatorScreenState();
}

class _PageNavigatorScreenState extends State<PageNavigatorScreen> {

  int pageIndex = 0;
  late final PageController pageController;

  @override
  void initState() {
    super.initState();
    pageController = PageController(initialPage: widget.index);
  }

  @override
  void dispose() {
    super.dispose();
    pageController.dispose();
  }

  void _setPage(int index) {
    pageController.jumpToPage(index);
    setState(() {
      pageIndex = index;
    });
  }

  void _onPageChanged(int index) {
    setState(() {
      pageIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: GestureDetector(
        onTap: () => AppServices.unfocus(),
        child: Scaffold(
          extendBody: true,
          body: PageView.builder(
            itemCount: pages.length,
            clipBehavior: Clip.none,
            controller: pageController,
            scrollDirection: Axis.horizontal,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) => pages[index],
            onPageChanged: _onPageChanged,
          ), 
          // body: IndexedStack(
          //   index: pageIndex,
          //   children: pages,
          // ),
          bottomNavigationBar: _bottomNavigationBar(),
        ),
      )
    );
  }

  Container _bottomNavigationBar() {
    const bottomNavBarHeight = AppConstants.bottomNavBarHeight;
    final safePaddingBottom = MediaQuery.of(context).padding.bottom;
    final navigationBarHeight = bottomNavBarHeight + safePaddingBottom;
    const analyzeButtonWidth = 56.0;
    const analyzeButtonPaddingBottom = 8.0;
    const middlePadding = analyzeButtonWidth + 16;
    const lineWidth = 50.0;
    const overflow = 5.0;
    const iconOverlay = 16.0;
    const maxWidth = 540.0;
    final width = Get.width > maxWidth ? maxWidth : Get.width;
    final iconsArea = (width - middlePadding)/2;
    final iconRadius = (iconsArea + overflow + iconOverlay)/2;
    final positions = [-overflow, -overflow -iconOverlay + iconRadius, iconsArea + middlePadding, iconsArea + middlePadding + iconRadius - iconOverlay];
    final tabledPadding = (Get.width - width)/2;
    return Container(
      width: Get.width,
      clipBehavior: Clip.none,
      height: analyzeButtonWidth + analyzeButtonPaddingBottom + safePaddingBottom,
      child: Stack(
        fit: StackFit.expand,
        alignment: Alignment.center,
        children: [
          Positioned(
            bottom: 0,
            left: 0,
            child: Center(
              child: Container(
                width: Get.width,
                height: navigationBarHeight,
                padding: EdgeInsets.fromLTRB(0, 0, 0, safePaddingBottom),
                decoration: BoxDecoration(
                  // color: AppColors.scaffoldBackgroundColor,
                  color: AppColors.appBarColor,
                  border: pageIndex == 0 ? null : Border(
                    top: BorderSide(
                      color: AppColors.barBorderColor,
                      width: 1
                    )
                  )
                  // color: AppColors.barColor,
                  // boxShadow: [
                  //   BoxShadow(
                  //     color: AppColors.shadowColorBlackSmooth,
                  //     offset: Offset(0, 0),
                  //     blurRadius: 5,
                  //     spreadRadius: 0
                  //   )
                  // ],
                ),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    _barIcon(positionLeft: positions[0] + tabledPadding, iconRadius: iconRadius, index: 0, img: "assets/images/ic_icon-cards.png", size: 22),
                    _barIcon(positionLeft: positions[1] + tabledPadding, iconRadius: iconRadius, index: 1, img: "assets/images/ic_icon-hearts.png", size: 22),
                    _barIcon(positionLeft: positions[2] + tabledPadding, iconRadius: iconRadius, index: 2, icon: CupertinoIcons.chat_bubble_2_fill),
                    _barIcon(positionLeft: positions[3] + tabledPadding, iconRadius: iconRadius, index: 3, icon: Icons.person_rounded, size: 26),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            bottom: safePaddingBottom + analyzeButtonPaddingBottom,
            child: TapDownScaleAnimation(
              onTap: AuthDal.instance.signOut,
              child: const StartAnalyzeButton(analyzeButtonWidth: analyzeButtonWidth, analyzeButtonPaddingBottom: analyzeButtonPaddingBottom),
            ),
          ),
          AnimatedPositioned(
            bottom: safePaddingBottom,
            left: positions[pageIndex] + (iconRadius - lineWidth)/2 + tabledPadding,
            curve: Curves.fastLinearToSlowEaseIn,
            duration: const Duration(milliseconds: 600),
            child: Container(
              width: lineWidth,
              height: 4,
              decoration: const BoxDecoration(
                color: AppColors.themeColor,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20)
                )
              ),
            ),
          )
        ],
      )
    );
  }

  Positioned _barIcon({required double positionLeft, required double iconRadius, required int index, IconData? icon, String? img, double size = 26}) {
    final isSelected = pageIndex == index;
    return Positioned(
    left: positionLeft,
      child: Container(
        width: iconRadius,
        height: iconRadius,
        clipBehavior: Clip.hardEdge,
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () => _setPage(index),
            highlightColor: Colors.transparent,
            splashFactory: InkRipple.splashFactory,
            splashColor: const Color.fromRGBO(22, 22, 22, 1),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if(icon != null)
                Icon(
                  icon,
                  size: size,
                  color: isSelected ? AppColors.themeColor : const Color.fromRGBO(180, 180, 180, 1),
                ),
                if(img != null)
                Image.asset(img, width: size, height: size, color: isSelected ? AppColors.themeColor : const Color.fromRGBO(180, 180, 180, 1),),
              ],
            )
          ),
        ),
      ),
    );
  }
}

class StartAnalyzeButton extends StatefulWidget {
  final double analyzeButtonWidth;
  final double analyzeButtonPaddingBottom;
  const StartAnalyzeButton({super.key, required this.analyzeButtonWidth, required this.analyzeButtonPaddingBottom});

  @override
  State<StartAnalyzeButton> createState() => _StartAnalyzeButtonState();
}

class _StartAnalyzeButtonState extends State<StartAnalyzeButton> {

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.analyzeButtonWidth,
      height: widget.analyzeButtonWidth,
      padding: const EdgeInsets.only(bottom: 0),
      decoration: BoxDecoration(
        border: Border.all(
          color: const Color.fromARGB(255, 220, 220, 220),
          width: 3,
        ),
        gradient: const RadialGradient(
          // colors: [Color.fromARGB(255, 246, 53, 88), AppColors.themeColor],
          colors: [Color.fromARGB(255, 162, 0, 30), AppColors.themeColor],
          radius: .5,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.themeColor.withOpacity(.4),
            offset: const Offset(0, 1),
            blurRadius: 5,
          )
        ],
        shape: BoxShape.circle,
        color: const Color.fromARGB(255, 176, 4, 36),
        // color: Colors.black
      ),
      child: Center(
        child: Image.asset("assets/images/ic_icon-match.png", color: const Color.fromRGBO(240, 240, 240, 1), width: 30, height: 30,),
        // child: Image.asset("assets/images/ic_icon-search-heart.png", color: AppColors.themeColor, width: 28, height: 28,),
      ),
    );
  }
}
