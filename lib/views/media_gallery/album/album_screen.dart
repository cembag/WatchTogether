import 'dart:typed_data';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:ecinema_watch_together/utils/app/app_colors.dart';
import 'package:ecinema_watch_together/utils/app/app_constants.dart';
import 'package:ecinema_watch_together/utils/app/app_sizes.dart';
import 'package:ecinema_watch_together/utils/app/app_spaces.dart';
import 'package:ecinema_watch_together/views/media_gallery/album/album_screen_controller.dart';
import 'package:ecinema_watch_together/widgets/custom_curves.dart';
import 'package:ecinema_watch_together/widgets/text_styled.dart';
import 'package:flutter/material.dart';
import 'package:photo_gallery/photo_gallery.dart';
import 'package:shimmer/shimmer.dart';
import 'package:transparent_image/transparent_image.dart';

class AlbumScreen extends StatelessWidget {
  final Album album;
  final List<String>? receivers;
  const AlbumScreen({super.key, required this.album, this.receivers});

  @override
  Widget build(BuildContext context) {
    final sizes = AppSizes(context);
    final appBarHeight = AppConstants.appBarHeight + sizes.statusBarHeight;
    final albumName = album.name ?? "Unnamed album";
    const axisCount = 4;
    const axisSpacing = 2.0;
    final bottomSectionHeight = 66 + sizes.safePaddingBottom;
    const bottomSectionPadding = 8.0;
    final bottomSectionItemHeight = bottomSectionHeight - bottomSectionPadding * 2;
    return GetBuilder(
      init: AlbumScreenController(album: album, receivers: receivers),
      builder: (controller) {
        final medias = controller.medias.value;
        final mediasSmall = controller.mediasSmall.value;
        // final medias = controller.medias.value;
        // final mediasSmall = controller.mediasSmall.value;
        final selectedImages = controller.selectedImages.value;
        final isMultiselectedMode = controller.multiSelectMode.value;
        return Scaffold(
          backgroundColor: const Color.fromRGBO(20, 21, 26, 1),
          appBar: _appBar(appBarHeight, sizes.statusBarHeight, albumName, selectedImages.length),
          body: Stack(
            fit: StackFit.expand,
            children: [
              // if(controller.loading.value)
              // Shimmer.fromColors(
              //   baseColor: const Color.fromRGBO(74, 75, 80, 1), 
              //   highlightColor: const Color.fromRGBO(82, 83, 88, 1),
              //   child: ListView.separated(
              //     itemCount: controller.loadingMedias.length,
              //     separatorBuilder: (context, index) => AppSpaces.vertical10,
              //     padding: const EdgeInsets.symmetric(vertical: 16),
              //     itemBuilder: (context, index) {
              //       final medias = controller.loadingMedias[index];
              //       return Column(
              //         children: [
              //           SizedBox(
              //             width: Get.width,
              //             height: 42,
              //             child: Align(
              //               alignment: Alignment.centerLeft,
              //               child: Container(
              //                 width: 80,
              //                 height: 16,
              //                 color: Colors.black,
              //               ),
              //             ),
              //           ),
              //           GridView.builder(
              //             itemCount: medias,
              //             shrinkWrap: true,
              //             physics: const NeverScrollableScrollPhysics(),
              //             gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: axisCount, mainAxisSpacing: axisSpacing, crossAxisSpacing: axisSpacing, childAspectRatio: 1),
              //             padding: const EdgeInsets.only(bottom: 16),
              //             itemBuilder: (context, index) {
              //               return Container(
              //                 color: Colors.black,
              //               );
              //             },
              //           ),
              //         ],
              //       );
              //     }
              //   )
              // ),
              // if(!controller.loading.value && !controller.mediasSmallInitialized.value && controller.mediasSmall.value.isEmpty)
              // Center(
              //   child: textStyled("Medya ayrıştırılamadı", 16, Colors.white)
              // ),
              // if(!controller.loading.value && controller.mediasSmallInitialized.value && controller.mediasSmall.value.isEmpty)
              // Center(
              //   child: textStyled("Medya bulunamadı", 16, Colors.white)
              // ),
              // if(!controller.loading.value && !controller.mediasInitialized.value && controller.mediasSmallInitialized.value && mediasSmall.isNotEmpty)
              // ListView.separated(
              //   itemCount: mediasSmall.length,
              //   // physics: const NeverScrollableScrollPhysics(),
              //   separatorBuilder: (context, index) => AppSpaces.vertical10,
              //   padding: EdgeInsets.only(top: 16, bottom: isMultiselectedMode ? bottomSectionHeight : 16),
              //   itemBuilder: (context, index) {
              //     final media = mediasSmall[index];
              //     final label = media.label;
              //     final sortedMedias = media.medias; 
              //     return StickyHeader(
              //       header: Container(
              //         width: Get.width,
              //         height: 42,
              //         color: const Color.fromRGBO(20, 21, 26, 1),
              //         padding: const EdgeInsets.symmetric(horizontal: 12),
              //         child: Align(
              //           alignment: Alignment.centerLeft,
              //           child: textStyled(label, 12, Colors.white, fontWeight: FontWeight.w500),
              //         ),
              //       ),
              //       content: GridView.builder(
              //         shrinkWrap: true,
              //         itemCount: sortedMedias.length,
              //         physics: const NeverScrollableScrollPhysics(),
              //         gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: axisCount, mainAxisSpacing: axisSpacing, crossAxisSpacing: axisSpacing, childAspectRatio: 1),
              //         padding: const EdgeInsets.only(bottom: 16),
              //         itemBuilder: (context, index) {
              //           final medium = sortedMedias[index];
              //           final listIndex = selectedImages.indexWhere((selectedImage) => selectedImage.id == medium.id);
              //           final inList = listIndex == -1 ? false : true;
              //           final isPhoto = medium.mediumType == MediumType.image;
              //           // controller.isSelected(medium);
              //           return SizedBox(
              //             child: Stack(
              //               children: [
              //                 Positioned.fill(
              //                   child: Container(
              //                     color: const Color.fromRGBO(74, 75, 80, 1)
              //                     // child: Center(
              //                     //   child: Image.asset("assets/images/ic_ecinema-animation-logo.png", width: 36, height: 36, color: AppColors.scaffoldBackgroundColor.changeColor(ChangeColor.add, all: 12),),
              //                     // ),
              //                   ),
              //                 ),
              //                 Positioned.fill(
              //                   child: Hero(
              //                     tag: medium.id,
              //                     child: FadeInImage(
              //                       fit: BoxFit.cover,
              //                       placeholder: MemoryImage(kTransparentImage),
              //                       image: ThumbnailProvider(
              //                         mediumId: medium.id,
              //                         mediumType: medium.mediumType,
              //                         highQuality: true,
              //                       ),
              //                     ),
              //                   ),
              //                   // child: Hero(
              //                   //   tag: medium.id,
              //                   //   child: Image(
              //                   //     fit: BoxFit.cover,
              //                   //     // image: PhotoProvider(mediumId: medium.id),
              //                   //     image: ThumbnailProvider(
              //                   //       mediumId: medium.id,
              //                   //       mediumType: medium.mediumType,
              //                   //       highQuality: true
              //                   //     ),
              //                   //     loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
              //                   //       if (loadingProgress == null) return child;
              //                   //       return Center(
              //                   //         child: CircularProgressIndicator(
              //                   //           color: AppColors.themeColor.withOpacity(.5),
              //                   //           backgroundColor: Colors.white,
              //                   //           value: loadingProgress.expectedTotalBytes != null ? loadingProgress.cumulativeBytesLoaded/loadingProgress.expectedTotalBytes! : null,
              //                   //         ),
              //                   //       );
              //                   //     },
              //                   //   ),
              //                   // ),
              //                 ),
              //                 Positioned.fill(
              //                   child: Stack(
              //                     children: [
              //                       Positioned.fill(
              //                         child: AnimatedOpacity(
              //                           opacity: inList ? 1 : 0,
              //                           duration: const Duration(milliseconds: 300),
              //                           child: Container(
              //                             // color: const Color.fromARGB(255, 9, 0, 90).withOpacity(.35),
              //                             color: AppColors.themeColor.withOpacity(.35),
              //                           ),
              //                         ),
              //                       ),
              //                       Positioned(
              //                         top: 4.0,
              //                         right: 4.0,
              //                         child: AnimatedScale(
              //                           scale: inList ? 1 : 0,
              //                           duration: const Duration(milliseconds: 500),
              //                           curve: const CustomEaseOutBackCurve(),
              //                           child: Container(
              //                             width: 24,
              //                             height: 24,
              //                             decoration: const BoxDecoration(
              //                               shape: BoxShape.circle,
              //                               // color: Color.fromARGB(255, 16, 0, 163),
              //                               color: AppColors.themeColor,
              //                               boxShadow: [
              //                                 BoxShadow(
              //                                   color: Colors.black,
              //                                   offset: Offset(0, 1),
              //                                   spreadRadius: 0,
              //                                   blurRadius: 2
              //                                 )
              //                               ]
              //                             ),
              //                             child: Center(
              //                               child: textStyled((listIndex + 1).toString(), 16, AppColors.textWhiteBase, fontWeight: FontWeight.w900),
              //                               // child: Icon(
              //                               //   Icons.check,
              //                               //   color: AppColors.textWhiteBase,
              //                               //   size: 16,
              //                               // ),
              //                             )
              //                           ),
              //                         ),
              //                       ),
              //                     ],
              //                   ),
              //                 ),
              //                 if(!isPhoto)
              //                 Positioned(
              //                   left: 2,
              //                   bottom: isPhoto ? 2 : 0,
              //                   child: Container(
              //                     width: isPhoto ? 16 : 20,
              //                     height: isPhoto ? 16 : 20,
              //                     decoration: BoxDecoration(
              //                       boxShadow: [
              //                         BoxShadow(
              //                           color: Colors.black.withOpacity(0.2),
              //                           spreadRadius: 1,
              //                           blurRadius: 8,
              //                           offset: const Offset(0, 0),
              //                         ),
              //                       ],
              //                     ),
              //                     child: Icon(
              //                       isPhoto ? Icons.photo : CupertinoIcons.video_camera_solid,
              //                       size: isPhoto ? 16 : 20,
              //                       color: AppColors.primaryTextColor,
              //                     ),
              //                   ),
              //                 ),
              //                 Positioned.fill(
              //                   child: Material(
              //                     color: Colors.transparent,
              //                     child: InkWell(
              //                       onTap: () => controller.selectMedium(medium),
              //                       onLongPress: () => controller.onImageLongPress(medium),
              //                       splashColor: isMultiselectedMode ? Colors.transparent : Colors.black26,
              //                       splashFactory: InkRipple.splashFactory,
              //                       highlightColor: Colors.transparent,
              //                     ),
              //                   ),
              //                 ),
              //               ],
              //             ),
              //           );
              //         },
              //       ),
              //     );
              //   },
              // ),
              // if(!controller.loading.value && controller.mediasInitialized.value && medias.isNotEmpty)
              // ListView.separated(
              //   itemCount: medias.length,
              //   // physics: const NeverScrollableScrollPhysics(),
              //   separatorBuilder: (context, index) => AppSpaces.vertical10,
              //   padding: EdgeInsets.only(top: 16, bottom: isMultiselectedMode ? bottomSectionHeight : 16),
              //   itemBuilder: (context, index) {
              //     final media = medias[index];
              //     final label = media.label;
              //     final sortedMedias = media.medias; 
              //     return StickyHeader(
              //       header: Container(
              //         width: Get.width,
              //         height: 42,
              //         color: const Color.fromRGBO(20, 21, 26, 1),
              //         padding: const EdgeInsets.symmetric(horizontal: 12),
              //         child: Align(
              //           alignment: Alignment.centerLeft,
              //           child: textStyled(label, 12, Colors.white, fontWeight: FontWeight.w500),
              //         ),
              //       ),
              //       content: GridView.builder(
              //         shrinkWrap: true,
              //         itemCount: sortedMedias.length,
              //         physics: const NeverScrollableScrollPhysics(),
              //         gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: axisCount, mainAxisSpacing: axisSpacing, crossAxisSpacing: axisSpacing, childAspectRatio: 1),
              //         padding: const EdgeInsets.only(bottom: 16),
              //         itemBuilder: (context, index) {
              //           final medium = sortedMedias[index];
              //           final listIndex = selectedImages.indexWhere((selectedImage) => selectedImage.id == medium.id);
              //           final inList = listIndex == -1 ? false : true;
              //           final isPhoto = medium.mediumType == MediumType.image;
              //           // controller.isSelected(medium);
              //           return SizedBox(
              //             child: Stack(
              //               children: [
              //                 Positioned.fill(
              //                   child: Container(
              //                     color: const Color.fromRGBO(74, 75, 80, 1)
              //                     // child: Center(
              //                     //   child: Image.asset("assets/images/ic_ecinema-animation-logo.png", width: 36, height: 36, color: AppColors.scaffoldBackgroundColor.changeColor(ChangeColor.add, all: 12),),
              //                     // ),
              //                   ),
              //                 ),
              //                 Positioned.fill(
              //                   child: Hero(
              //                     tag: medium.id,
              //                     child: FadeInImage(
              //                       fit: BoxFit.cover,
              //                       placeholder: MemoryImage(kTransparentImage),
              //                       image: ThumbnailProvider(
              //                         mediumId: medium.id,
              //                         mediumType: medium.mediumType,
              //                         highQuality: true,
              //                       ),
              //                     ),
              //                   ),
              //                   // child: Hero(
              //                   //   tag: medium.id,
              //                   //   child: Image(
              //                   //     fit: BoxFit.cover,
              //                   //     // image: PhotoProvider(mediumId: medium.id),
              //                   //     image: ThumbnailProvider(
              //                   //       mediumId: medium.id,
              //                   //       mediumType: medium.mediumType,
              //                   //       highQuality: true
              //                   //     ),
              //                   //     loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
              //                   //       if (loadingProgress == null) return child;
              //                   //       return Center(
              //                   //         child: CircularProgressIndicator(
              //                   //           color: AppColors.themeColor.withOpacity(.5),
              //                   //           backgroundColor: Colors.white,
              //                   //           value: loadingProgress.expectedTotalBytes != null ? loadingProgress.cumulativeBytesLoaded/loadingProgress.expectedTotalBytes! : null,
              //                   //         ),
              //                   //       );
              //                   //     },
              //                   //   ),
              //                   // ),
              //                 ),
              //                 Positioned.fill(
              //                   child: Stack(
              //                     children: [
              //                       Positioned.fill(
              //                         child: AnimatedOpacity(
              //                           opacity: inList ? 1 : 0,
              //                           duration: const Duration(milliseconds: 300),
              //                           child: Container(
              //                             // color: const Color.fromARGB(255, 9, 0, 90).withOpacity(.35),
              //                             color: AppColors.themeColor.withOpacity(.35),
              //                           ),
              //                         ),
              //                       ),
              //                       Positioned(
              //                         top: 4.0,
              //                         right: 4.0,
              //                         child: AnimatedScale(
              //                           scale: inList ? 1 : 0,
              //                           duration: const Duration(milliseconds: 500),
              //                           curve: const CustomEaseOutBackCurve(),
              //                           child: Container(
              //                             width: 24,
              //                             height: 24,
              //                             decoration: const BoxDecoration(
              //                               shape: BoxShape.circle,
              //                               // color: Color.fromARGB(255, 16, 0, 163),
              //                               color: AppColors.themeColor,
              //                               boxShadow: [
              //                                 BoxShadow(
              //                                   color: Colors.black,
              //                                   offset: Offset(0, 1),
              //                                   spreadRadius: 0,
              //                                   blurRadius: 2
              //                                 )
              //                               ]
              //                             ),
              //                             child: Center(
              //                               child: textStyled((listIndex + 1).toString(), 16, AppColors.textWhiteBase, fontWeight: FontWeight.w900),
              //                               // child: Icon(
              //                               //   Icons.check,
              //                               //   color: AppColors.textWhiteBase,
              //                               //   size: 16,
              //                               // ),
              //                             )
              //                           ),
              //                         ),
              //                       ),
              //                     ],
              //                   ),
              //                 ),
              //                 if(!isPhoto)
              //                 Positioned(
              //                   left: 2,
              //                   bottom: isPhoto ? 2 : 0,
              //                   child: Container(
              //                     width: isPhoto ? 16 : 20,
              //                     height: isPhoto ? 16 : 20,
              //                     decoration: BoxDecoration(
              //                       boxShadow: [
              //                         BoxShadow(
              //                           color: Colors.black.withOpacity(0.2),
              //                           spreadRadius: 1,
              //                           blurRadius: 8,
              //                           offset: const Offset(0, 0),
              //                         ),
              //                       ],
              //                     ),
              //                     child: Icon(
              //                       isPhoto ? Icons.photo : CupertinoIcons.video_camera_solid,
              //                       size: isPhoto ? 16 : 20,
              //                       color: AppColors.primaryTextColor,
              //                     ),
              //                   ),
              //                 ),
              //                 Positioned.fill(
              //                   child: Material(
              //                     color: Colors.transparent,
              //                     child: InkWell(
              //                       onTap: () => controller.selectMedium(medium),
              //                       onLongPress: () => controller.onImageLongPress(medium),
              //                       splashColor: isMultiselectedMode ? Colors.transparent : Colors.black26,
              //                       splashFactory: InkRipple.splashFactory,
              //                       highlightColor: Colors.transparent,
              //                     ),
              //                   ),
              //                 ),
              //               ],
              //             ),
              //           );
              //         },
              //       ),
              //     );
              //   },
              // ),
              if(controller.loading.value)
              Shimmer.fromColors(
                baseColor: const Color.fromRGBO(52, 53, 58, 1), 
                highlightColor: const Color.fromRGBO(62, 63, 68, 1),
                child: GridView.builder(
                  itemCount: 80,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: axisCount, mainAxisSpacing: axisSpacing, crossAxisSpacing: axisSpacing, childAspectRatio: 1),
                  padding: const EdgeInsets.only(bottom: 16),
                  itemBuilder: (context, index) {
                    return Container(
                      color: Colors.black,
                    );
                  },
                ),
              ),
               if(!controller.loading.value && !controller.mediasSmallInitialized.value && controller.mediasSmall.value.isEmpty)
              Center(
                child: textStyled("Medya ayrıştırılamadı", 16, Colors.white)
              ),
              if(!controller.loading.value && controller.mediasSmallInitialized.value && controller.mediasSmall.value.isEmpty)
              Center(
                child: textStyled("Medya bulunamadı", 16, Colors.white)
              ),
              if(!controller.loading.value && !controller.mediasInitialized.value && controller.mediasSmallInitialized.value && mediasSmall.isNotEmpty)
              GridView.builder(
                itemCount: mediasSmall.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: axisCount, mainAxisSpacing: axisSpacing, crossAxisSpacing: axisSpacing, childAspectRatio: 1),
                padding: EdgeInsets.only(bottom: isMultiselectedMode ? bottomSectionHeight : 0),
                itemBuilder: (context, index) {
                  final medium = mediasSmall[index];
                  final listIndex = selectedImages.indexWhere((selectedImage) => selectedImage.id == medium.id);
                  final inList = listIndex == -1 ? false : true;
                  final isPhoto = medium.mediumType == MediumType.image;
                  // controller.isSelected(medium);
                  return SizedBox(
                    child: Stack(
                      children: [
                        Positioned.fill(
                          child: Container(
                            color: const Color.fromRGBO(52, 53, 58, 1)
                            // child: Center(
                            //   child: Image.asset("assets/images/ic_ecinema-animation-logo.png", width: 36, height: 36, color: AppColors.scaffoldBackgroundColor.changeColor(ChangeColor.add, all: 12),),
                            // ),
                          ),
                        ),
                        Positioned.fill(
                          child: Hero(
                            tag: medium.id,
                            child: FadeInImage(
                              fit: BoxFit.cover,
                              placeholder: MemoryImage(kTransparentImage),
                              image: ThumbnailProvider(
                                mediumId: medium.id,
                                mediumType: medium.mediumType,
                                highQuality: true,
                              ),
                            ),
                          ),
                          // child: Hero(
                          //   tag: medium.id,
                          //   child: Image(
                          //     fit: BoxFit.cover,
                          //     // image: PhotoProvider(mediumId: medium.id),
                          //     image: ThumbnailProvider(
                          //       mediumId: medium.id,
                          //       mediumType: medium.mediumType,
                          //       highQuality: true
                          //     ),
                          //     loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
                          //       if (loadingProgress == null) return child;
                          //       return Center(
                          //         child: CircularProgressIndicator(
                          //           color: AppColors.themeColor.withOpacity(.5),
                          //           backgroundColor: Colors.white,
                          //           value: loadingProgress.expectedTotalBytes != null ? loadingProgress.cumulativeBytesLoaded/loadingProgress.expectedTotalBytes! : null,
                          //         ),
                          //       );
                          //     },
                          //   ),
                          // ),
                        ),
                        Positioned.fill(
                          child: Stack(
                            children: [
                              Positioned.fill(
                                child: AnimatedOpacity(
                                  opacity: inList ? 1 : 0,
                                  duration: const Duration(milliseconds: 300),
                                  child: Container(
                                    // color: const Color.fromARGB(255, 9, 0, 90).withOpacity(.35),
                                    color: AppColors.themeColor.withOpacity(.35),
                                  ),
                                ),
                              ),
                              Positioned(
                                top: 4.0,
                                right: 4.0,
                                child: AnimatedScale(
                                  scale: inList ? 1 : 0,
                                  duration: const Duration(milliseconds: 500),
                                  curve: const CustomEaseOutBackCurve(),
                                  child: Container(
                                    width: 24,
                                    height: 24,
                                    decoration: const BoxDecoration(
                                      shape: BoxShape.circle,
                                      // color: Color.fromARGB(255, 16, 0, 163),
                                      color: AppColors.themeColor,
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black,
                                          offset: Offset(0, 1),
                                          spreadRadius: 0,
                                          blurRadius: 2
                                        )
                                      ]
                                    ),
                                    child: Center(
                                      child: textStyled((listIndex + 1).toString(), 16, AppColors.textWhiteBase, fontWeight: FontWeight.w900),
                                      // child: Icon(
                                      //   Icons.check,
                                      //   color: AppColors.textWhiteBase,
                                      //   size: 16,
                                      // ),
                                    )
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        if(!isPhoto)
                        Positioned(
                          left: 2,
                          bottom: isPhoto ? 2 : 0,
                          child: Container(
                            width: isPhoto ? 16 : 20,
                            height: isPhoto ? 16 : 20,
                            decoration: BoxDecoration(
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.2),
                                  spreadRadius: 1,
                                  blurRadius: 8,
                                  offset: const Offset(0, 0),
                                ),
                              ],
                            ),
                            child: Icon(
                              isPhoto ? Icons.photo : CupertinoIcons.video_camera_solid,
                              size: isPhoto ? 16 : 20,
                              color: AppColors.primaryTextColor,
                            ),
                          ),
                        ),
                        Positioned.fill(
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              onTap: () => controller.selectMedium(medium),
                              onLongPress: () => controller.onImageLongPress(medium),
                              splashColor: isMultiselectedMode ? Colors.transparent : Colors.black26,
                              splashFactory: InkRipple.splashFactory,
                              highlightColor: Colors.transparent,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
              if(!controller.loading.value && controller.mediasInitialized.value && medias.isNotEmpty)
              GridView.builder(
                itemCount: medias.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: axisCount, mainAxisSpacing: axisSpacing, crossAxisSpacing: axisSpacing, childAspectRatio: 1),
                padding: EdgeInsets.only(bottom: isMultiselectedMode ? bottomSectionHeight : 0),
                itemBuilder: (context, index) {
                  final medium = medias[index];
                  final listIndex = selectedImages.indexWhere((selectedImage) => selectedImage.id == medium.id);
                  final inList = listIndex == -1 ? false : true;
                  final isPhoto = medium.mediumType == MediumType.image;
                  // controller.isSelected(medium);
                  return SizedBox(
                    child: Stack(
                      children: [
                        Positioned.fill(
                          child: Container(
                            color: const Color.fromRGBO(52, 53, 58, 1)
                            // child: Center(
                            //   child: Image.asset("assets/images/ic_ecinema-animation-logo.png", width: 36, height: 36, color: AppColors.scaffoldBackgroundColor.changeColor(ChangeColor.add, all: 12),),
                            // ),
                          ),
                        ),
                        Positioned.fill(
                          child: Hero(
                            tag: medium.id,
                            child: FadeInImage(
                              fit: BoxFit.cover,
                              placeholder: MemoryImage(kTransparentImage),
                              image: ThumbnailProvider(
                                mediumId: medium.id,
                                mediumType: medium.mediumType,
                                highQuality: true,
                              ),
                            ),
                          ),
                          // child: Hero(
                          //   tag: medium.id,
                          //   child: Image(
                          //     fit: BoxFit.cover,
                          //     // image: PhotoProvider(mediumId: medium.id),
                          //     image: ThumbnailProvider(
                          //       mediumId: medium.id,
                          //       mediumType: medium.mediumType,
                          //       highQuality: true
                          //     ),
                          //     loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
                          //       if (loadingProgress == null) return child;
                          //       return Center(
                          //         child: CircularProgressIndicator(
                          //           color: AppColors.themeColor.withOpacity(.5),
                          //           backgroundColor: Colors.white,
                          //           value: loadingProgress.expectedTotalBytes != null ? loadingProgress.cumulativeBytesLoaded/loadingProgress.expectedTotalBytes! : null,
                          //         ),
                          //       );
                          //     },
                          //   ),
                          // ),
                        ),
                        Positioned.fill(
                          child: Stack(
                            children: [
                              Positioned.fill(
                                child: AnimatedOpacity(
                                  opacity: inList ? 1 : 0,
                                  duration: const Duration(milliseconds: 300),
                                  child: Container(
                                    // color: const Color.fromARGB(255, 9, 0, 90).withOpacity(.35),
                                    color: AppColors.themeColor.withOpacity(.35),
                                  ),
                                ),
                              ),
                              Positioned(
                                top: 4.0,
                                right: 4.0,
                                child: AnimatedScale(
                                  scale: inList ? 1 : 0,
                                  duration: const Duration(milliseconds: 500),
                                  curve: const CustomEaseOutBackCurve(),
                                  child: Container(
                                    width: 24,
                                    height: 24,
                                    decoration: const BoxDecoration(
                                      shape: BoxShape.circle,
                                      // color: Color.fromARGB(255, 16, 0, 163),
                                      color: AppColors.themeColor,
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black,
                                          offset: Offset(0, 1),
                                          spreadRadius: 0,
                                          blurRadius: 2
                                        )
                                      ]
                                    ),
                                    child: Center(
                                      child: textStyled((listIndex + 1).toString(), 16, AppColors.textWhiteBase, fontWeight: FontWeight.w900),
                                      // child: Icon(
                                      //   Icons.check,
                                      //   color: AppColors.textWhiteBase,
                                      //   size: 16,
                                      // ),
                                    )
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        if(!isPhoto)
                        Positioned(
                          left: 2,
                          bottom: isPhoto ? 2 : 0,
                          child: Container(
                            width: isPhoto ? 16 : 20,
                            height: isPhoto ? 16 : 20,
                            decoration: BoxDecoration(
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.2),
                                  spreadRadius: 1,
                                  blurRadius: 8,
                                  offset: const Offset(0, 0),
                                ),
                              ],
                            ),
                            child: Icon(
                              isPhoto ? Icons.photo : CupertinoIcons.video_camera_solid,
                              size: isPhoto ? 16 : 20,
                              color: AppColors.primaryTextColor,
                            ),
                          ),
                        ),
                        Positioned.fill(
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              onTap: () => controller.selectMedium(medium),
                              onLongPress: () => controller.onImageLongPress(medium),
                              splashColor: isMultiselectedMode ? Colors.transparent : Colors.black26,
                              splashFactory: InkRipple.splashFactory,
                              highlightColor: Colors.transparent,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
              AnimatedPositioned(
                left: 0,
                bottom: isMultiselectedMode ? 0 : -bottomSectionHeight,
                duration: const Duration(milliseconds: 300),
                child: Container(
                  width: Get.width,
                  height: bottomSectionHeight,
                  padding: EdgeInsets.only(bottom: sizes.safePaddingBottom),
                  decoration: BoxDecoration(
                    color: AppColors.backgroundDark4,
                    border: Border(
                      top: BorderSide(
                        color: AppColors.barBorderColor,
                        width: 1
                      )
                    )
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Stack(
                          children: [
                            Positioned.fill(
                              right: 2,
                              child: ListView.separated(
                                shrinkWrap: true,
                                itemCount: selectedImages.length,
                                separatorBuilder: (context, index) => AppSpaces.horizontal4, 
                                padding: const EdgeInsets.fromLTRB(bottomSectionPadding,bottomSectionPadding,52,bottomSectionPadding),
                                scrollDirection: Axis.horizontal,
                                itemBuilder: (context, index) {
                                  final medium = selectedImages[index];
                                  final isPhoto = medium.mediumType == MediumType.image;
                                  return Container(
                                    clipBehavior: Clip.hardEdge,
                                    width: bottomSectionItemHeight,
                                    height: bottomSectionItemHeight,
                                    decoration: BoxDecoration(
                                      color: AppColors.backgroundLight2,
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    child: Stack(
                                      children: [
                                        Positioned.fill(
                                          child: Center(
                                            child: Image.asset("assets/images/ic_ecinema-animation-logo.png", width: 24, height: 24, color: AppColors.scaffoldBackgroundColor,)
                                          ),
                                        ),
                                        Positioned.fill(
                                          child: Container(
                                            clipBehavior: Clip.hardEdge,
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(4),
                                            ),
                                            child: medium.mediumType == MediumType.image ? Image(
                                              fit: BoxFit.cover,
                                              image: PhotoProvider(mediumId: medium.id),
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
                                            ) : FutureBuilder(
                                              future: medium.getThumbnail(), 
                                              builder: (context, snapshot) {
                                                if(snapshot.hasData) {
                                                  return Image.memory(Uint8List.fromList(snapshot.data!), fit: BoxFit.cover,);
                                                } else {
                                                  return const SizedBox.shrink();
                                                }
                                              }
                                            )
                                          ),
                                        ),
                                        Positioned(
                                          bottom: 0,
                                          right: 0,
                                          // right: (bottomSectionHeight - 28)/2,
                                          child: GestureDetector(
                                            onTap: () => controller.deSelectImage(medium),
                                            child: Container(
                                              width: 20,
                                              height: 16,
                                              decoration: const BoxDecoration(
                                                borderRadius: BorderRadius.only(
                                                  topLeft: Radius.circular(6)
                                                ),
                                                color: AppColors.errorColor,
                                              ),
                                              child: const Center(
                                                child: Padding(
                                                  padding: EdgeInsets.only(left: 1),
                                                  child: Icon(
                                                    CupertinoIcons.trash,
                                                    size: 10,
                                                    color: AppColors.textWhiteBase,
                                                  ),
                                                )
                                              ),
                                            ),
                                          ),
                                        ),
                                        if(!isPhoto)
                                        Positioned(
                                          left: 0,
                                          top: isPhoto ? 0 : -2,
                                          child: Container(
                                            width: isPhoto ? 16 : 20,
                                            height: isPhoto ? 16 : 20,
                                            decoration: BoxDecoration(
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Colors.black.withOpacity(0.2),
                                                  spreadRadius: 1,
                                                  blurRadius: 8,
                                                  offset: const Offset(0, 0),
                                                ),
                                              ],
                                            ),
                                            child: Icon(
                                              isPhoto ? Icons.photo : CupertinoIcons.video_camera_solid,
                                              size: isPhoto ? 12 : 16,
                                              color: AppColors.primaryTextColor,
                                            ),
                                          ),
                                        ),
                                        // OverflowBox(
                                        //   maxWidth: bottomSectionHeight,
                                        //   maxHeight: bottomSectionHeight,
                                        //   child: Stack(
                                        //     children: [
                                        //       Positioned(
                                        //         bottom: 8,
                                        //         right: (bottomSectionHeight - 28)/2,
                                        //         child: GestureDetector(
                                        //           onTap: () => controller.deSelectImage(medium),
                                        //           child: Container(
                                        //             width: 28,
                                        //             height: 16,
                                        //             decoration: BoxDecoration(
                                        //               borderRadius: BorderRadius.circular(4),
                                        //               color: AppColors.errorColor,
                                        //               // color: AppColors.backgroundLight4,
                                        //             ),
                                        //             child: const Center(
                                        //               child: Icon(
                                        //                 CupertinoIcons.trash,
                                        //                 size: 10,
                                        //                 color: AppColors.textWhiteBase,
                                        //               ),
                                        //             ),
                                        //           ),
                                        //         ),
                                        //       )
                                        //     ],
                                        //   )
                                        // ),
                                      ],
                                    )
                                  );
                                }, 
                              ),
                            ),
                            Positioned(
                              right: 0,
                              top: 0,
                              child: Container(
                                width: 60,
                                height: bottomSectionHeight,
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      AppColors.backgroundDark4,
                                      AppColors.backgroundDark4.withOpacity(0)
                                    ],
                                    begin: Alignment.centerRight,
                                    end: Alignment.centerLeft
                                  ),
                                ),
                              ),
                            )
                          ],
                        )
                      ),
                      AppSpaces.horizontal8,
                      Material(
                        clipBehavior: Clip.hardEdge,
                        color: AppColors.themeColor,
                        borderRadius: BorderRadius.circular(50),
                        child: InkWell(
                          onTap: () => controller.toViewer(selectedImages),
                          splashColor: Colors.black26,
                          highlightColor: Colors.transparent,
                          splashFactory: InkRipple.splashFactory,
                          child: SizedBox(
                            width: bottomSectionItemHeight,
                            height: bottomSectionItemHeight,
                            child: const Center(
                              // child: textStyled(selectedImages.length.toString(), 32, AppColors.textWhiteBase, fontWeight: FontWeight.w600),
                              child: Padding(
                                padding: EdgeInsets.only(left: 4),
                                child: Icon(
                                  Icons.send_rounded,
                                  size: 28,
                                  color: AppColors.textWhiteBase,
                                ),
                              )
                            ),
                          ),
                        ),
                      ),
                      AppSpaces.horizontal12
                    ],
                  ),
                ),
              )
            ],
          )
        );
      },
    );
  }
}

PreferredSize _appBar(double appBarHeight, double statusBarHeight, String albumName, int selectedImagesLength) {
  return PreferredSize(
    preferredSize: Size.fromHeight(appBarHeight), 
    child: Container(
      height: appBarHeight,
      width: Get.width,
      decoration: BoxDecoration(
        color: AppColors.appBarColor,
        border: Border(
          bottom: BorderSide(
            color: AppColors.barBorderColor,
            width: 1
          )
        )
      ),
      padding: EdgeInsets.fromLTRB(8.0, statusBarHeight, AppConstants.mHorizontalPadding, 0),
      child: Row(
        children: [
          Material(
            clipBehavior: Clip.hardEdge,
            borderRadius: BorderRadius.circular(50),
            color: Colors.transparent,
            child: InkWell(
              onTap: Get.back,
              highlightColor: Colors.transparent,
              splashFactory: InkRipple.splashFactory,
              splashColor: AppColors.backgroundDark4,
              child: const SizedBox(
                width: 40,
                height: 40,
                child: Center(
                  child: Icon(
                    Icons.arrow_back,
                    // color: AppColors.themeColor,
                    color: AppColors.secondaryTextColor,
                    size: 20,
                  ),
                ),
              ),
            ),
          ),
          AppSpaces.horizontal8,
          textStyled(albumName, 16, AppColors.secondaryTextColor),
          AppSpaces.expandedSpace,
          if(selectedImagesLength > 0)
          Container(
            width: 30,
            height: 30,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: AppColors.themeColor.withOpacity(.1),
            ),
            child: Center(
              child: textStyled(selectedImagesLength.toString(), 16, AppColors.themeColor, fontWeight: FontWeight.w600),
            ),
          )
        ],
      )
    ), 
  );
}