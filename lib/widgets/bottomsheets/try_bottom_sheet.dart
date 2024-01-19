import 'package:ecinema_watch_together/widgets/buttons/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TryBottomSheet extends StatelessWidget {
  const TryBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    onTap() async {
      await Navigator.of(context).push(MaterialPageRoute(builder: (context) => const Try2BottomSheet())).then((value) {
        Navigator.of(context).pop(value);
      });
    }
    return SizedBox(
      width: Get.width,
      height: Get.height/2,
      child: CustomButton(
        onTap: onTap,
        text: "PAGE 1", 
      )
    );
  }
}

class Try2BottomSheet extends StatelessWidget {
  const Try2BottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    onTap() async {
      await Navigator.of(context).push(MaterialPageRoute(builder: (context) => const Try3BottomSheet())).then((value) {
        Navigator.of(context).pop(value);
      });
    }
    return SizedBox(
      width: Get.width,
      height: Get.height/2,
      child: CustomButton(
        onTap: onTap,
        text: "PAGE 2", 
      )
    );
  }
}

class Try3BottomSheet extends StatelessWidget {
  const Try3BottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    onTap() async {
      await Navigator.of(context).push(MaterialPageRoute(builder: (context) => const Try4BottomSheet())).then((value) {
        Navigator.of(context).pop(value);
      });
    }
    return SizedBox(
      width: Get.width,
      height: Get.height/2,
      child: Center(
        child: CustomButton(
          onTap: onTap,
          text: "PAGE 3", 
        ),
      )
    );
  }
}

class Try4BottomSheet extends StatelessWidget {
  const Try4BottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: Get.width,
      height: Get.height/2,
      child: Center(
        child: CustomButton(
          onTap: () => Navigator.of(context).pop(2053),
          text: "PAGE 4", 
        ),
      )
    );
  }
}

Future<int?> showTryModal() async {
  final context = Get.context;
  if(context == null) return null;
  return await showDialog(
    context: context,
    barrierColor: Colors.black.withOpacity(.2),
    builder: (BuildContext context) {
      return const TryBottomSheet();
    }
  );
}

// void showTryBottomSheet() async {
  // final context = Get.context;
  // if(context == null) return;
//   showAnimatedModal(context: context, width: Get.width, height: Get.height, child: const TryBottomSheet());
// }