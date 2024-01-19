import 'package:ecinema_watch_together/utils/app/app_colors.dart';
import 'package:ecinema_watch_together/utils/app/app_constants.dart';
import 'package:ecinema_watch_together/utils/app/app_sizes.dart';
import 'package:ecinema_watch_together/utils/app/app_spaces.dart';
import 'package:ecinema_watch_together/views/media_gallery/media_gallery_screen_controller.dart';
import 'package:ecinema_watch_together/widgets/text_styled.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:photo_gallery/photo_gallery.dart';
import 'package:transparent_image/transparent_image.dart';

class MediaGalleryScreen extends StatelessWidget {
  final List<String>? receivers;
  const MediaGalleryScreen({super.key, this.receivers});

  @override
  Widget build(BuildContext context) {
    final sizes = AppSizes(context);
    final appBarHeight = AppConstants.appBarHeight + sizes.statusBarHeight;
    const axisSpacing = 3.0;
    const axisCount = 2;
    const hasPadding = false;
    const horizontalPadding = hasPadding ? AppConstants.mHorizontalPadding : 0;
    final gridItemWidth = (Get.width - ((axisCount - 1) * axisSpacing) - horizontalPadding)/axisCount;
    final albumPhotoHeight = gridItemWidth;
    final gridItemHeight = gridItemWidth;
    return GetBuilder(
      init: MediaGalleryScreenController(receivers: receivers),
      builder: (controller) {
        return Scaffold(
          backgroundColor: const Color.fromRGBO(20, 21, 26, 1),
          appBar: _appBar(appBarHeight, sizes.statusBarHeight),
          body: Stack(
            fit: StackFit.expand,
            children: [
              if(controller.isLoading.value)
              const Center(
                child: CircularProgressIndicator(),
              ),
              if(!controller.isLoading.value && controller.albums.value == null)
              Center(
                child: textStyled("ALBUM BOŞ", 20, AppColors.textWhiteDark1)
              ),
              if(!controller.isLoading.value && controller.albums.value != null)
              ScrollConfiguration(
                behavior: const ScrollBehavior().copyWith(overscroll: false),
                child: GridView.count(
                  childAspectRatio: gridItemWidth/gridItemHeight,
                  crossAxisCount: axisCount,
                  mainAxisSpacing: axisSpacing,
                  crossAxisSpacing: axisSpacing,
                  // padding: const EdgeInsets.all(AppConstants.mHorizontalPadding),
                  padding: EdgeInsets.only(bottom: sizes.safePaddingBottom),
                  children: <Widget>[
                    ...controller.albums.value!.map(
                      (album) => SizedBox(
                        width: gridItemWidth,
                        height: gridItemHeight,
                        child: Stack(
                          fit: StackFit.expand,
                          children: [
                            Stack(
                              children: [
                                Positioned.fill(
                                  child: FadeInImage(
                                    fit: BoxFit.cover,
                                    placeholder: MemoryImage(kTransparentImage),
                                    image: AlbumThumbnailProvider(
                                      album: album,
                                      highQuality: true,
                                    ),
                                  ),
                                ),
                                Positioned(
                                  bottom: 0,
                                  left: 0,
                                  child: Container(
                                    height: gridItemWidth,
                                    width: gridItemWidth,
                                    padding: const EdgeInsets.fromLTRB(6, 18, 6, 2),
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        colors: [Colors.black.withOpacity(.5), const Color.fromRGBO(255, 255, 255, 0)],
                                        begin: Alignment.bottomCenter,
                                        end: Alignment.topCenter
                                      ),
                                    ),
                                    child: Align(
                                      alignment: Alignment.bottomCenter,
                                      child: Row(
                                        children: [
                                          Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              const Padding(
                                                padding: EdgeInsets.only(bottom: 2),
                                                child: Icon(
                                                  // Icons.folder_rounded,
                                                  CupertinoIcons.folder_fill,
                                                  size: 12,
                                                  color: Colors.white,
                                                ),
                                              ),
                                              AppSpaces.horizontal4,
                                              textStyled(album.name != null ? album.name! : "Unnamed Album", 10, Colors.white,),
                                            ],
                                          ),
                                          AppSpaces.horizontal8,
                                          AppSpaces.expandedSpace,
                                          textStyled(album.count.toString(), 10, Colors.white, textAlign: TextAlign.right)
                                        ],
                                      ),
                                    )
                                  )
                                ),
                              ],
                            ),
                            Material(
                              color: Colors.transparent,
                              child: InkWell(
                                onTap: () async => await controller.selectAlbum(album),
                                splashColor: Colors.black26,
                                splashFactory: InkRipple.splashFactory,
                                highlightColor: Colors.transparent,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              // LayoutBuilder(
              //   builder: (context, constraints) {
              //     double gridWidth = (constraints.maxWidth - 60) / 3;
              //     double gridHeight = gridWidth + 33;
              //     double ratio = gridWidth / gridHeight;
              //     return ScrollConfiguration(
              //       behavior: const ScrollBehavior().copyWith(overscroll: false),
              //       child: GridView.count(
              //         childAspectRatio: ratio,
              //         crossAxisCount: axisCount,
              //         mainAxisSpacing: axisSpacing,
              //         crossAxisSpacing: axisSpacing,
              //         padding: const EdgeInsets.all(AppConstants.mHorizontalPadding),
              //         children: <Widget>[
              //           ...controller.albums.value!.map(
              //             (album) => GestureDetector(
              //               onTap: () => RouteService.toAlbum(album: album, receiver: receiver, receivers: receivers),
              //               child: Column(
              //                 children: <Widget>[
              //                   ClipRRect(
              //                     borderRadius: BorderRadius.circular(5.0),
              //                     child: Container(
              //                       color: Colors.grey[300],
              //                       height: gridWidth,
              //                       width: gridWidth,
              //                       child: FadeInImage(
              //                         fit: BoxFit.cover,
              //                         placeholder: MemoryImage(kTransparentImage),
              //                         image: AlbumThumbnailProvider(
              //                           album: album,
              //                           highQuality: true,
              //                         ),
              //                       ),
              //                     ),
              //                   ),
              //                   Container(
              //                     alignment: Alignment.topLeft,
              //                     padding: const EdgeInsets.only(left: 2.0),
              //                     child: textStyled(album.name ?? "Unnamed Album", 16, AppColors.textWhiteBase),
              //                   ),
              //                   Container(
              //                     alignment: Alignment.topLeft,
              //                     padding: const EdgeInsets.only(left: 2.0),
              //                     child: Text(
              //                       album.count.toString(),
              //                       textAlign: TextAlign.start,
              //                       style: const TextStyle(
              //                         height: 1.2,
              //                         fontSize: 12,
              //                       ),
              //                     ),
              //                   ),
              //                 ],
              //               ),
              //             ),
              //           ),
              //         ],
              //       ),
              //     );
              //   },
              // ),
            ],
          )
        );
      },
    );
  }
}

PreferredSize _appBar(double appBarHeight, double statusBarHeight) {
  return PreferredSize(
    preferredSize: Size.fromHeight(appBarHeight), 
    child: Container(
      height: appBarHeight,
      width: Get.width,
      decoration: BoxDecoration(
        // color: AppColors.appBarColor,
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
        crossAxisAlignment: CrossAxisAlignment.center,
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
          textStyled("Gallery", 16, AppColors.secondaryTextColor),
        ],
      )
    ), 
  );
}