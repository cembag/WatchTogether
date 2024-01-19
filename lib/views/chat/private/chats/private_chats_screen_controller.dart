import 'dart:async';
import 'package:ecinema_watch_together/controlllers/auth_controller.dart';
import 'package:ecinema_watch_together/entities/firestore/private_chat_detail_entity.dart';
import 'package:ecinema_watch_together/entities/firestore/private_message_entity.dart';
import 'package:ecinema_watch_together/entities/firestore/user_entity.dart';
import 'package:ecinema_watch_together/utils/firebase_db_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecinema_watch_together/services/app_services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/date_symbol_data_local.dart';
// import 'package:cloud_functions/cloud_functions.dart';
// import 'package:ecinema_watch_together/controlllers/auth_controller.dart';
// import 'package:ecinema_watch_together/entities/firestore/private_chat_detail_entity.dart';
// import 'package:ecinema_watch_together/entities/firestore/private_message_entity.dart';
// import 'package:ecinema_watch_together/entities/firestore/public_message_entity.dart';
// import 'package:ecinema_watch_together/entities/firestore/user_entity.dart';
// import 'package:ecinema_watch_together/utils/firebase_db_model.dart';
// import 'package:flutter/material.dart';

const _kChatDetailFetchLimit = 10;

class PrivateChatsScreenController extends GetxController {

  @override
  void onInit() {
    initializeDateFormatting(AppServices.locale.countryCode);
    dateTimer = Timer.periodic(const Duration(seconds: 1), (timer) { 
      currentDate.value = currentDate.value.add(const Duration(seconds: 1));
    });
    fetchChats();
    super.onInit();
  }

  @override
  void onClose() {
    dateTimer.cancel();
    super.onClose();
  }

  var chats = Rx<List<PrivateChat>>([]);
  var lastDocument = Rx<DocumentSnapshot<Map<String, dynamic>>?>(null);
  var isLoading = false.obs;
  var allChatsFetched = false.obs;

  DateTime get now => DateTime.now();
  AuthController get authController => Get.find<AuthController>();
  UserEntity? get appUser => authController.appUser.value;
  Future<QuerySnapshot<Map<String, dynamic>>> get chatsSnapshot {
    if(lastDocument.value == null) {
      return FirebaseFirestore.instance.collection('private_chats').where('users', arrayContains: FirebaseAuth.instance.currentUser!.uid).orderBy('last_message.created_at', descending: true).limit(_kChatDetailFetchLimit).get();
    } else {
      return FirebaseFirestore.instance.collection('private_chats').where('users', arrayContains: FirebaseAuth.instance.currentUser!.uid).orderBy('last_message.created_at', descending: true).startAfterDocument(lastDocument.value!).limit(_kChatDetailFetchLimit).get();
    }
  }

  final Stream<QuerySnapshot<Map<String, dynamic>>> chatStream = FirebaseFirestore.instance.collection('private_chats').where('users', arrayContains: FirebaseAuth.instance.currentUser!.uid).orderBy('last_message.created_at', descending: true).limit(_kChatDetailFetchLimit).snapshots();
  late final Timer dateTimer;
  var currentDate = DateTime.now().obs;

  fetchChats() async {
    if(isLoading.value) return;
    isLoading.value = true;
    try {
      final snapshot = await chatsSnapshot;
      final docs = snapshot.docs;
      for(var i=0; i<docs.length; i++) {
        final chatSnapshot = docs[i];
        final chatDetail = PrivateChatDetail.fromJsonFirebase({"id": chatSnapshot.id, ...chatSnapshot.data()});
        final friendId = chatDetail.users.firstWhere((id) => id != appUser!.id);
        final friendSnapshot = await FirebaseFirestore.instance.collection('users').doc(friendId).get();
        final friend = UserEntity.fromJsonFirebase({"id": friendSnapshot.id, ...friendSnapshot.data()!});
        final chat = PrivateChat(chatDetail: chatDetail, friend: friend);
        chats.value.add(chat);
        if(i == docs.length - 1) {
          lastDocument.value = chatSnapshot;
        }
        update();
      }
      if(docs.length < _kChatDetailFetchLimit) {
        allChatsFetched.value = true;
      }
      update();
    } catch(err) {
      print("ERR: $err");
    } finally {
      isLoading.value = false;
    }    
  }

  String getTime(DateTime now, DateTime date) {
    final diff = now.difference(date);
    final diffInSeconds = diff.inSeconds;
    final onDifferentDay = now.day != date.day;
    final languageCode = AppServices.locale.languageCode;
    switch(diffInSeconds) {
      case <= 24 * 60 * 60:
        final time = DateFormat.jm(languageCode).format(date);
        return onDifferentDay ? "dün $time" : time;
      case <= 24 * 60 * 60 * 7:
        return "${DateFormat('EEEE', languageCode).format(date)} ${DateFormat.jm(languageCode).format(date)}";
      case <= 24 * 60 * 60 * 7 * 52:
        return DateFormat('dd MMMM', languageCode).format(date);
      default:
        return DateFormat('dd MMMM yyyy', languageCode).format(date);
    }
  }

