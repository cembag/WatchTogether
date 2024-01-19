import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecinema_watch_together/controlllers/auth_controller.dart';
import 'package:ecinema_watch_together/entities/firestore/private_chat_detail_entity.dart';
import 'package:ecinema_watch_together/entities/firestore/private_message_entity.dart';
import 'package:ecinema_watch_together/entities/firestore/user_entity.dart';
import 'package:ecinema_watch_together/services/app_services.dart';
import 'package:ecinema_watch_together/utils/firebase_db_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';

const _kMessageFetchLimit = 20;
const _kMessageFetchLeeway = 100.0;

class PrivateChatScreenController extends GetxController {
  final String friendId;
  final List<PrivateMessage>? pendingMessages;
  PrivateChatScreenController({required this.friendId, this.pendingMessages});

  @override
  void onInit() {
    _subscribeToMessages();
    _subscribeToFriend();
    _subscribeToChat();
    initializeDateFormatting(AppServices.locale.languageCode);
    // FirebaseFirestore.instance.collection('private_chats').doc(roomId).collection('messages').where('deletes', isNotEqualTo: null).get().then((snapshots) {
    //   for(final doc in snapshots.docs) {
    //     FirebaseFirestore.instance.collection('private_chats').doc(roomId).collection('messages').doc(doc.id).delete();
    //   }
    // });
    super.onInit();
  }

  @override
  void onClose() {
    _unSubscribeFromMessages();
    _unsubscribeFromFriend();
    _unsubscribeFromChat();
    updateWritingStatus(false);
    super.onClose();
  }

  final authController = Get.find<AuthController>();

  late final StreamSubscription<QuerySnapshot<Map<String, dynamic>>> messagesSubscription;
  late final StreamSubscription<DocumentSnapshot<Map<String, dynamic>>> friendSubscription;
  late final StreamSubscription<DocumentSnapshot<Map<String, dynamic>>> chatSubscription;

  final firestore = FirebaseFirestore.instance;
  final textEditingController = TextEditingController();
  final textFieldScrollController = ScrollController();
  final scrollController = ScrollController();
  final focusNode = FocusNode();
  final storage = GetStorage();

  var message = "".obs;
  var friend = Rx<UserEntity?>(null);
  var chat = Rx<PrivateChatDetail?>(null);
  var messages = Rx<List<PrivateMessage>>([]);
  var selectedMedias = Rx<List<MediaDetail>>([]);
  var writingStatus = Rx<WritingStatus?>(null);
  var startAfter = Rx<DocumentSnapshot<Object?>?>(null);
  var haveAllMessagesFetched = false.obs;
  var messagesFetching = false.obs;
  var messageSending = false.obs;
  var isEmojiMenuOpen = false.obs;
  var selectedMessages = <PrivateMessage>[].obs;
  var replySelected = Rx<PrivateMessage?>(null);
  
  var loading = false.obs;

  DateTime get now => DateTime.now();
  UserEntity? get appUser => authController.appUser.value;
  String get roomId => AppServices.getUniqueChatRoomId(appUser!.id, friendId);

  toggleEmojiMenu() {
    if(isEmojiMenuOpen.value) {
      isEmojiMenuOpen.value = false;
    } else {
      isEmojiMenuOpen.value = true;
    }
    update();
  }

  _subscribeToMessages() {
    final authController = Get.find<AuthController>();
    if(authController.firebaseUser.value == null) return;
    final userId = authController.firebaseUser.value!.uid;
    final roomId = AppServices.getUniqueChatRoomId(userId, friendId);
    messagesSubscription = firestore.collection(DBModel.privateChats).doc(roomId).collection('messages').where("viewers", arrayContains: appUser!.id).orderBy("created_at", descending: true).limit(20).snapshots().listen(_onMessageSnapshot);
  }
  _unSubscribeFromMessages() => messagesSubscription.cancel();
  _subscribeToFriend() => friendSubscription = firestore.collection(DBModel.users).doc(friendId).snapshots().listen(_onFriendSnapshot);
  _unsubscribeFromFriend() => friendSubscription.cancel();
  _subscribeToChat() => chatSubscription = firestore.collection(DBModel.privateChats).doc(roomId).snapshots().listen(_onChatSnapshot);
  _unsubscribeFromChat() => chatSubscription.cancel();

