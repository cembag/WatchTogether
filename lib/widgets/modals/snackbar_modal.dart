import 'package:ecinema_watch_together/utils/app/app_colors.dart';
import 'package:ecinema_watch_together/utils/app/app_constants.dart';
import 'package:ecinema_watch_together/utils/app/app_spaces.dart';
import 'package:ecinema_watch_together/widgets/buttons/custom_button.dart';
import 'package:ecinema_watch_together/widgets/text_styled.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

showSnackbarModal({required BuildContext context, required String title, required String message, Widget? content, double? duration, List<SnackbarAction>? actions}) {
  showDialog(
    context: context,
    barrierColor: const Color.fromRGBO(20, 20, 20, .5),
    builder: (BuildContext context) => SnackbarModal(
      title: title,
      message: message,
      content: content,
      duration: duration,
      actions: actions,
    ),
  );
}

class SnackbarModal extends StatefulWidget {
  final double? duration;
  final String title;
  final String message;
  final Widget? content;
  final List<SnackbarAction>? actions;
  const SnackbarModal({super.key, required this.title, required this.message, this.content, this.duration, this.actions});

  @override
  State<SnackbarModal> createState() => _SnackbarModalState();
}

class _SnackbarModalState extends State<SnackbarModal> with SingleTickerProviderStateMixin {

  late final AnimationController _animationController;
  late final Animation<double> _animation;
  var canSubmit = true;

  @override
  void initState() {
    _animationController = AnimationController(vsync: this, duration: const Duration(milliseconds: 220));
    _animation = Tween<double>(begin: 0, end: 1).animate(CurvedAnimation(parent: _animationController, curve: Curves.easeIn));
    _animationController.addListener(() {
      if(widget.duration != null) {
        if(_animationController.isCompleted) {
          Future.delayed(const Duration(seconds: 3), () {
            if(!mounted) return;
            setState(() {
              canSubmit = false;
            });
            _animationController.reverse();
            Future.delayed(const Duration(milliseconds: 220), () {
              if(!mounted) return;
              Navigator.of(context).pop();
            });
          });
        }
      }
      setState(() {});
    });
    _animationController.forward();
    super.initState();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final dialogWidth = Get.width - AppConstants.mHorizontalPadding * 2;
    return ScaleTransition(
      scale: _animation,
      child: Opacity(
        opacity: _animation.value,
        child: AlertDialog(
          elevation: 20,
          shadowColor: AppColors.blackGrey,
          backgroundColor: Colors.black,
          clipBehavior: Clip.none,
          contentPadding: EdgeInsets.zero,
          insetPadding: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16)
          ),
          content: Container(
            width: dialogWidth,
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                textStyled(widget.title, 36, AppColors.secondaryTextColor, fontWeight: FontWeight.w700, fontFamily: "Barlow", textAlign: TextAlign.center),
                AppSpaces.vertical8,
                textStyled(widget.message, 16, AppColors.greyTextColor, textAlign: TextAlign.center),
                if(widget.content != null)
                AppSpaces.vertical24,
                if(widget.content != null)
                widget.content!,
                if(widget.actions != null)
                AppSpaces.vertical30,
                if(widget.actions != null)
                SizedBox(
                  width: double.infinity,
                  height: 42.0 * widget.actions!.length + 8 * (widget.actions!.length - 1),
                  child: ListView.separated(
                    shrinkWrap: true,
                    padding: EdgeInsets.zero,
                    scrollDirection: Axis.vertical,
                    itemCount: widget.actions!.length,
                    physics: const NeverScrollableScrollPhysics(),
                    separatorBuilder: (context, index) => AppSpaces.vertical8,
                    itemBuilder: (context, index) {
                      final action = widget.actions![index];
                      return CustomButton(
                        onTap: canSubmit ? action.onTap : null,
                        backgroundColor: action.backgroundColor,
                        text: action.text,
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    ); 
  }
}

class SnackbarAction {
  final void Function()? onTap;
  final String text;
  final Color? backgroundColor;

  SnackbarAction({required this.onTap, required this.text, this.backgroundColor});
}