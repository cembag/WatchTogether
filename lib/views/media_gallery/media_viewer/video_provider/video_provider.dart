import 'dart:io';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:photo_gallery/photo_gallery.dart';
import 'package:appinio_video_player/appinio_video_player.dart';
import 'package:ecinema_watch_together/services/app_services.dart';
import 'package:ecinema_watch_together/utils/app/app_colors.dart';
import 'package:ecinema_watch_together/utils/extensions/color_extension.dart';
import 'package:ecinema_watch_together/utils/extensions/file_extension.dart';
import 'package:ecinema_watch_together/utils/extensions/ui_image_extension.dart';

const _kThumbnailCount = 9;

class VideoProvider extends StatefulWidget {
  final Medium medium;
  final double topSectionHeight;
  const VideoProvider({super.key, required this.medium, required this.topSectionHeight});

  @override
  State<VideoProvider> createState() => _VideoProviderState();
}

class _VideoProviderState extends State<VideoProvider> {

  @override
  void initState() {
    _onInit();
    super.initState();
  }

  @override
  void dispose() {
    playerController?.dispose();
    playerController?.removeListener(_onVideoStateChange);
    super.dispose();
  }

  File? videoFile;
  VideoPlayerController? playerController;
  List<File> thumbnails = [];

  _onVideoStateChange() {
    setState(() {});
  }

  Future<void> _onInit() async {
    videoFile = await widget.medium.getFile();
    await _initController();
  }

  Future<void> _initController() async {
    playerController = VideoPlayerController.file(videoFile!);
    if(playerController == null) return;
    await playerController!.initialize();
    playerController!.addListener(_onVideoStateChange);
    setState(() {});
  }

  Future<void> initThumbnails(File file) async {
    final duration = widget.medium.duration;
    final part = duration/_kThumbnailCount;
    print("MILLISECONDSDURATION: $duration");
    for(var i=0; i<_kThumbnailCount; i++) {
      // var partThumbnails = <List>[];
      var previousMilliseconds = i == 0 ? 0 : part * (i-1);
      var milliseconds = part * i + part/2;
      print("MILLISECONDS: $milliseconds");
      final thumbnailFile = await AppServices.getThumbnail(videoPath: file.path, milliseconds: milliseconds);
      if(thumbnailFile == null) break;
      final uiImage = await thumbnailFile.toImage();
      final averageColor = await uiImage.averageColor;
      final isAlmostDark = averageColor?.isAlmostDark;
      if(isAlmostDark == true) {
        bool? isDark = true;
        do {
          milliseconds -= 200;
          print("CLOSE BLACK LOOP MILLISECONDS: $milliseconds");
          final thumbnailFile = await AppServices.getThumbnail(videoPath: videoFile!.path, milliseconds: milliseconds);
          final uiImage = await thumbnailFile?.toImage();
          final averageColor = await uiImage?.averageColor;
          isDark = averageColor?.isAlmostDark;
          print("CLOSE BLACK LOOP IS DARK: ${averageColor?.isAlmostDark} CLOSE BLACK LOOP AVG COLOR: ${averageColor?.red}:${averageColor?.blue}:${averageColor?.green}");
          if(isDark == false) {
            thumbnails.add(thumbnailFile!);
            setState(() {});
            break;
          }
        } while(isDark == false || milliseconds > previousMilliseconds);
        if(isDark == true) {
          thumbnails.add(thumbnailFile);
          setState(() {});
        }
      } else {
        thumbnails.add(thumbnailFile);
        setState(() {});
      }
    }
  }


