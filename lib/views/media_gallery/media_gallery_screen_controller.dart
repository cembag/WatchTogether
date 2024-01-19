import 'dart:io';
import 'package:ecinema_watch_together/services/app_services.dart';
import 'package:ecinema_watch_together/services/route_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:photo_gallery/photo_gallery.dart';

class MediaGalleryScreenController extends GetxController {
  final List<String>? receivers;
  MediaGalleryScreenController({this.receivers});
  
  @override
  void onInit() {
    initAsync();
    super.onInit();
  }

  var albums = Rx<List<Album>?>(null);
  var isLoading = false.obs;
  
  Future<void> initAsync() async {
    _startLoading();
    final isPermissionGranted = await _promptPermissionSetting();
    if(isPermissionGranted) {
      List<Album> albums_ = await PhotoGallery.listAlbums();
      albums.value = albums_;
    } else {
      Get.back();
    }
    _stopLoading();
  }

  Future<bool> _promptPermissionSetting() async {
    if (Platform.isIOS) {
      if (await Permission.photos.request().isGranted || await Permission.storage.request().isGranted) {
        return true;
      }
    }
    if (Platform.isAndroid) {
      if (await Permission.storage.request().isGranted ||
          await Permission.photos.request().isGranted &&
          await Permission.videos.request().isGranted) {
        return true;
      }
    }
    return false;
  }

  _startLoading() {
    isLoading.value = true;
    update();
  }

  _stopLoading() {
    isLoading.value = false;
    update();
  }

  Future<void> selectAlbum(Album album) async {
    final context = Get.context;
    if(context == null) return;
    await RouteService.toAlbum(album: album, receivers: receivers).then((images) {
      if(images == null) return;
      if((images as List).isNotEmpty) {
        Navigator.of(context).pop(images);
      }
    });
  }
}