  Future<void> sendMessage() async {
    try {
      final authController = Get.find<AuthController>();
      final firebaseUser = authController.firebaseUser.value;
      final appUser = authController.appUser.value;
      if(firebaseUser == null || appUser == null) throw "Kullanıcı bulunamadı, lütfen giriş yaptıktan sonra tekrar deneyin.";
      const friendId = "XK3O1LX16oD0oyCCOLU7";
      final sender = firebaseUser.uid;
      var privateMessage = PrivateMessage(id: "", sender: sender, text: "DEVELOPER MESSAGE", readDetail: PrivateReadDetail(isRead: false, createdAt: null), viewers: [friendId, firebaseUser.uid], createdAt: now);
      final roomId = AppServices.getUniqueChatRoomId(firebaseUser.uid, friendId);
      // final hasRoomCreatedBefore = await FirebaseFirestore.instance.collection(DBModel.privateChats).doc(roomId).get().then((snapshot) => snapshot.data()?.isNotEmpty);
      final messageSnapshot = await FirebaseFirestore.instance.collection(DBModel.privateChats).doc(roomId).collection('messages').add(privateMessage.toJsonFirebase);
      final snapshot = await messageSnapshot.get();
      final lastMessage = PrivateMessage.fromJsonFirebase({"id": snapshot.id, ...snapshot.data()!});
      final PrivateChatDetail chatDetail = PrivateChatDetail(id: "", users: [friendId, appUser.id], lastMessage: lastMessage, writers: [], createdAt: now);
      await FirebaseFirestore.instance.collection(DBModel.privateChats).doc(roomId).set(chatDetail.toJsonFirebase);
      // if(hasRoomCreatedBefore != null && hasRoomCreatedBefore) {
      //   // update room
      //   final chatDetail = {"last_message": {'id': messageId, ...privateMessage,}, "last_message_sender": sender, "writers": [], 'updated_at': DateTime.now()};
      //   await FirebaseFirestore.instance.collection(DBModel.privateChats).doc(roomId).update(chatDetail);
      // } else {
      //   // create room
      //   final chatDetail = {"users": [firebaseUser.uid, friendId], "last_message": {'id': messageId, ...privateMessage}, "last_message_sender": sender, "writers": [], 'created_at': DateTime.now()};
      //   await FirebaseFirestore.instance.collection(DBModel.privateChats).doc(roomId).set(chatDetail);
      // }
      /// if selectedImages is not empty do ...
      /// 
      /// success
      // add message
      // final firebaseUser = FirebaseAuth.instance.currentUser;
      // if(firebaseUser == null) throw "Kullanıcı bulunamadı.";
      // final PrivateMessage message = PrivateMessage(id: "", from: firebaseUser.uid, to: "AsPhf9cWZcOnT3zZ8TRr", text: "Hahahahaahah! Beni güldürdün kardeşim, iyi şanslar", image: null, createdAt: DateTime.now());
      // print("MESSAGE: ${message.toJson}");
      // final result = await FirebaseFunctions.instance.httpsCallable('sendPrivateMessage').call(message.toJson);
      // print("DATA: ${result.data}");
      // Get.snackbar("Başarılı", "Mesaj başarılı bir şekilde gönderildi", backgroundColor: Colors.white);
    } on FirebaseException catch(err) {
      print("SEND_MESSAGE_ERROR: ${err.code}: ${err.message}}");
      Get.snackbar("Hata", "Mesaj gönderirken beklenmedik bir hata oluştu, lütfen daha sonra tekrar deneyin.", backgroundColor: Colors.white);
    } 
  }

}

// void _onSnapshot(QuerySnapshot<Map<String, dynamic>> snapshot) {
//   for(final change in snapshot.docChanges) {
//     final data = {...change.doc.data()!, 'id': change.doc.id};
//     final chatDetail = ChatDetail.fromJsonFirebase(data);
//     if(change.type == DocumentChangeType.added) {
//       addChatDetail(chatDetail);
//     } else if(change.type == DocumentChangeType.modified) {
//       updateChatDetail(chatDetail);
//     }
//   }
// }

// void addChatDetail(ChatDetail chatDetail) {
//   chatDetails.value.add(chatDetail);
//   update();
// }

// void updateChatDetail(ChatDetail chatDetail) {
//   final index = _getChatDetailIndex(chatDetail);
//   chatDetails.value[index] = chatDetail;
//   update();
// }

// int _getChatDetailIndex(ChatDetail chatDetail) => chatDetails.value.indexWhere((element) => element.id == chatDetail.id);

// void _subscribeToChats() => chatsSubscription = FirebaseFirestore.instance.collection(DBModel.userChats).orderBy('last_sent_at', descending: true).snapshots().listen(_onSnapshot);
// void _unSubscribeFromChats() => chatsSubscription.cancel();

