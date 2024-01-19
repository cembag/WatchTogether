import 'package:ecinema_watch_together/utils/app/app_colors.dart';
import 'package:ecinema_watch_together/views/chat/global/global_chat_screen_controller.dart';
import 'package:ecinema_watch_together/widgets/text_styled.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class GlobalChatScreen extends StatelessWidget {
  const GlobalChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
      init: GlobalChatScreenController(),
      builder: (controller) {
        return SizedBox(
          child: Center(
            child: textStyled("Global Chat Screen", 16, AppColors.secondaryTextColor, fontWeight: FontWeight.w600),
          ),
        );
      },
    );
  }
}