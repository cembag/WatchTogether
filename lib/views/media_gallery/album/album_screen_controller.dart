import 'package:ecinema_watch_together/services/app_services.dart';
import 'package:ecinema_watch_together/services/route_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:photo_gallery/photo_gallery.dart';

class AlbumScreenController extends GetxController {
  final Album album;
  final List<String>? receivers;
  AlbumScreenController({required this.album, this.receivers});

  @override
  void onInit() {
    initAsync();
    initializeDateFormatting(AppServices.locale.languageCode);
    super.onInit();
  }

  final mediasSmallCount = 50;
  // var loadingMedias = [12, 8, 20, 6, 30];
  var medias = Rx<List<Medium>>([]);
  var mediasSmall = Rx<List<Medium>>([]);
  var mediasSmallInitialized = false.obs;
  var mediasInitialized = false.obs;
  // var mediasSmall = Rx<List<_MediasSorted>>([]);
  // var medias = Rx<List<_MediasSorted>>([]);
  var selectedImages = Rx<List<Medium>>([]);
  var multiSelectMode = false.obs;
  var loading = false.obs;

  int get allMediasCount => album.count;

  Future<void> initSmallMedias() async {
    MediaPage mediaPage = await album.listMedia(take: mediasSmallCount);
    mediasSmall.value = mediaPage.items;
    mediasSmallInitialized.value = true;
    update();
    // for(var i=0; i<mediaPage.end; i++) {
    //   final medium = mediaPage.items[i];
    //   final previousMedium = i > 0 ? mediaPage.items[i - 1] : null;
    //   if(previousMedium == null) {
    //     mediasSmall.value.add(_MediasSorted(label: DateFormat("MMMM", AppServices.locale.languageCode).format(medium.creationDate!), medias: [medium]));
    //     update();
    //     continue;
    //   } 
    //   if(previousMedium.creationDate?.month != medium.creationDate?.month) {
    //     mediasSmall.value.add(_MediasSorted(label: DateFormat("MMMM", AppServices.locale.languageCode).format(medium.creationDate!), medias: [medium]));
    //     update();
    //   } else {
    //     mediasSmall.value.last.medias.add(medium);
    //     update();
    //   }
    // }
    // mediasSmallInitialized.value = true;
    // update();
  }

  Future<void> initAllMedias() async {
    if(allMediasCount <= mediasSmallCount) return;
    MediaPage mediaPage = await album.listMedia();
    medias.value = mediaPage.items;
    mediasInitialized.value = true;
    update();
    // for(var i=0; i<mediaPage.end; i++) {
    //   final medium = mediaPage.items[i];
    //   final previousMedium = i > 0 ? mediaPage.items[i - 1] : null;
    //   if(previousMedium == null) {
    //     medias.value.add(_MediasSorted(label: DateFormat("MMMM", AppServices.locale.languageCode).format(medium.creationDate!), medias: [medium]));
    //     update();
    //     continue;
    //   } 
    //   if(previousMedium.creationDate?.month != medium.creationDate?.month) {
    //     medias.value.add(_MediasSorted(label: DateFormat("MMMM", AppServices.locale.languageCode).format(medium.creationDate!), medias: [medium]));
    //     update();
    //   } else {
    //     medias.value.last.medias.add(medium);
    //     update();
    //   }
    // }
    // mediasInitialized.value = true;
    // update();
  }

  void initAsync() async {
    _startLoading();
    try {
      await initSmallMedias();
      await Future.delayed(const Duration(milliseconds: 500), () => initAllMedias());
    } catch (err) {
      print("ERROR: $err");
    } finally {
      _stopLoading();
    }
    // _startLoading();
    // try {
    //   MediaPage mediaPage = await album.listMedia();
    //   for(var i=0; i<mediaPage.end; i++) {
    //     final medium = mediaPage.items[i];
    //     final previousMedium = i > 0 ? mediaPage.items[i - 1] : null;
    //     if(previousMedium == null) {
    //       medias.value.add(_MediasSorted(label: DateFormat("MMMM", AppServices.locale.languageCode).format(medium.creationDate!), medias: [medium]));
    //       update();
    //     }
    //     if(previousMedium!.creationDate?.month != medium.creationDate?.month) {
    //       medias.value.last.medias.add(medium);
    //       update();
    //     } else {
    //       medias.value.add(_MediasSorted(label: DateFormat("MMMM", AppServices.locale.languageCode).format(medium.creationDate!), medias: [medium]));
    //       update();
    //     }
    //     // switch(medium.creationDate?.month) {

    //     // }
    //   }
    //   media.value = mediaPage.items;
    //   update();
    // } catch(err) {
    //   print("ERROR: $err");
    //   Get.snackbar("Hata", "Albümü ayrıştırırken bir sorunla karşılaşıldı", backgroundColor: Colors.white);
    // } finally {
    //   _stopLoading();
    // }
  }