  void scrollToMessage(BuildContext context, String messageId) {
    final messageKey = GlobalObjectKey(messageId);
    Scrollable.ensureVisible(
      messageKey.currentContext!,
      alignment: 0.5, // Widget'ın yatayda nerede görüneceğini belirler (0.5 ortada demektir)
      duration: const Duration(milliseconds: 500), // Animasyon süresi
    );
  }

  bool onScroll(ScrollUpdateNotification notification) {
    if(scrollController.position.maxScrollExtent - scrollController.position.pixels <= _kMessageFetchLeeway && !messagesFetching.value) {
      print("CP1");
      if(messages.value.isNotEmpty && !haveAllMessagesFetched.value && startAfter.value != null) {
        print("CP2");
        messagesFetching.value = true;
        firestore.collection(DBModel.privateChats).doc(roomId).collection('messages').where("deletes",).orderBy("created_at", descending: true).startAfterDocument(startAfter.value!).limit(_kMessageFetchLimit).get().then((querySnapshot) {
          final length = querySnapshot.size;
          if(length < _kMessageFetchLimit) {
            haveAllMessagesFetched.value = true;
            update();
          }
          for(var i=0; i<length; i++) {
            final doc = querySnapshot.docs[i];
            final message = PrivateMessage.fromJsonFirebase({...doc.data(), "id": doc.id});
            _addMessage(message);
            if(i == length - 1) {
              startAfter.value = doc;
            }
          }
        }).then((_) => messagesFetching.value = false);
      }
    }
    return true;
  }

  bool isSelected(PrivateMessage message) {
    final msg = selectedMessages.firstWhereOrNull((element) => element.id == message.id);
    return msg != null;
  }

  selectReplySelected(PrivateMessage message) {
    replySelected.value = message;
    focusNode.requestFocus();
  }

  unSelectReplySelected() {
    replySelected.value = null;
  }

  selectMessage(PrivateMessage message) {
    selectedMessages.add(message);
    update();
  }

  _addMessage(PrivateMessage message) {
    _deleteLocalMessage(message);
    messages.value.add(message);
    update();
  }

  _insertMessage(PrivateMessage message) {
    _deleteLocalMessage(message);
    messages.value.insert(0, message);
    update();
  }

  _updateMessage(PrivateMessage message) {
    final index = messages.value.indexWhere((element) => element.id == message.id);
    messages.value[index] = message;
    update();
  }

  _deleteLocalMessage(PrivateMessage message) {
    final index = messages.value.indexWhere((element) => element.id == message.id);
    if(index != -1) {
      messages.value.removeAt(index);
      update();
    }
  }

  void _onFriendSnapshot(DocumentSnapshot<Map<String, dynamic>> snapshot) {
    friend.value = UserEntity.fromJsonFirebase({...snapshot.data()!, 'id': snapshot.id});
    update();
  }

  void _onChatSnapshot(DocumentSnapshot<Map<String, dynamic>> snapshot) {
    chat.value = PrivateChatDetail.fromJsonFirebase({...snapshot.data()!, 'id': snapshot.id});
    // update();
  }

  void _onMessageSnapshot(QuerySnapshot<Map<String, dynamic>> snapshot) {
    if(startAfter.value == null) {
      if(snapshot.size < _kMessageFetchLimit) {
        haveAllMessagesFetched.value = true;
      }
      startAfter.value = snapshot.docChanges.lastOrNull?.doc;
      for(final change in snapshot.docChanges) {
        final data = {...change.doc.data()!, 'id': change.doc.id};
        final chatDetail = PrivateMessage.fromJsonFirebase(data);
        if(change.type == DocumentChangeType.added) {
          _addMessage(chatDetail);
        } else if(change.type == DocumentChangeType.modified) {
          _updateMessage(chatDetail);
        }
      }
    } else {
      for(final change in snapshot.docChanges) {
        final data = {...change.doc.data()!, 'id': change.doc.id};
        final chatDetail = PrivateMessage.fromJsonFirebase(data);
        if(change.type == DocumentChangeType.added) {
          _insertMessage(chatDetail);
        } else if(change.type == DocumentChangeType.modified) {
          _updateMessage(chatDetail);
        }
      }
    }
    // final length = snapshot.size;
    // for(var i=0; i<length; i++) {
    //   final change = snapshot.docChanges[i];
    //   final doc = change.doc;
    //   final data = {...doc.data()!, 'id': change.doc.id};
    //   final chatDetail = PrivateMessage.fromJsonFirebase(data);
    //   // if(messages.value.isEmpty && i == length -1) {
    //   //   print("IS EMPTY");
    //   //   startAfter.value = doc;
    //   //   update();
    //   // }
    //   print(chatDetail.createdAt);
    //   if(change.type == DocumentChangeType.added) {
    //     _addMessage(chatDetail);
    //   } else if(change.type == DocumentChangeType.modified) {
    //     _updateMessage(chatDetail);
    //   }
    // }
  }

