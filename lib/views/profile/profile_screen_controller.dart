import 'dart:io';
import 'dart:async';
import 'package:ecinema_watch_together/controlllers/auth_controller.dart';
import 'package:ecinema_watch_together/controlllers/loading_controller.dart';
import 'package:ecinema_watch_together/dal/storage_dal.dart';
import 'package:ecinema_watch_together/dal/user_dal.dart';
import 'package:ecinema_watch_together/entities/firestore/user_entity.dart';
import 'package:ecinema_watch_together/services/app_services.dart';
import 'package:ecinema_watch_together/utils/app/app_constants.dart';
import 'package:ecinema_watch_together/views/profile/profile_screen.dart';
import 'package:ecinema_watch_together/widgets/modals/animated_modal.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image/image.dart' as img;

class ProfileScreenController extends GetxController {

  @override
  void onInit() {
    print("ON PROFILE CONTROLLER INIT: ${appUser!.bio}");
    _initBio();
    _initAvatars();
    // _preCache();
    super.onInit();
  }

  @override
  void onClose() {
    print("ON PROFILE CONTROLLER CLOSE");
    bioTextController.dispose();
    bioTextFocusNode.dispose();
    super.onClose();
  }

  final authController = Get.find<AuthController>();

  UserEntity? get appUser => authController.appUser.value;
  User? get firebaseUser => authController.firebaseUser.value;

  late final List<String> avatars;
  late final List<String> manAvatars;
  late final List<String> womanAvatars;
  late final List<String> noGenderAvatars;
  final bioTextController = TextEditingController();
  final bioTextFocusNode = FocusNode();
  final List<AvatarMenuTitle> avatarMenuTitles = [AvatarMenuTitle(value: "All", title: "Tümü"), AvatarMenuTitle(value: "W", title: "Kadın") , AvatarMenuTitle(value: "M", title: "Erkek") , AvatarMenuTitle(value: "N", title: "Ortak")];

  final avatarImageWidth = 120.0;

  var loading = false.obs;
  var avatarMenu = false.obs;
  var selectedAvatar = "0".obs;
  var selectedTitle = "W".obs;
  var bio = "".obs;

  // void _preCache() {
  //   if(authController.appUser.value != null && authController.appUser.value!.profilePhoto != null) {
  //     print("PRECACHE");
  //     precacheImage(NetworkImage(authController.appUser.value!.profilePhoto!.url), Get.context!);
  //     // precacheImage(AssetImage(authController.appUser.value!.avatar), Get.context!);
  //   }
  // }

  void toggleAvatarMenu() {
    avatarMenu.value = !avatarMenu.value;
    update();
  }

  _initBio() {
    print("APP USER BIO: ${appUser!.bio}");
    final userBio = appUser!.bio.replaceAll(r'\n', '\n');
    bioTextController.text = userBio;
    bio.value = userBio;
    update();
  }

  void onBioTextChanged(String text) => _setBio(text);

  void _setBio(String text) {
    text.replaceAll(r'\n', '\n');
    bio.value = text;
    update();
  }

  void openAvatarMenu() {
    const avatarPickerMaxWidth = 320.0;
    const avatarMaxWidth = 60.0;
    const avatarMinWidth = 42.0;
    const avatarPickerRatio = 1;
    final avatarPickerWidth = Get.width - 2 * AppConstants.mHorizontalPadding > avatarPickerMaxWidth ? avatarPickerMaxWidth : Get.width - 2 * AppConstants.mHorizontalPadding;
    final avatarPickerHeight = avatarPickerWidth * avatarPickerRatio;

    showAnimatedModal(
      context: Get.context!, 
      shadowColor: Colors.black.withOpacity(.5),
      width: avatarPickerWidth,
      height: avatarPickerHeight,
      child: menuModal(this, avatarPickerWidth, avatarPickerHeight)
    );
  }

  List<String> get menuAvatars {
    switch(selectedTitle.value) {
      case 'W':
        return womanAvatars;
      case 'M':
        return manAvatars;
      case 'N':
        return noGenderAvatars;
      case 'All':
        return avatars;
      default:
        return avatars;
    }
  }

  void setSelectedAvatar(String avatar) {
    selectedAvatar.value = avatar;
    update();
  }

  void setSelectedTitle(String gender) {
    selectedTitle.value = gender;
    update();
  }

  bool isAvatarSelectable(String gender, String avatarString) {
    final avatar = int.parse(avatarString);
    switch(gender) {
      case 'W':
        return avatar >= 256;
      case 'M':
        return avatar < 256 || avatar >= 512;
      default:
        return avatar >= 512;
    }
  }

