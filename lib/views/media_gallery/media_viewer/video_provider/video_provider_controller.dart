import 'dart:io';
import 'dart:async';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:appinio_video_player/appinio_video_player.dart';
import 'package:ecinema_watch_together/services/app_services.dart';
import 'package:ecinema_watch_together/utils/extensions/color_extension.dart';
import 'package:ecinema_watch_together/utils/extensions/file_extension.dart';
import 'package:ecinema_watch_together/utils/extensions/ui_image_extension.dart';
import 'package:photo_gallery/photo_gallery.dart';

class VideoProviderController extends GetxController {
  final Medium medium;
  VideoProviderController({required this.medium});

  @override
  void onInit() {
    _onInit();
    print("MEDIUM: ${medium.filename}");
    // print("OVERFLOW: ${Get.width + overflowWidth}, SETTINGSHORIZONTAL: $settingsHorizontalPadding, OVERFLOWWIDTH: $overflowWidth");
    super.onInit();
  }

  @override
  void dispose() {
    videoController?.dispose();
    videoPositionTimer?.cancel();
    super.dispose();
  }

  // @override
  // void onClose() {
  //   videoController?.dispose();
  //   videoPositionTimer?.cancel();
  //   super.onClose();
  // }

  late final File _file;
  Timer? videoPositionTimer;
  VideoPlayerController? videoController;
  var videoPosition = 0.obs;
  var thumbnails = <File>[].obs;

  VideoPlayerValue? get playerValue => videoController?.value;

  var cropLeftStartPositionLocal = 0.0.obs;
  var cropLeftPosition = 0.0.obs;
  var cropRightStartPositionLocal = 0.0.obs;
  var cropRightPosition = 0.0.obs;
  var croppedStartPositionLocal = 0.0.obs;
  var dragging = false.obs;
  // var croppedPosition = 0.0.obs;

  bool get isPlaying => videoController!.value.isPlaying;

  final settingsHeight = 82.0;
  final cropSectionHeight = 46.0;
  final thumbnailCount = 10;
  final trackWidth = 2.0;
  final draggableAreaLeftWidth = 50.0;
  final draggableAreaRightWidth = 10.0;
  final horizontalPadding = 30;
  final cropSectionWidth = Get.width - 16 * 2;

  double get videoStartPositionInMilliseconds {
    return (cropLeftPosition.value/cropSectionWidth) * videoController!.value.duration.inMilliseconds;
  }
  double get videoEndPositionInMilliseconds {
    return ((cropRightPosition.value - cropLeftPosition.value)/cropSectionWidth) * videoController!.value.duration.inMilliseconds;
  }

  // double get videoEndPosition => 
  double get croppedWidth => cropRightPosition.value - cropLeftPosition.value;
  double get cropLeftPositionMaxRight => cropRightPosition.value - draggableAreaLeftWidth + draggableAreaRightWidth - trackWidth;
  double get cropLeftPositionMaxLeft => 0.0; 
  double get cropRightPositionMaxRight => Get.width + overflowWidth - horizontalPadding - trackWidth - draggableAreaRightWidth;
  double get cropRightPositionMaxLeft => cropLeftPosition.value + draggableAreaLeftWidth - draggableAreaRightWidth + trackWidth;
  double get draggableAreaWidth => draggableAreaLeftWidth + draggableAreaRightWidth + trackWidth;
  double get thumbnailWidth => (Get.width - horizontalPadding * 2)/thumbnailCount;
  double get overflowWidth => draggableAreaLeftWidth - horizontalPadding;
  double get settingsHorizontalPadding => draggableAreaLeftWidth;

  double get trackPosition {
    final ratio = videoPosition.value == 0 ? 0 : medium.duration/videoPosition.value;
    print("RATIO: $ratio");
    return ratio == 0 ? 0 : (cropSectionWidth - trackWidth)/ratio;
  }

  _onVideoStateChange() {
    update();
  }

  toggleVideo() {
    if(isPlaying) {
      stopVideo();
    } else {
      playVideo();
    }
  }

  playVideo() => videoController!.play();
  stopVideo() => videoController!.pause();

  toggleVolume() {
    if(videoController!.value.volume == 0) {
      print("CP2");
      videoController!.setVolume(1);
    } else {
      print("CP3");
      videoController!.setVolume(0);
    }
  }

  _onInit() async {
    cropRightPosition.value = cropRightPositionMaxRight;
    _file = await medium.getFile();
    await initController(_file);
    await initThumbnails(_file);
  }