  // _initMedias() {

  // }
  
  void selectImage(Medium medium) {
    if(selectedImages.value.length >= 10) {
      Get.closeCurrentSnackbar();
      AppServices.showToast("Tek seferde maksimum 10 içerik gönderebilirsiniz");
      return;
    }
    multiSelectMode.value = true;
    selectedImages.value.add(medium);
    update();
  }

  void deSelectImage(Medium medium) {
    final index = selectedImages.value.indexWhere((selectedImage) => selectedImage.id == medium.id);
    selectedImages.value.removeAt(index);
    if(selectedImages.value.isEmpty) {
      multiSelectMode.value = false;
    }
    update();
  }

  void _startLoading() {
    loading.value = true;
    update(); 
  }

  void _stopLoading() {
    loading.value = false;
    update(); 
  }

  // Future<void> onImageTap(Medium medium) async {
  //   final user = FirebaseAuth.instance.currentUser;
  //   if(user == null) throw "Kullanıcı bulunamadı lütfen daha sonra tekrar deneyin";
  //   final userId = user.uid;
  //   final joinedId = receiver ?? receivers!.join();
  //   final chatRoomId = AppServices.getUniqueChatRoomId(userId, joinedId);
  //   final file = await medium.getFile();
  //   final compressedFile = await AppServices.compressImage(file.path, ImageSize.small);
  //   final photoName = "ic_chat-${DateTime.now().toIso8601String()}";
  //   final ref = StorageDal.userChatPhotoRef(user.uid, chatRoomId, photoName);
  //   await StorageDal.uploadImage(ref, compressedFile);
  // }

  Future<void> selectMedium(Medium medium) async {
    if(multiSelectMode.value) {
      toggleImageStatus(medium);
    } else {
      // update();
      final mediums = selectedImages.value.isNotEmpty ? selectedImages.value : [medium];
      await toViewer(mediums);
    }
  }

  Future<void> toViewer(List<Medium> mediums) async {
    final context = Get.context;
    if(context == null) return;
    await RouteService.toMediaViewer(mediums: mediums, receivers: receivers).then((images) {
      if(images == null) return;
      if((images as List).isNotEmpty) {
        Navigator.of(context).pop(images);
      }
    });
  }

  void onImageTap(Medium medium) {
    if(multiSelectMode.value) {
      toggleImageStatus(medium);
    } else {
      final mediums = selectedImages.value.isNotEmpty ? selectedImages.value : [medium];
      RouteService.toMediaViewer(mediums: mediums, receivers: receivers);
    }
  }

  void onImageLongPress(Medium medium) => receivers == null ? selectMedium(medium) : toggleImageStatus(medium);
  
  void toggleImageStatus(Medium medium) {
    final contains = isSelected(medium);
    if(contains) {
      deSelectImage(medium);
    } else {
      selectImage(medium);
    }
  }

  bool isSelected(Medium medium) {
    final index = selectedImages.value.indexWhere((selectedImage) => selectedImage.id == medium.id);
    return index == -1 ? false : true;
  }

  String getTime(DateTime date) {
    final now = DateTime.now();
    final diff = now.difference(date);
    final diffInDays = diff.inDays;
    final languageCode = AppServices.locale.languageCode;
    switch(diffInDays) {
      case < 1:
        return "Son zamanlarda";
      case < 7:
        return DateFormat('EEEE', languageCode).format(date);
      case <= 31:
        return "Bu ay";
      case <= 365:
        return DateFormat('MMMM', languageCode).format(date);
      default:
        return DateFormat('dd MMMM yyyy', languageCode).format(date);
    }
  }
}

// class _MediasSorted {
//   final String label;
//   final List<Medium> medias;
//   _MediasSorted({required this.label, required this.medias});
// }