  void onTextChange(String text) {
    message.value = text.trim();
    final status = writingStatus.value;
    final isWriting = text.isNotEmpty;
    if(friend.value!.isOnline) {
      final canUpdateWritingStatus =  (writingStatus.value == null ? true : status!.isWriting != isWriting);
      if(canUpdateWritingStatus) {
        updateWritingStatus(isWriting);
      }
    } else {
      if(chat.value!.writers.contains(appUser!.id)) {
        updateWritingStatus(false);
      }
    }
    // final canUpdateWritingStatus =  (writingStatus.value == null ? true : status!.isWriting != isWriting);
    // // final canUpdateWritingStatus = writingStatus.value == null ? true : (now.difference(status!.updatedAt).inSeconds > 5 && status.isWriting != isWriting);
    // if(canUpdateWritingStatus) {
    //   updateWritingStatus(text.isNotEmpty);
    // }
    update();
  }

  Future<void> updateWritingStatus(bool isWriting) async {
    print("WRITING STATUS UPDATING");
    try {
      await firestore.collection(DBModel.privateChats).doc(roomId).update({
        "writers": isWriting ? FieldValue.arrayUnion([appUser!.id]) : FieldValue.arrayRemove([appUser!.id]),
      });
      final newStatus = WritingStatus(isWriting: isWriting, updatedAt: now);
      writingStatus.value = newStatus;
      update();
    } catch(err) {
      print("ERROR WHEN UPDATE WRITING STATUS: $err");
    }
  }

  // Future<void> 
  
  Future<void> pickMedia() async {
    final medias = await AppServices.instance.pickMedia(receivers: [friend.value!.username]);
    if(medias == null) return;
    selectedMedias.value = medias;
    update();
    print("MEDIAS: $medias");
  }

  void removeMedia(int index) {
    selectedMedias.value.removeAt(index);
    update();
  }

  void _clear() {
    message.value = "";
    textEditingController.text = "";
    update();
  }

  // PrivateMessage? _findLastViewableMessage(int index) {
  //   do {
  //     index -= 1;
  //     final msg = messages.value[index];
  //     if(msg.viewers.contains(appUser!.id)) {
  //       return msg;
  //     }
  //   } while(index >= 0);
  //   return null;
  // }

  Future<void> deleteMessageFromUsers(String messageId, List<String> users) async {
    final index = messages.value.indexWhere((message) => message.id == messageId);
    var viewers = messages.value[index].viewers;
    try {
      messages.value[index].viewers = viewers.toSet().difference(users.toSet()).toList();
      await firestore.collection('private_chats').doc(roomId).collection('messages').doc(messageId).update({"viewers": FieldValue.arrayRemove(users)});
      if(chat.value!.lastMessage?.id == messageId) {
        await firestore.collection('private_chats').doc(roomId).update({"last_message.viewers": FieldValue.arrayRemove(users)});
      }
      // if(chat.value!.lastMessage.id == messageId) {
      //   final msg = _findLastViewableMessage(index);
      //   if(msg != null) {
      //     await firestore.collection('private_chats').doc(roomId).update({"last_message": msg.toJsonFirebase});
      //   } else {
      //     await firestore.collection('private_chats').doc(roomId).update({"last_message.viewers": FieldValue.arrayRemove(users)});
      //   }
      // }
      update();
    } catch(err) {
      print("ERROR WHEN DELETING MESSAGE FROM USERS: $err");
      Get.snackbar("Hata", "Mesaj silinemedi, lütfen daha sonra tekrar deneyin", backgroundColor: Colors.white);
      messages.value[index].viewers = viewers;
    }
  }

