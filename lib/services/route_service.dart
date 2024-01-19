import 'package:ecinema_watch_together/entities/app/gallery_picker.dart';
import 'package:ecinema_watch_together/entities/firestore/private_message_entity.dart';
import 'package:ecinema_watch_together/entities/firestore/user_entity.dart';
import 'package:ecinema_watch_together/utils/route_paths.dart';
import 'package:get/get.dart';
import 'package:photo_gallery/photo_gallery.dart';

class RouteService {
  static Future offAllOnboard() async => Get.offAllNamed(RoutePaths.onboard);
  static Future toHome() async => Get.toNamed(RoutePaths.home);
  static Future offAllHome() async => Get.offAllNamed(RoutePaths.home);
  static Future toLogin() async => Get.toNamed(RoutePaths.login);
  static Future offAllRegisterPhoneNumber() async => Get.offAllNamed(RoutePaths.registerPhoneNumber);
  static Future offAllRegisterVerify(String phoneNumber, int remaining) async => Get.offAllNamed(RoutePaths.registerVerify, arguments: {"phone_number": phoneNumber, "remaining": remaining});
  static Future toRegisterVerify(String phoneNumber, int remaining) async => Get.toNamed(RoutePaths.registerVerify, arguments: {"phone_number": phoneNumber, "remaining": remaining}, parameters: {"delay": "false", "can_pop": "false"});
  static Future offAllRegisterCompletion() async => Get.offAllNamed(RoutePaths.registerCompletion);
  static Future toRegisterCompletion() async => Get.toNamed(RoutePaths.registerCompletion);
  static Future offAllLogin() async => Get.offAllNamed(RoutePaths.login);
  // static Future toRegister() async => Get.toNamed(RoutePaths.register);
  // static Future offAllRegister() async => Get.offAllNamed(RoutePaths.register);
  static Future toUser(String userId) async => Get.toNamed(RoutePaths.user, arguments: {"user_id": userId});
  static Future toCinemas() async => Get.toNamed(RoutePaths.cinemas);
  static Future toCinemaSaloons(String cinemaId) async => Get.toNamed(RoutePaths.cinemaSaloons, arguments: {"cinema_id": cinemaId});
  static Future toCinemaRoom(String cinemaId, String roomId) async => Get.toNamed(RoutePaths.cinemaRoom, arguments: {"cinema_id": cinemaId, "room_id": roomId});
  static Future toPrivateChat({required String friendId, List<PrivateMessage>? pendingMessages}) async => Get.toNamed(RoutePaths.privateChatScreen, arguments: {"friend_id": friendId, "pending_messages": pendingMessages?.map((pendingMessage) => pendingMessage.toJson)});
  static Future toProfilePhoto(UserEntity user) async => Get.toNamed(RoutePaths.profilePhoto, arguments: {"user": user});
  static Future<T?> toMediaGallery<T>({List<String>? receivers}) async => await Get.toNamed<T>(RoutePaths.mediaGallery, arguments: {"receivers": receivers});
  static Future<T?> toAlbum<T>({required Album album, List<String>? receivers}) async => await Get.toNamed<T>(RoutePaths.albumScreen, arguments: {"album": album, "receivers": receivers});
  static Future<T?> toMediaViewer<T>({required List<Medium> mediums, List<String>? receivers}) async => await Get.toNamed<T>(RoutePaths.mediaViewer, arguments: {"mediums": mediums, "receivers": receivers});
  // static Future toProfilePhoto(UserEntity user) async => Get.toNamed(RoutePaths.profilePhoto, arguments: {"user": user});
  // static Future toProfilePhoto(UserEntity user) async => Get.toNamed(RoutePaths.profilePhoto, arguments: {"user": user});
  // static Future toPrivateChats(String cinemaId, String roomId) async => Get.toNamed(RoutePaths.cinemaRoom, arguments: {"cinema_id": cinemaId, "room_id": roomId});
  // static Future toGlobalChat(String cinemaId, String roomId) async => Get.toNamed(RoutePaths.cinemaRoom, arguments: {"cinema_id": cinemaId, "room_id": roomId});
  static Future toSettings() async => Get.toNamed(RoutePaths.settings);
  static Future toSplash() async => Get.toNamed(RoutePaths.splash);
  static Future toTry() async => Get.toNamed(RoutePaths.tryy);
}