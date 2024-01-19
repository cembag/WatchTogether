import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecinema_watch_together/entities/firestore/private_message_entity.dart';
import 'package:ecinema_watch_together/entities/firestore_entity.dart';

class PrivateChatDetail extends IFirestoreEntity{
  final List<String> users;
  final List<String> writers;
  final PrivateMessage? lastMessage;
  PrivateChatDetail({required super.id, required this.users, required this.writers, required this.lastMessage, required super.createdAt, super.updatedAt});

  factory PrivateChatDetail.fromJson(dynamic json) => PrivateChatDetail(id: json['id'], users: <String>[...json['users']], lastMessage: json['last_message'] == null ? null : PrivateMessage.fromJson(json['last_message']), writers: json['writers'], createdAt: DateTime.parse(json['created_at']), updatedAt: json['updated_at'] != null ?  DateTime.parse(json['updated_at']) : null);
  factory PrivateChatDetail.fromJsonFirebase(dynamic json) => PrivateChatDetail(id: json['id'], users: <String>[...json['users']], lastMessage: json['last_message'] == null ? null : PrivateMessage.fromJsonFirebase(json['last_message']), writers: <String>[...json['writers']], createdAt: (json['created_at'] as Timestamp).toDate(), updatedAt: json['updated_at'] != null ?  (json['updated_at'] as Timestamp).toDate() : null);
  Map<String, dynamic> get toJson => {"id": id, "users": users, "last_message": lastMessage?.toJson, "writers": writers, "created_at": createdAt.toIso8601String(), "updated_at": updatedAt?.toIso8601String()};
  Map<String, dynamic> get toJsonFirebase => {"users": users, "last_message": lastMessage?.toJsonFirebase, "writers": writers, "created_at": createdAt, "updated_at": updatedAt};
  static List<PrivateChatDetail> listFromSnapshot(List<dynamic> list) => list.map((e) => PrivateChatDetail.fromJson(e)).toList();
  static PrivateChatDetail sample = PrivateChatDetail(id: "id", users: [], lastMessage: PrivateMessage.sample, writers: [], createdAt: DateTime.now());
}

// Map<String, UserDetail> userMapToUserDetail {

// }

// class SenderDetail {
//   final String id;
//   final String username;
//   final ImageDetail? photo;
//   final String avatar;
//   final bool useAvatar;
//   SenderDetail({required this.id, required this.username, required this.photo, required this.avatar, required this.useAvatar});

//   factory SenderDetail.fromJson(dynamic json) => SenderDetail(id: json['id'], username: json['username'], photo: json['photo'] == null ? null : ImageDetail.fromJson(json['photo']), avatar: json['avatar'], useAvatar: json['use_avatar']);
//   factory SenderDetail.fromJsonFirebase(dynamic json) => SenderDetail(id: json['id'], username: json['username'], photo: json['photo'] == null ? null :  ImageDetail.fromJson(json['photo']), avatar: json['avatar'], useAvatar: json['use_avatar']);
//   Map<String, dynamic> get toJson => {"id": id, "username": username, "photo": photo?.toJson, "avatar": avatar, "use_avatar": useAvatar};
//   Map<String, dynamic> get toJsonFirebase => {"username": username, "photo": photo?.toJson, "avatar": avatar, "use_avatar": useAvatar};
//   static SenderDetail sample = SenderDetail(id: "id", username: "username", photo: null, avatar: "avatar", useAvatar: true);
// }