  Future<void> addMessageToLocal(PrivateMessage message) async {
    messages.value.insert(0, message);
    _clear();
  }
  
  Future<void> addMessageToDb(PrivateMessage message, String roomId) async {
    if(appUser == null) throw "Kullanıcı bulunamadı, lütfen giriş yaptıktan sonra tekrar deneyin.";
    await firestore.collection(DBModel.privateChats).doc(roomId).collection('messages').doc(message.id).set({...message.toJsonFirebase});
    final hasRoomCreatedBefore = await firestore.collection(DBModel.privateChats).doc(roomId).get().then((snapshot) => snapshot.data()?.isNotEmpty);
    if(hasRoomCreatedBefore != null && hasRoomCreatedBefore) {
      // update room
      final chatDetail = {"last_message": {'id': message.id, ...message.toJsonFirebase,}, "last_message_sender": appUser!.id, 'updated_at': DateTime.now()};
      await firestore.collection(DBModel.privateChats).doc(roomId).update(chatDetail);
    } else {
      // create room
      final privateChatDetail = PrivateChatDetail(id: "", users: [appUser!.id, friendId], lastMessage: message, writers: [], createdAt: DateTime.now());
      await firestore.collection(DBModel.privateChats).doc(roomId).set(privateChatDetail.toJsonFirebase);
    }
  }

  Future<void> sendMessage() async {
    // if(messageSending.value) return;
    if(message.value.isEmpty) return;
    _startMessageQueque();
    final now = DateTime.now();
    final authController = Get.find<AuthController>();
    final appUser = authController.appUser.value;
    if(appUser == null) throw "Kullanıcı bulunamadı, lütfen giriş yaptıktan sonra tekrar deneyin.";
    final messageId = "$roomId-${now.millisecondsSinceEpoch}";
    final privateMessage = PrivateMessage(id: messageId, sender: appUser.id, text: message.value, readDetail: PrivateReadDetail(isRead: false, createdAt: null), isSent: false, viewers: [friendId, appUser.id], createdAt: DateTime.now());
    await addMessageToLocal(privateMessage);
    if(scrollController.hasClients && scrollController.position.hasPixels && scrollController.position.pixels != 0) {
      scrollController.animateTo(0, duration: const Duration(milliseconds: 300), curve: Curves.easeIn);
    }
    try {
      // add message
      await addMessageToDb(privateMessage, roomId);
      await updateWritingStatus(false);
      /// if selectedImages is not empty do ...
      ///
      /// success
    } catch (err) {
      print("ERROR_WHEN_SEND_MESSAGE: $err");
      Get.snackbar("Hata", "Mesaj gönderilirken beklenmedik bir hata ile karşılaşıldı", backgroundColor: Colors.white);
      _deleteLocalMessage(privateMessage);
    } finally {
      _endMessageQueque();
    }
  }

  _startMessageQueque() {
    messageSending.value = true;
    update();
  }

  _endMessageQueque() {
    messageSending.value = false;
    update();
  }

  String getLastSeenTime(DateTime now, DateTime date) {
    final diff = now.difference(date);
    final diffInSeconds = diff.inSeconds;
    final onDifferentDay = now.day != date.day;
    final languageCode = AppServices.locale.languageCode;
    switch(diffInSeconds) {
      case <= 24 * 60 * 60:
        final time = DateFormat.jm(languageCode).format(date);
        return onDifferentDay ? "dün $time" : "bugün $time";
      case <= 24 * 60 * 60 * 7:
        return "${DateFormat('EEEE', languageCode).format(date)} ${DateFormat.jm(languageCode).format(date)}";
      case <= 24 * 60 * 60 * 7 * 52:
        return DateFormat('dd MMMM', languageCode).format(date);
      default:
        return DateFormat('dd MMMM yyyy', languageCode).format(date);
    }
  }
}

class WritingStatus {
  final bool isWriting;
  final DateTime updatedAt;
  WritingStatus({required this.isWriting, required this.updatedAt});
  factory WritingStatus.fromJson(dynamic json) => WritingStatus(isWriting: json['is_writing'], updatedAt: DateTime.parse(json['updated_at']));
  Map<String, dynamic> get toJson => {"is_writing": isWriting, "updated_at": updatedAt.toIso8601String()};
}