//   Future<void> sendMessage() async {
//   if(loading.value) return;
//   _startLoading();
//   try {
//     final now = DateTime.now();
//     final authController = Get.find<AuthController>();
//     final firebaseUser = authController.firebaseUser.value;
//     final appUser = authController.appUser.value;
//     if(firebaseUser == null || appUser == null) throw "Kullanıcı bulunamadı, lütfen giriş yaptıktan sonra tekrar deneyin.";
//     const friendId = "zbMZIYwusKQ0JxxHFs3KzCWnohh1";
//     final profilePhoto = appUser.profilePhoto?.toJsonFirebase;
//     if(profilePhoto != null) profilePhoto.remove("created_at");
//     final sender = firebaseUser.uid;
//     var privateMessage = PrivateMessage(id: "", sender: sender, text: "DEVELOPER MESSAGE", readDetail: PrivateReadDetail(isRead: false, createdAt: null), createdAt: now);
//     final roomId = AppServices.getUniqueChatRoomId(firebaseUser.uid, friendId);
//     // final hasRoomCreatedBefore = await FirebaseFirestore.instance.collection(DBModel.privateChats).doc(roomId).get().then((snapshot) => snapshot.data()?.isNotEmpty);
//     final friendSnapshot = await FirebaseFirestore.instance.collection('users').doc(friendId).get(); 
//     final friend = UserEntity.fromJsonFirebase({...friendSnapshot.data()!, "id": friendSnapshot.id});
//     // final messageId = messageSnapshot.id;
//     final messageSnapshot = await FirebaseFirestore.instance.collection(DBModel.privateChats).doc(roomId).collection('messages').add(privateMessage.toJsonFirebase);
//     final PrivateChatDetail chatDetail = PrivateChatDetail(id: roomId, users: [sender, friendId], userDetails: {sender: UserDetail(id: sender, username: appUser.username, photo: appUser.profilePhoto == null ? null : ImageDetail(url: appUser.profilePhoto!.url, width: appUser.profilePhoto!.width, height: appUser.profilePhoto!.height), avatar: appUser.avatar, useAvatar: appUser.useAvatar), friendId: UserDetail(id: friendId, username: friend.username, photo: friend.profilePhoto == null ? null : ImageDetail(url: friend.profilePhoto!.url, width: friend.profilePhoto!.width, height: friend.profilePhoto!.height), avatar: friend.avatar, useAvatar: friend.useAvatar)}, writers: [], lastMessage: PrivateMessage.fromJson({...privateMessage.toJson, "id": messageSnapshot.id}), lastMessageSender: sender, createdAt: DateTime.now());
//     await FirebaseFirestore.instance.collection(DBModel.privateChats).doc(roomId).set(chatDetail.toJsonFirebase);
//     // if(hasRoomCreatedBefore != null && hasRoomCreatedBefore) {
//     //   // update room
//     //   final chatDetail = {"last_message": {'id': messageId, ...privateMessage,}, "last_message_sender": sender, "writers": [], 'updated_at': DateTime.now()};
//     //   await FirebaseFirestore.instance.collection(DBModel.privateChats).doc(roomId).update(chatDetail);
//     // } else {
//     //   // create room
//     //   final chatDetail = {"users": [firebaseUser.uid, friendId], "last_message": {'id': messageId, ...privateMessage}, "last_message_sender": sender, "writers": [], 'created_at': DateTime.now()};
//     //   await FirebaseFirestore.instance.collection(DBModel.privateChats).doc(roomId).set(chatDetail);
//     // }
//     /// if selectedImages is not empty do ...
//     /// 
//     /// success
//     // add message
//     // final firebaseUser = FirebaseAuth.instance.currentUser;
//     // if(firebaseUser == null) throw "Kullanıcı bulunamadı.";
//     // final PrivateMessage message = PrivateMessage(id: "", from: firebaseUser.uid, to: "AsPhf9cWZcOnT3zZ8TRr", text: "Hahahahaahah! Beni güldürdün kardeşim, iyi şanslar", image: null, createdAt: DateTime.now());
//     // print("MESSAGE: ${message.toJson}");
//     // final result = await FirebaseFunctions.instance.httpsCallable('sendPrivateMessage').call(message.toJson);
//     // print("DATA: ${result.data}");
//     // Get.snackbar("Başarılı", "Mesaj başarılı bir şekilde gönderildi", backgroundColor: Colors.white);
//   } on FirebaseFunctionsException catch(err) {
//     print("SEND_MESSAGE_ERROR: ${err.details}||${err.code}||${err.message}}");
//     Get.snackbar("Hata", "Mesaj gönderirken beklenmedik bir hata oluştu, lütfen daha sonra tekrar deneyin.", backgroundColor: Colors.white);
//   } finally {
//     _stopLoading();
//   }
// }
  
// var loading = false.obs;

//  _startLoading() {
//   loading.value = true;
//   LoadingController.showLoading();
// }

// _stopLoading() {
//   loading.value = false;
//   LoadingController.hideLoading();
// }

class PrivateChat {
  final PrivateChatDetail chatDetail;
  final UserEntity friend;
  PrivateChat({required this.chatDetail, required this.friend});
}