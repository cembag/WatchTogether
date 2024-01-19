import 'dart:io';
import 'dart:convert';
import 'dart:ui' as ui;
import 'package:crypto/crypto.dart';
import 'package:ecinema_watch_together/services/route_service.dart';
import 'package:ecinema_watch_together/utils/app/app_colors.dart';
import 'package:ecinema_watch_together/widgets/dialogs/media_library_permission_dialog.dart';
import 'package:ecinema_watch_together/widgets/text_styled.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:video_compress/video_compress.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

class AppServices {
  static AppServices get instance => AppServices();


  final _picker = ImagePicker();
  static Locale get locale => Locale(ui.window.locale.languageCode, ui.window.locale.countryCode);

  static void unfocus() => Get.context ?? FocusScope.of(Get.context!).unfocus();
  static void hideKeyboard() => SystemChannels.textInput.invokeMethod('TextInput.hide');

  static Future<File?> getThumbnail({required String videoPath, double? milliseconds, int? quality}) async {
    final tempDir = await getTemporaryDirectory();
    final tempPath = '${tempDir.path}/thumbnail-${DateTime.now().millisecondsSinceEpoch}.jpg';
    final timeMs = milliseconds != null ? milliseconds.toInt() : 0;
    print("TIME MS: $timeMs");
    final thumbnailPath = await VideoThumbnail.thumbnailFile(
      video: videoPath,
      timeMs: timeMs,
      quality: quality ?? 10,
      thumbnailPath: tempPath,
      imageFormat: ImageFormat.JPEG,
    );
    getTemporaryDirectory();
    print("THUMBNAIL PATH: $thumbnailPath");
    if(thumbnailPath == null) return null;
    return File(thumbnailPath);
  }

  static Future<File> compressVideo(String videoPath) async {
    final info = await VideoCompress.compressVideo(
      videoPath,
      quality: VideoQuality.MediumQuality, // Sıkıştırma kalitesi
    );

    return info!.file!;
  }

  static Future<File> compressImage(String imagePath, ImageSize imageSize) async {
    // int targetSizeInBytes = 600 * 1024; // 600KB target size
    Offset targetSize = _getTargetSizeOfImage(imageSize);
    double targetSizeInBytes = targetSize.dx * targetSize.dy; // 600KB target size
    int quality = 95;
    Uint8List? compressedImage;

    do {
      print("IMAGE_COMPRESSING_QUALITY: $quality");
      // compress image
      compressedImage = await FlutterImageCompress.compressWithFile(
        imagePath,
        minWidth: targetSize.dx.toInt(),
        minHeight: targetSize.dy.toInt(),
        quality: quality,
        format: CompressFormat.jpeg,
      );

      final compressedSize = compressedImage!.length;

      // check compressed image size
      if (compressedSize > targetSizeInBytes) {
        quality -= 5;
      }
    } while (compressedImage.length > targetSizeInBytes);

    // save compressed image
    final tempDir = await getTemporaryDirectory();
    final tempFile = File('${tempDir.path}/compressed-${DateTime.now().millisecondsSinceEpoch}.jpeg');
    await tempFile.writeAsBytes(Uint8List.fromList(compressedImage));
    File compressedFile = File(tempFile.path);

    final compressedWidth = compressedFile.readAsBytesSync();
    print("Sıkıştırılmış resmin boyutu: ${compressedWidth.length} bytes, PATH: ${compressedFile.path}");
    return compressedFile;
  }

  static void showToast(String message) {
    Get.closeCurrentSnackbar();
    Get.snackbar(
      '', 
      '',
      duration: const Duration(milliseconds: 1500),
      backgroundColor: Colors.transparent,
      snackPosition: SnackPosition.BOTTOM,
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 52),
      padding: EdgeInsets.zero,
      titleText: Container(),
      barBlur: 0,
      messageText: Center(
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: Colors.black,
          ),
          child: textStyled(message, 14, AppColors.secondaryTextColor),
        ),
      ),
    );
  }

  Future<MediaDetail?> pickImage() async {
    final xFile = await _picker.pickImage(source: ImageSource.gallery);
    if(xFile == null) return null;
    final file = File(xFile.path);
    final decodedImage = await decodeImageFromList(file.readAsBytesSync());
    final imageWidth = decodedImage.width;
    final imageHeight = decodedImage.height;
    final mediaDetail = MediaDetail(file: file, mediaType: MediaType.image, width: imageWidth, height: imageHeight);
    return mediaDetail;
  }

  Future<List<MediaDetail>?> pickMedia({List<String>? receivers}) async {
    Permission.photos.onLimitedCallback(() => print("MEDIA LIBRARY PERMISSON LIMITED"));
    Permission.photos.onDeniedCallback(() => print("MEDIA LIBRARY PERMISSON DENIED"));
    // final status = await Permission.photos.status;
    final status2 = await Permission.mediaLibrary.status;
    // final status2 = await Permission.me
    print("STATUS: ${status2.name}, MEDIASTATUS: ${status2.name}");
    if(status2 == PermissionStatus.denied) {
      showMediaLibraryPermissionDialog(Get.context!);
      return null;
    }
    final List<MediaDetail>? images = await RouteService.toMediaGallery(receivers: receivers) as List<MediaDetail>?;
    return images;
  }

  static String getUniqueChatRoomId(String uid1, String uid2) {
    // İki benzersiz string ifadeyi birleştirin (sıralamaya bakılmaksızın)
    String combinedString = (uid1.compareTo(uid2) < 0) ? uid1 + uid2 : uid2 + uid1;

    // SHA-256 ile karma işlemi yapın
    var bytes = Uint8List.fromList(utf8.encode(combinedString));
    var hash = sha256.convert(bytes);

    // Karma sonucunu hex formatında alın
    String uniqueKey = hash.toString();
    return uniqueKey;
  }

  // ratio -> width/height
  Offset limitImageSize(Offset limitOffset, double ratio) {
    var dx = 0.0;
    var dy = 0.0;

    final limitX = limitOffset.dx;
    final limitY = limitOffset.dy;

    if(ratio > 1) {
      dx = limitX;
      dy = dx * 1/ratio;
      if(dy > limitY) {
        dy = limitY;
        dx = dy * ratio;
      }
    } else {
      dy = limitY;
      dx = dy * ratio;
      if(dx > limitX) {
        dx = limitX;
        dy = dx * 1/ratio;
      }
    }

    return Offset(dx, dy);
  }
}

class MediaDetail {
  final File file;
  final MediaType mediaType;
  final int width;
  final int height;
  final String? title;
  final String? fileName;
  final int? duration;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  MediaDetail({required this.file, required this.mediaType, required this.width, required this.height, this.title, this.fileName, this.duration, this.createdAt, this.updatedAt});
}

enum ImageSize {
  ultrahd,
  hd,
  normal,
  small,
  avatar,
}

enum MediaType {
  image,
  video
}

Offset _getTargetSizeOfImage(ImageSize imageSize) {
  switch(imageSize) {
    case ImageSize.ultrahd:
      return const Offset(4096, 4096);
    case ImageSize.hd:
      return const Offset(2048, 2048);
    case ImageSize.normal:
      return const Offset(1240, 1240);
    case ImageSize.small:
      return const Offset(800, 800);
    case ImageSize.avatar:
      return const Offset(80, 80);
  }
}