  Future<void> initController(File file) async {
    // final VideoPlayerOptions options = VideoPlayerOptions();
    videoController = VideoPlayerController.file(file);
    if(videoController == null) return;
    await videoController!.initialize();
    videoController!.addListener(_onVideoStateChange);
    // videoPositionTimer = Timer.periodic(const Duration(milliseconds: 100), (timer) async {
    //   videoPosition.value = (await videoController!.position)!.inMilliseconds;
    //   update();
    // });
    update();
  }

  Future<void> initThumbnails(File file) async {
    final duration = medium.duration;
    final part = duration/thumbnailCount;
    print("MILLISECONDSDURATION: $duration");
    for(var i=0; i<thumbnailCount; i++) {
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
          final thumbnailFile = await AppServices.getThumbnail(videoPath: _file.path, milliseconds: milliseconds);
          final uiImage = await thumbnailFile?.toImage();
          final averageColor = await uiImage?.averageColor;
          isDark = averageColor?.isAlmostDark;
          print("CLOSE BLACK LOOP IS DARK: ${averageColor?.isAlmostDark} CLOSE BLACK LOOP AVG COLOR: ${averageColor?.red}:${averageColor?.blue}:${averageColor?.green}");
          if(isDark == false) {
            thumbnails.add(thumbnailFile!);
            update();
            break;
          }
        } while(isDark == false || milliseconds > previousMilliseconds);
        if(isDark == true) {
          thumbnails.add(thumbnailFile);
          update();
        }
      } else {
        thumbnails.add(thumbnailFile);
        update();
      }
    }
  }

  onHorizontalDragStartLeft(DragStartDetails details) {
    final localPosition = details.localPosition.dx;
    cropLeftStartPositionLocal.value = localPosition;
    update();
    // stopVideo();
  }

  onHorizontalDragUpdateLeft(DragUpdateDetails details) {
    // final position = cropLeftStartPosition + details.globalPosition.dx;
    // print("OVERFLOWWIDTH: ${overflowWidth - settingsHorizontalPadding}");
    var position = details.globalPosition.dx - cropLeftStartPositionLocal.value + draggableAreaLeftWidth - horizontalPadding;
    print("POSITION: $position");
    if(position > cropLeftPositionMaxRight) {
      position = cropLeftPositionMaxRight;
    } else if(position < cropLeftPositionMaxLeft) {
      position = cropLeftPositionMaxLeft;
    }
    cropLeftPosition.value = position;
    dragging.value = true;
    update();
    // print("VIDEO POS: ${videoStartPositionInMilliseconds.toInt()}");
  }

  onHorizontalDragEndLeft(DragEndDetails details) {
    videoController!.seekTo(Duration(milliseconds: videoStartPositionInMilliseconds.toInt()));
    dragging.value = false;
    update();
  }

  onHorizontalDragStartRight(DragStartDetails details) {
    final position = details.localPosition.dx;
    cropRightStartPositionLocal.value = position;
    update();

  }
  onHorizontalDragUpdateRight(DragUpdateDetails details) {
    var position = details.globalPosition.dx - cropRightStartPositionLocal.value + draggableAreaLeftWidth - horizontalPadding;
    if(position > cropRightPositionMaxRight) {
      position = cropRightPositionMaxRight;
    } else if(position < cropRightPositionMaxLeft) {
      position = cropRightPositionMaxLeft;
    }
    cropRightPosition.value = position;
    dragging.value = true;
    update();
  }

  onHorizontalDragEndRight(DragEndDetails details) {
    dragging.value = false;
    update();
  }

  onHorizontalDragStartCropped(DragStartDetails details) {
    croppedStartPositionLocal.value = details.localPosition.dx;
    update();
  }

  onHorizontalDragUpdateCropped(DragUpdateDetails details) {
    print("cropped");
    final position = details.globalPosition.dx;
    var cropLeftPos = position - horizontalPadding - trackWidth - croppedStartPositionLocal.value;
    var cropRightPos = cropLeftPos + croppedWidth;
    if(cropLeftPos > cropLeftPositionMaxRight) {
      cropLeftPos = cropLeftPositionMaxRight;
    } else if(cropLeftPos < cropLeftPositionMaxLeft) {
      cropLeftPos = cropLeftPositionMaxLeft;
    }
    if(cropRightPos > cropRightPositionMaxRight) {
      cropRightPos = cropRightPositionMaxRight;
    } else if(cropRightPos < cropRightPositionMaxLeft) {
      cropRightPos = cropRightPositionMaxLeft;
    }
    if(cropRightPos - cropLeftPos < croppedWidth) return;
    cropRightPosition.value = cropRightPos;
    cropLeftPosition.value = cropLeftPos;
    dragging.value = true;
    update();
  }

  onHorizontalDragEndCropped(DragEndDetails details) {
    videoController!.seekTo(Duration(milliseconds: videoStartPositionInMilliseconds.toInt()));
    dragging.value = false;
    update();
  }
}