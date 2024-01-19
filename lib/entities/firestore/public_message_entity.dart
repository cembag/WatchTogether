import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecinema_watch_together/entities/firestore_entity.dart';

class PublicMessage extends IFirestoreEntity {
  final UserDetail sender;
  final String? text;
  final ImageDetail? image;
  final bool isSent;
  final List<ReadDetail> reads; 
  PublicMessage({required super.id, required this.sender, required this.text, required this.image, required this.isSent, required this.reads, required super.createdAt, super.updatedAt});

  factory PublicMessage.fromJson(dynamic json) => PublicMessage(id: json['id'], sender: UserDetail.fromJson(json['sender']), text: json['text'], image: json['image'] == null ? null : ImageDetail.fromJson(json['image']), isSent: json['is_sent'], reads: ReadDetail.fromList(json['reads']), createdAt: DateTime.parse(json['created_at']), updatedAt: json['updated_at'] == null ? null : DateTime.parse(json['updated_at']));
  factory PublicMessage.fromJsonFirebase(dynamic json) => PublicMessage(id: json['id'], sender: UserDetail.fromJsonFirebase(json['sender']), text: json['text'], image: json['image'] == null ? null : ImageDetail.fromJson(json['image']), isSent: json['is_sent'], reads: ReadDetail.fromListFirebase(json['reads']), createdAt: (json['created_at'] as Timestamp).toDate(), updatedAt: json['updated_at'] == null ? null : (json['updated_at'] as Timestamp).toDate());
  Map<String, dynamic> get toJson => {"id": id, "sender": sender.toJson, "text": text, "image": image?.toJson, "created_at": createdAt.toIso8601String(), "is_sent": isSent, "reads": reads.map((read) => read.toJson), "updated_at": updatedAt?.toIso8601String()};
  Map<String, dynamic> get toJsonFirebase => { "sender": sender.toJsonFirebase, "text": text, "image": image?.toJson,  "is_sent": isSent, "reads": reads.map((read) => read.toJsonFirebase), "created_at": createdAt, "updated_at": updatedAt};
  static PublicMessage sample = PublicMessage(id: "id", sender: UserDetail.sample, text: "text", image: null, isSent: true, reads: [], createdAt: DateTime.now());
}

class ReadDetail {
  final UserDetail user;
  final DateTime createdAt;
  ReadDetail({required this.user, required this.createdAt});

  factory ReadDetail.fromJson(dynamic json) => ReadDetail(user: UserDetail.fromJson(json['user']), createdAt: DateTime.parse(json['created_at']));
  factory ReadDetail.fromJsonFirebase(dynamic json) => ReadDetail(user: UserDetail.fromJsonFirebase(json['user']), createdAt: (json['created_at'] as Timestamp).toDate());
  Map<String, dynamic> get toJson => {"user": user.toJson, "created_at": createdAt.toIso8601String()};
  Map<String, dynamic> get toJsonFirebase => {"user": user.toJsonFirebase, "created_at": createdAt};
  static List<ReadDetail> fromList(List<dynamic> list) => list.map((e) => ReadDetail.fromJson(e)).toList();
  static List<ReadDetail> fromListFirebase(List<dynamic> list) => list.map((e) => ReadDetail.fromJsonFirebase(e)).toList();
  static ReadDetail sample = ReadDetail(user: UserDetail.sample, createdAt: DateTime.now());
}

class UserDetail {
  final String id;
  final String username;
  final ImageDetail? photo;
  final String avatar;
  final bool useAvatar;
  UserDetail({required this.id, required this.username, required this.photo, required this.avatar, required this.useAvatar});

  factory UserDetail.fromJson(dynamic json) => UserDetail(id: json['id'], username: json['username'], photo: json['photo'] == null ? null : ImageDetail.fromJson(json['photo']), avatar: json['avatar'], useAvatar: json['use_avatar']);
  factory UserDetail.fromJsonFirebase(dynamic json) => UserDetail(id: json['id'], username: json['username'], photo: json['photo'] == null ? null :  ImageDetail.fromJson(json['photo']), avatar: json['avatar'], useAvatar: json['use_avatar']);
  Map<String, dynamic> get toJson => {"id": id, "username": username, "photo": photo?.toJson, "avatar": avatar, "use_avatar": useAvatar};
  Map<String, dynamic> get toJsonFirebase => {"username": username, "photo": photo?.toJson, "avatar": avatar, "use_avatar": useAvatar};
  static Map<String, UserDetail> jsonToMap(Map<String, dynamic> json) {
    Map<String, UserDetail> map = {};
    json.forEach((key, value) => map[key] = UserDetail(id: value["id"], username: value["username"], photo: value['photo'] == null ? null : ImageDetail.fromJson(value['photo']), avatar: value['avatar'], useAvatar: value['use_avatar']));
    return map;
  }
  static Map<String, dynamic> mapToJson(Map<String, UserDetail> map) {
    Map<String, dynamic> json = {};
    map.forEach((key, value) => json[key] = {"id": value.id, "username": value.username, "photo": value.photo?.toJson, "avatar": value.avatar, "use_avatar": value.useAvatar});
    return json;
  }
  static UserDetail sample = UserDetail(id: "id", username: "username", photo: null, avatar: "avatar", useAvatar: true);

}

class ImageDetail {
  final String url;
  final double width;
  final double height;
  ImageDetail({required this.url, required this.width, required this.height});

  factory ImageDetail.fromJson(dynamic json) => ImageDetail(url: json['url'], width: json['width'], height: json['height']); 
  Map<String, dynamic> get toJson => {"url": url, "width": width, "height": height};
}