  /// VIDEO PLAYER FUNCTIONS
  stopVideo() => playerController?.pause();
  playVideo() => playerController?.play();

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
                  if(playerController != null)
                  Positioned.fill(
                    child: Stack(
                      children: [
                        Positioned.fill(
                          child: GestureDetector(
                            onTap: stopVideo,
                            child: Container(
                              width: Get.width,
                              height: Get.height,
                              color: Colors.transparent,
                              child: FittedBox(
                                fit: BoxFit.contain,
                                child: SizedBox(
                                  width: playerController!.value.size.width,
                                  height: playerController!.value.size.height,
                                  child: VideoPlayer(playerController!),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      // child: Hero(
      //   tag: widget.medium.id,
      //   child: Stack(
      //     children: [
      //       Positioned.fill(
      //         child: Image(
      //           fit: BoxFit.contain,
      //           image: ThumbnailProvider(
      //             mediumId: widget.medium.id,
      //             mediumType: widget.medium.mediumType,
      //             highQuality: true
      //           ),
      //           loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
      //             if (loadingProgress == null) return child;
      //             return Center(
      //               child: CircularProgressIndicator(
      //                 color: AppColors.themeColor.withOpacity(.5),
      //                 backgroundColor: AppColors.cardColor,
      //                 value: loadingProgress.expectedTotalBytes != null ? loadingProgress.cumulativeBytesLoaded/loadingProgress.expectedTotalBytes! : null,
      //               ),
      //             );
      //           },
      //         ),
      //       ),
      //       if(playerController != null)
      //       Positioned.fill(
      //         child: Stack(
      //           children: [
      //             Positioned.fill(
      //               child: GestureDetector(
      //                 onTap: stopVideo,
      //                 child: Container(
      //                   width: Get.width,
      //                   height: Get.height,
      //                   color: Colors.transparent,
      //                   child: FittedBox(
      //                     fit: BoxFit.contain,
      //                     child: SizedBox(
      //                       width: playerController!.value.size.width,
      //                       height: playerController!.value.size.height,
      //                       child: VideoPlayer(playerController!),
      //                     ),
      //                   ),
      //                 ),
      //               ),
      //             ),
      //           ],
      //         ),
      //       ),
      //     ],
      //   ),
      // ),
      // child: Stack(
      //   children: [
      //     Positioned.fill(
      //       child: ,
      //     ),
      //     Positioned.fill(
      //       child: ,
      //     )
      //   ],
      // ),
    );
  }
}


// import 'package:appinio_video_player/appinio_video_player.dart';
// import 'package:ecinema_watch_together/views/media_gallery/media_viewer/video_provider/video_provider_controller.dart';
// import 'package:ecinema_watch_together/widgets/animations/tap_down_scale_animation.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:photo_gallery/photo_gallery.dart';

// class VideoProvider extends StatelessWidget {
//   final Medium medium;
//   final List<String>? receivers;
//   final double topSectionHeight;
//   const VideoProvider({super.key, required this.medium, required this.receivers, required this.topSectionHeight});

//   @override
//   Widget build(BuildContext context) {
//     return GetBuilder(
//       init: VideoProviderController(medium: medium),
//       builder: (controller) {
//         if(controller.videoController == null) return const SizedBox.shrink();
    
//         return SizedBox(
//           width: Get.width,
//           height: Get.height,
//           child: Stack(
//             children: [
//               Positioned.fill(
//                 child: GestureDetector(
//                   onTap: controller.stopVideo,
//                   child: Container(
//                     width: Get.width,
//                     height: Get.height,
//                     color: Colors.transparent,
//                     child: FittedBox(
//                       fit: BoxFit.contain,
//                       child: SizedBox(
//                         width: controller.videoController!.value.size.width,
//                         height: controller.videoController!.value.size.height,
//                         child: VideoPlayer(controller.videoController!),
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//               // Positioned.fill(
//               //   child: GestureDetector(
//               //     onTap: stopVideo,
//               //     child: VideoPlayer(controller!)
//               //   ),
//               // ),
//               if(!controller.isPlaying)
//               Positioned.fill(
//                 child: GestureDetector(
//                   onTap: controller.playVideo,
//                   child: Container(
//                     color: Colors.black.withOpacity(.2),
//                     child: Center(
//                       child: TapDownScaleAnimation(
//                         scale: .9,
//                         onTap: controller.playVideo,
//                         child: Container(
//                           width: 64,
//                           height: 64,
//                           decoration: BoxDecoration(
//                             shape: BoxShape.circle,
//                             // color: AppColors.themeColor,
//                             color: Colors.black.withOpacity(.4)
//                           ),
//                           child: const Center(
//                             child: Padding(
//                               padding: EdgeInsets.only(left: 6),
//                               child: Icon(
//                                 CupertinoIcons.play_arrow_solid,
//                                 size: 36,
//                                 // color: AppColors.themeColor,
//                                 color: Colors.white,
//                               ),
//                             )
//                           ),
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//               Positioned(
//                 left: 0,
//                 top: topSectionHeight,
//                 child: SizedBox(
//                   width: Get.width,
//                   height: controller.settingsHeight,
//                   child: Column(
//                     children: [
//                       SizedBox(
//                         width: Get.width,
//                         height: controller.cropSectionHeight,
//                         child: OverflowBox(
//                           maxWidth: Get.width + controller.overflowWidth * 2,
//                           maxHeight: controller.cropSectionHeight,
//                           child: Container(
//                             width: Get.width * 2,
//                             height: controller.cropSectionHeight,
//                             color: Colors.black,
//                             child: Stack(
//                               clipBehavior: Clip.none,
//                               alignment: Alignment.center,
//                               children: [
//                                 Positioned.fill(
//                                   child: Padding(
//                                     padding: EdgeInsets.symmetric(horizontal: controller.settingsHorizontalPadding, vertical: controller.trackWidth),
//                                     child: Row(
//                                       children: List.generate(controller.thumbnails.length, (index) {
//                                         final file = controller.thumbnails[index];
//                                         return Image.file(file, fit: BoxFit.cover, width: controller.thumbnailWidth, height: controller.cropSectionHeight - controller.trackWidth * 2,);
//                                       })
//                                     ),
//                                   ),
//                                 ),
//                                 // Positioned(
//                                 //   top: 0,
//                                 //   left: controller.cropLeftPosition.value,
//                                 //   child: Container(
//                                 //     height: controller.cropSectionHeight,
//                                 //     width: controller.cropRightPosition.value - controller.cropLeftPosition.value,
//                                 //     color: Colors.black.withOpacity(.8),
//                                 //   ),
//                                 // ),
//                                 Positioned(
//                                   top: 0,
//                                   left: controller.draggableAreaLeftWidth - controller.trackWidth,
//                                   child: Container(
//                                     width: controller.cropLeftPosition.value + controller.trackWidth,
//                                     height: controller.cropSectionHeight,
//                                     color: Colors.black.withOpacity(.5),
//                                   ),
//                                 ),
//                                 Positioned(
//                                   top: controller.trackWidth,
//                                   right: controller.draggableAreaLeftWidth,
//                                   child: Container(
//                                     width: Get.width + controller.overflowWidth - controller.horizontalPadding - controller.cropRightPosition.value - controller.trackWidth - controller.draggableAreaRightWidth,
//                                     height: controller.cropSectionHeight - controller.trackWidth * 2,
//                                     color: Colors.black.withOpacity(.5),
//                                   ),
//                                 ),
//                                 Positioned(
//                                   top: 0,
//                                   // left: controller.croppedPosition.value > 0 ? controller.croppedPosition.value : controller.cropLeftPosition.value + controller.draggableAreaLeftWidth + controller.trackWidth,
//                                   left: controller.cropLeftPosition.value + controller.draggableAreaLeftWidth + controller.trackWidth,
//                                   child: GestureDetector(
//                                     onHorizontalDragEnd: controller.onHorizontalDragEndCropped,
//                                     onHorizontalDragStart: controller.onHorizontalDragStartCropped,
//                                     onHorizontalDragUpdate: controller.onHorizontalDragUpdateCropped,
//                                     child: Container(
//                                       height: controller.cropSectionHeight,
//                                       width: controller.cropRightPosition.value - controller.cropLeftPosition.value - controller.draggableAreaLeftWidth - controller.trackWidth + 10,
//                                       // color: Colors.red.withOpacity(.8),
//                                       decoration: BoxDecoration(
//                                         color: Colors.transparent,
//                                         border: Border(
//                                           top: BorderSide(
//                                             color: Colors.white,
//                                             width: controller.trackWidth
//                                           ),
//                                           bottom: BorderSide(
//                                             color: Colors.white,
//                                             width: controller.trackWidth
//                                           )
//                                         )
//                                       ),
//                                     ),
//                                   ),
//                                 ),
//                                 Positioned(
//                                   top: 0,
//                                   left: controller.cropLeftPosition.value,
//                                   child: GestureDetector(
//                                     onHorizontalDragEnd: controller.onHorizontalDragEndLeft,
//                                     onHorizontalDragStart: controller.onHorizontalDragStartLeft,
//                                     onHorizontalDragUpdate: controller.onHorizontalDragUpdateLeft,
//                                     child: Container(
//                                       width: controller.draggableAreaWidth,
//                                       height: controller.cropSectionHeight,
//                                       // color: Colors.red.withOpacity(.6),
//                                       color: Colors.transparent,
//                                       child: Stack(
//                                         children: [
//                                           Positioned(
//                                             top: 0,
//                                             left: controller.draggableAreaLeftWidth,
//                                             child: Container(
//                                               width: controller.trackWidth,
//                                               height: controller.cropSectionHeight,
//                                               color: Colors.white,
//                                             ),
//                                           ),
//                                           Positioned(
//                                             top: (controller.cropSectionHeight - 12)/2,
//                                             left: controller.draggableAreaLeftWidth - 5,
//                                             child: Container(
//                                               width: 12,
//                                               height: 12,
//                                               decoration: const BoxDecoration(
//                                                 shape: BoxShape.circle,
//                                                 color: Colors.white,
//                                               ),
//                                             ),
//                                           ),
//                                         ],
//                                       ),
//                                     ),
//                                   ),
//                                 ),
//                                 Positioned(
//                                   top: 0,
//                                   left: controller.cropRightPosition.value,
//                                   child: GestureDetector(
//                                     onHorizontalDragEnd: controller.onHorizontalDragEndRight,
//                                     onHorizontalDragStart: controller.onHorizontalDragStartRight,
//                                     onHorizontalDragUpdate: controller.onHorizontalDragUpdateRight,
//                                     child: Container(
//                                       width: controller.draggableAreaWidth,
//                                       height: controller.cropSectionHeight,
//                                       // color: Colors.purple.withOpacity(.6),
//                                       color: Colors.transparent,
//                                        child: Stack(
//                                         children: [
//                                           Positioned(
//                                             top: 0,
//                                             left: controller.draggableAreaRightWidth,
//                                             child: Container(
//                                               width: controller.trackWidth,
//                                               height: controller.cropSectionHeight,
//                                               color: Colors.white,
//                                             ),
//                                           ),
//                                           Positioned(
//                                             top: (controller.cropSectionHeight - 12)/2,
//                                             left: controller.draggableAreaRightWidth - 5,
//                                             child: Container(
//                                               width: 12,
//                                               height: 12,
//                                               decoration: const BoxDecoration(
//                                                 shape: BoxShape.circle,
//                                                 color: Colors.white,
//                                               ),
//                                             ),
//                                           ),
//                                         ],
//                                       ),
//                                     ),
//                                   ),
//                                 ),
//                               ],
//                             )
//                           ),
//                         ),
//                       ),
//                       Expanded(
//                         child: Padding(
//                           padding: const EdgeInsets.symmetric(horizontal: 16),
//                           child: Row(
//                             crossAxisAlignment: CrossAxisAlignment.center,
//                             children: [
//                               GestureDetector(
//                                 onTap: controller.toggleVolume,
//                                 child: Container(
//                                   padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
//                                   decoration: BoxDecoration(
//                                     borderRadius: BorderRadius.circular(50),
//                                     color: Colors.black.withOpacity(.6)
//                                   ),
//                                   child: Icon(
//                                     controller.videoController!.value.volume != 0 ? Icons.volume_up_rounded : Icons.volume_off_rounded,
//                                     size: 18,
//                                     color: Colors.white,
//                                   ),
//                                 )
//                               ),
//                             ],
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               )
//             ],
//           ),
//         );
//       },
//     );
//   }
// }
