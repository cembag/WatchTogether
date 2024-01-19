import 'dart:io';
import 'package:ecinema_watch_together/utils/app/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:photo_gallery/photo_gallery.dart';

class PhotoProviderApp extends StatefulWidget {
  final Medium medium;
  const PhotoProviderApp({super.key, required this.medium});

  @override
  State<PhotoProviderApp> createState() => _PhotoProviderAppState();
}

class _PhotoProviderAppState extends State<PhotoProviderApp> {

  @override
  void initState() {
    _init();
    super.initState();
  }

  File? file;

  Future<void> _init() async {
    file = await widget.medium.getFile();
    if(mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: Get.width,
      height: Get.height,
      child: Stack(
        children: [
          Positioned.fill(
            child: Hero(
              tag: widget.medium.id,
              child: Stack(
                children: [
                  Positioned.fill(
                    child: Image(
                      fit: BoxFit.contain,
                      image: ThumbnailProvider(
                        mediumId: widget.medium.id,
                        mediumType: widget.medium.mediumType,
                        highQuality: true
                      ),
                      loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
                        if (loadingProgress == null) return child;
                        return Center(
                          child: CircularProgressIndicator(
                            color: AppColors.themeColor.withOpacity(.5),
                            backgroundColor: AppColors.cardColor,
                            value: loadingProgress.expectedTotalBytes != null ? loadingProgress.cumulativeBytesLoaded/loadingProgress.expectedTotalBytes! : null,
                          ),
                        );
                      },
                    ),
                  ),
                  if(file != null)
                  Positioned.fill(
                    child: Image.file(
                      file!,
                      fit: BoxFit.contain,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}