import 'package:ecinema_watch_together/utils/app/app_spaces.dart';
import 'package:ecinema_watch_together/widgets/text_styled.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:permission_handler/permission_handler.dart';

Future<void> showMediaLibraryPermissionDialog(BuildContext context) async {
    return showCupertinoDialog(
      context: context,
      builder: (context) {
        return CupertinoAlertDialog(
          title: textStyled("Medya", 16, Colors.black, fontWeight: FontWeight.w500, textAlign: TextAlign.center),
          content: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AppSpaces.vertical20,
              textStyled("Bu uygulama medya görüntüleme iznine sahip değil veya kısıtlı izin", 12, Colors.black, fontWeight: FontWeight.w500, textAlign: TextAlign.center),
              AppSpaces.vertical20,
              textStyled("Ayarlardan uygulamaya medya görüntüleme iznini verdikten sonra tekrar deneyin.", 11, Colors.grey, textAlign: TextAlign.center),
              AppSpaces.vertical10,
            ],
          ),
          actions: [
            Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () async {
                  Navigator.of(context).pop();
                  await openAppSettings();
                },
                child: SizedBox(
                  height: 50,
                  width: Get.width,
                  child: Center(
                    child: textStyled("Uygulama ayarlarına git", 14, Colors.blue),
                  )
                )
              ),
            ),
            Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () => Navigator.of(context).pop(),
                child: SizedBox(
                  height: 50,
                  width: Get.width,
                  child: Center(
                    child: textStyled("Tamam", 14, Colors.red),
                  )
                )
              ),
            ), 
          ],
        );
      }
    );
  }
  