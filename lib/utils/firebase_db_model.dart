
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:ecinema_watch_together/entities/firestore/cinema_entity.dart';
// import 'package:ecinema_watch_together/entities/firestore/user_entity.dart';
import 'package:ecinema_watch_together/services/app_services.dart';
import 'package:firebase_auth/firebase_auth.dart';

class DBModel {
  static const users = "users";
  static const cinemas = "cinemas";
  static const chats = "chats";
  static const privateChats = "private_chats";
  static const globalChats = "global_chats";
  static const abuses = "abuses";
  static const reports = "reports";

  static cinemaSaloons(String cinemaId) => "$cinemas/$cinemaId/saloons";
  static String user(String uid) => "$users/$uid";  
  
  static String get userChats {
    final user = FirebaseAuth.instance.currentUser;
    return "$users/${user!.uid}/chats";
  }
  static userChat(String uid) {
    final user = FirebaseAuth.instance.currentUser;
    final uniqueChatRoomId = AppServices.getUniqueChatRoomId(FirebaseAuth.instance.currentUser!.uid, uid);
    return "$users/${user!.uid}/chats/$uniqueChatRoomId";
  }
  static userChatMessages(String uid) {
    final user = FirebaseAuth.instance.currentUser;
    final uniqueChatRoomId = AppServices.getUniqueChatRoomId(FirebaseAuth.instance.currentUser!.uid, uid);
    return "$users/${user!.uid}/chats/$uniqueChatRoomId/messages";
  }
  static globalChat(String countryCode) => "$globalChats/$countryCode";
  static globalChatMessages(String countryCode) => "$globalChats/$countryCode/messages";

  // static FirestoreDbModel get instance => FirestoreDbModel();
  // final CollectionReference<UserEntity> users = FirebaseFirestore.instance.collection(usersCollectionName).withConverter<UserEntity>(
  //   fromFirestore: (snapshot, _) => UserEntity.fromJson({...snapshot.data()!, "id": snapshot.id}), 
  //   toFirestore: (entity, _) => entity.toJsonFirebase
  // );
  // final CollectionReference<CinemaEntity?> cinemas = FirebaseFirestore.instance.collection(cinemasCollectionName).withConverter<CinemaEntity?>(
  //   fromFirestore: (snapshot, _) {
  //     if(!snapshot.exists) return null;
  //     return CinemaEntity.fromJson({...snapshot.data()!, "id": snapshot.id});
  //   },
  //   toFirestore: (entity, _) => entity!.toJsonFirebase
  // );
}