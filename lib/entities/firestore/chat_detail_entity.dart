// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:ecinema_watch_together/entities/firestore_entity.dart';

// class ChatDetail extends IFirestoreEntity{
//   final String from;
//   final String to;
//   final String? text;
//   final Map<String,dynamic>? image;
//   final String username;
//   final String? userImageUrl;
//   final String userAvatar;
//   // final bool userUseAvatar;
//   final DateTime? lastSentAt;
//   ChatDetail({required super.id, required this.from, required this.to, required this.username, required this.userImageUrl, required this.userAvatar, this.text, this.image, required super.createdAt, super.updatedAt, this.lastSentAt});

//   factory ChatDetail.fromJson(dynamic json) => ChatDetail(id: json['id'], from: json['from'], to: json['to'], text: json['text'], image: json['image'],  username: json['username'], userImageUrl: json['user_image'], userAvatar: json['user_avatar'], createdAt: DateTime.parse(json['created_at']), updatedAt: json['updated_at'] != null ?  DateTime.parse(json['updated_at']) : null, lastSentAt: json['last_sent_at'] != null ? DateTime.parse(json['last_sent_at']) : null);
//   factory ChatDetail.fromJsonFirebase(dynamic json) => ChatDetail(id: json['id'], from: json['from'], to: json['to'], text: json['text'], image: json['image'],  username: json['username'], userImageUrl: json['user_image'], userAvatar: json['user_avatar'], createdAt: (json['created_at'] as Timestamp).toDate(), updatedAt: json['updated_at'] != null ?  (json['updated_at'] as Timestamp).toDate() : null, lastSentAt: json['last_sent_at'] != null ? (json['last_sent_at'] as Timestamp).toDate() : null);
//   Map<String, dynamic> get toJson => {"id": id, "from": from, "to": to, "text": text, "image": image, "username": username, "user_image": userImageUrl, "avatar": userAvatar, "created_at": createdAt.toIso8601String(), "updated_at": updatedAt == null ? null : updatedAt!.toIso8601String(), 'last_sent_at': lastSentAt == null ? null : lastSentAt!.toIso8601String()};
//   Map<String, dynamic> get toJsonFirebase => {"id": id, "from": from, "to": to, "text": text, "image": image, "username": username, "user_image": userImageUrl, "avatar": userAvatar, "created_at": createdAt, "updated_at": updatedAt, 'last_sent_at': lastSentAt};
//   static List<ChatDetail> listFromSnapshot(List<dynamic> list) => list.map((e) => ChatDetail.fromJson(e)).toList();
// }