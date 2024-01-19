import 'package:ecinema_watch_together/controlllers/auth_controller.dart';
import 'package:ecinema_watch_together/controlllers/loading_controller.dart';
import 'package:ecinema_watch_together/services/app_services.dart';
import 'package:ecinema_watch_together/views/media_gallery/media_viewer/media_viewer_screen.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:photo_gallery/photo_gallery.dart';

class MediaViewerScreenController extends GetxController {
  final List<Medium> mediums;
  final List<String>? receivers;
  MediaViewerScreenController({required this.mediums, this.receivers});

  @override
  void onInit() {
    _initMediumDetails();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.leanBack, overlays: [SystemUiOverlay.top]);
    super.onInit();
  }

  @override
  void onClose() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: [SystemUiOverlay.top]);
    super.onClose();
  }

  final pageController = PageController();
  final textEditingController = TextEditingController();
  var mediumDetails = <MediumDetail>[].obs;
  var focusedMedium = Rx<MediumDetail?>(null);
  final focusNode = FocusNode();
  var message = "".obs;
  var currentPage = 0.obs;
  var canDelete = true.obs;
  var loading = false.obs;

  _initMediumDetails() async {
    for(final medium in mediums) {
      Uint8List? thumbnail;
      if(medium.mediumType == MediumType.video) {
        thumbnail = Uint8List.fromList(await medium.getThumbnail());
      }
      final detail = MediumDetail.fromJson({...medium.toJson, "thumbnail": thumbnail});
      mediumDetails.add(detail);
    }
    update();
  }

  void onTextChanged(String text) {
    message.value = text;
    update();
  }

  void onPageChanged(int index) {
    canDelete.value = false;
    currentPage.value = index;
    update();
    Future.delayed(const Duration(seconds: 1), () {
      canDelete.value = true;
      update();
    });
  }

  void deleteMedium(int index) {
    if(!canDelete.value || mediums.length == 1) return;
    print("INDEX: $index");
    mediums.removeAt(index);
    mediumDetails.removeAt(index);
    changePage(index == 0 ? 0 : index - 1);
    update();
  }

  void changePage(int index) => pageController.animateToPage(index, duration: const Duration(milliseconds: 500), curve: Curves.fastLinearToSlowEaseIn);

  Future<void> submit() async {
    // submit
    if(loading.value) return;
    _startLoading();
    try {
      List<MediaDetail> medias = [];
      final authController = Get.find<AuthController>();
      final user = authController.firebaseUser.value;
      if(user == null) throw "Kullanıcı bulunamadı giriş yaptıktan sonra tekrar deneyin";
      for(var i=0; i<mediums.length; i++) {
        final medium = mediums[i];
        print("ID: ${medium.id} TITLE: ${medium.title}, FILENAME: ${medium.filename}");
        final mediaType = medium.mediumType == MediumType.image ? MediaType.image : MediaType.video;
        final width = medium.width;
        final height = medium.height;
        final file = await medium.getFile();
        print("PATH: ${file.path}");
        final compressedFile = await AppServices.compressImage(file.path, ImageSize.small);
        final mediaDetail = MediaDetail(file: compressedFile, mediaType: mediaType, width: width!, height: height!, fileName: medium.filename, title: medium.title, duration: mediaType == MediaType.video ? medium.duration : null, createdAt: medium.creationDate, updatedAt: medium.modifiedDate);
        medias.add(mediaDetail);
      }
      // for(final media in medias) {
      //   // print("TITLE: ${media.}")
      // }
      Navigator.of(Get.context!).pop(medias);
    } catch(err) {
      print("MEDIA VIEWER ERROR: $err");
      Get.snackbar("Hata", "Resimleri sıkıştırırken bir hata ile karşılaşıldı", backgroundColor: Colors.white);
    } finally {
      _stopLoading();
    }
  }

  _startLoading() {
    loading.value = true;
    LoadingController.showLoading();
    update();
  }

  _stopLoading() {
    loading.value = false;
    LoadingController.hideLoading();
    update();
  }
}

// class LocalPrivateMessage {
//   final String text;
//   final PendingMessageImageDetail imageDetail;
//   final SentStatus sentStatus;
//   LocalPrivateMessage({required this.text, required this.imageDetail, required this.sentStatus});
// }

// class PendingMessageImageDetail {
//   final File file;
//   final double width;
//   final double height;
//   PendingMessageImageDetail({required this.file, required this.width, required this.height});
// }