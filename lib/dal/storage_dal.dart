import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';

class StorageDal {

  // Future<void> uploadImage(Reference reference, File file) async {
  //   reference.putFile(file).asStream().listen((event) {
      
  //   });
  // }
  static Reference userProfilePhotosRef(String uid) => FirebaseStorage.instance.ref("users/$uid/profile");  
  static Reference userProfilePhotoRef(String uid, String photoName) => FirebaseStorage.instance.ref("users/$uid/profile/$photoName");  
  static Reference userChatPhotoRef(String uid, String chatId, String photoName) => FirebaseStorage.instance.ref("users/$uid/chats/$chatId/$photoName.jpeg");  
  static Future<String> uploadImage(Reference reference, File file) async => await (await reference.putFile(file, SettableMetadata(contentType: "image/jpeg"))).ref.getDownloadURL();
}