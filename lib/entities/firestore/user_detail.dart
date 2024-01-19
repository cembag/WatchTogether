import 'package:ecinema_watch_together/entities/firestore/public_message_entity.dart';

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
  static UserDetail sample = UserDetail(id: "id", username: "username", photo: null, avatar: "avatar", useAvatar: true);
}