  _initAvatars() {
    final authController = Get.find<AuthController>();
    setSelectedAvatar(authController.appUser.value!.avatar);
    setSelectedTitle(authController.appUser.value!.gender);
    manAvatars = List.generate(AppConstants.manAvatars, (i) => (i + AppConstants.manAvatarsStartingPoint).toString());
    womanAvatars = List.generate(AppConstants.womanAvatars, (i) => (i + AppConstants.womanAvatarsStartingPoint).toString());
    noGenderAvatars = List.generate(AppConstants.noGenderAvatars, (i) => (i + AppConstants.noGenderAvatarsStartingPoint).toString());
    avatars = manAvatars + womanAvatars + noGenderAvatars;
    for(final avatar in avatars) {
      final image = AssetImage('assets/images/avatars/ic_icon-avatar$avatar.png');
      precacheImage(image, Get.context!);
    }
  }

  _startLoading() {
    LoadingController.showLoading();
    loading.value = true;
  }

  _stopLoading() {
    LoadingController.hideLoading();
    loading.value = false;
  }

  Future<File?> _convertXFileToFile(XFile xFile) async {
    final filePath = xFile.path;
    img.Image? image = img.decodeImage(File(filePath).readAsBytesSync());
    if(image == null) return null;
    final tempFile = File(filePath);
    tempFile.writeAsBytesSync(img.encodeJpg(image, quality: 100));
    return tempFile;
  }

  Future<void> updateOrToggleUseAvatar({bool? useAvatar}) async {
    if(loading.value) return;
    _startLoading();
    try {
      if(firebaseUser == null) throw "Kullanıcı bulunamadı, giriş yaptıktan sonra tekrar deneyin";
      final appUser = authController.appUser.value;
      if(appUser == null) throw "Kullanıcı bulunamadı, giriş yaptıktan sonra tekrar deneyin";
      await UserDal.instance.update(firebaseUser!.uid, {'use_avatar': useAvatar ?? !appUser.useAvatar});
      // authController.updateAppUser({'use_avatar': useAvatar ?? !appUser.useAvatar});
    } catch(err) {
      print("UPDATE_PHOTO_ERROR: $err");
      Get.snackbar("Hata", err.toString(), backgroundColor: Colors.white);
    } finally {
      _stopLoading();
    }
  }

  Future<void> updateUserPhoto() async {
    if(loading.value) return;
    try {
      final user = FirebaseAuth.instance.currentUser;
      if(user == null) throw "Kullanıcı bulunamadı, giriş yaptıktan sonra tekrar deneyin";
      final xFile = await ImagePicker().pickImage(source: ImageSource.gallery);
      if(xFile == null) return;
      _startLoading();
      final file = await _convertXFileToFile(xFile);
      if(file == null) throw "Resim dönüştürülürken beklenmedik bir hata ile karşılaşıldı, lütfen daha sonra tekrar deneyin";
      final decodedImage = await decodeImageFromList(file.readAsBytesSync());
      final imageWidth = decodedImage.width.toDouble();
      final imageHeight = decodedImage.height.toDouble();
      print('Resim Genişliği: $imageWidth');
      print('Resim Yüksekliği: $imageHeight');
      final photoName = "ic_profile-${DateTime.now().toIso8601String()}";
      final ref = StorageDal.userProfilePhotoRef(user.uid, photoName);
      final compressedFile = await AppServices.compressImage(file.path, ImageSize.small);
      final url = await StorageDal.uploadImage(ref, compressedFile);
      await user.updatePhotoURL(url);
      await UserDal.instance.update(FirebaseAuth.instance.currentUser!.uid, {'profile_photo': {'url': url, 'width': imageWidth, 'height': imageHeight, 'created_at': DateTime.now()}, 'use_avatar': false});
      print("URL: $url");
    } catch(err) {
      print("UPDATE_PHOTO_ERROR: $err");
      Get.snackbar("Hata", err.toString(), backgroundColor: Colors.white);
    } finally {
      _stopLoading();
    }
  }

  Future<void> updateUserAvatar() async {
    if(loading.value) return;
    _startLoading();
    try {
      final user = FirebaseAuth.instance.currentUser;
      if(user == null) throw "Kullanıcı bulunamadı, giriş yaptıktan sonra tekrar deneyin";
      await UserDal.instance.update(user.uid, {'avatar': selectedAvatar.value});
      // Get.snackbar("Başarılı", "Avatar değiştirildi", backgroundColor: Colors.white);
      // authController.updateAppUser({'avatar': selectedAvatar.value});
    } catch(err) {
      print("UPDATE_AVATAR_ERROR: $err");
      Get.snackbar("Hata", err.toString(), backgroundColor: Colors.white);
    } finally {
      Navigator.of(Get.context!).pop();
      _stopLoading();
    }
  }
}

class AvatarMenuTitle {
  final String value;
  final String title;

  AvatarMenuTitle({required this.value, required this.title});
}