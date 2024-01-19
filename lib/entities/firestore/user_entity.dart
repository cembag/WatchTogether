import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecinema_watch_together/entities/firestore_entity.dart';

class UserEntity extends IFirestoreEntity {
  final String username;
  final String? email;
  final String phoneNumber;
  final String hashedPassword;
  final String gender;
  final String bio;
  final String avatar;
  final bool useAvatar;
  final ProfilePhoto? profilePhotoAvatar;
  final List<ProfilePhoto>? profilePhotos;
  final NotificationDetails notificationDetails;
  final bool isOnline;
  final bool isVerified;
  final bool isPremium;
  final int coins;
  final GeoPoint? geoPoint;
  final MatchDetail matchDetail;
  final DateTime lastLoggedAt;
  final DateTime? lastLoggedOutAt;
  final DateTime birthdate;
  UserEntity({required super.id, required this.username, this.email, required this.phoneNumber, required this.hashedPassword, required this.profilePhotos, required this.profilePhotoAvatar, required this.gender, required this.bio, required this.avatar, required this.useAvatar, required this.isOnline, required this.notificationDetails, required this.isVerified, required this.isPremium, required this.coins, this.geoPoint, required this.matchDetail, required this.lastLoggedAt, required this.lastLoggedOutAt, required this.birthdate, required super.createdAt, super.updatedAt});

  factory UserEntity.fromJson(dynamic json) => UserEntity(id: json['id'], username: json['username'], email: json['email'], phoneNumber: json['phone_number'], hashedPassword: json['hashed_password'], gender: json['gender'], bio: json['bio'], avatar: json['avatar'], useAvatar: json['use_avatar'], profilePhotoAvatar: json['profile_photo_avatar'] == null ? null : ProfilePhoto.fromJson(json['profile_photo_avatar']), profilePhotos: json['profile_photos'] == null ? null : ProfilePhoto.fromList(json['profile_photos']), notificationDetails: NotificationDetails.fromJson(json['notification_details']), isOnline: json['is_online'], isVerified: json['is_verified'], isPremium: json['is_premium'], coins: json['coins'], geoPoint: json['geo_point'] == null ? null : GeoPoint.fromJson(json['geo_point']), matchDetail: MatchDetail.fromJson(json['match_detail']), lastLoggedAt: DateTime.parse(json['last_logged_at']), lastLoggedOutAt: DateTime.parse(json['last_logged_out_at']), birthdate: DateTime.parse(json['birthdate']), createdAt: DateTime.parse(json['created_at']), updatedAt: json['updated_at'] == null ? null : DateTime.parse(json['updated_at']));
  factory UserEntity.fromJsonFirebase(dynamic json) => UserEntity(id: json['id'], username: json['username'], email: json['email'], phoneNumber: json['phone_number'], hashedPassword: json['hashed_password'], gender: json['gender'], bio: json['bio'], avatar: json['avatar'], useAvatar: json['use_avatar'], profilePhotoAvatar: json['profile_photo_avatar'] == null ? null : ProfilePhoto.fromJson(json['profile_photo_avatar']), profilePhotos: json['profile_photos'] == null ? null : ProfilePhoto.fromList(json['profile_photos']), notificationDetails: NotificationDetails.fromJson(json['notification_details']), isOnline: json['is_online'], isVerified: json['is_verified'], isPremium: json['is_premium'], coins: json['coins'], geoPoint: json['geo_point'] == null ? null : GeoPoint.fromJson(json['geo_point']), matchDetail: MatchDetail.fromJson(json['match_detail']), lastLoggedAt: (json['last_logged_at'] as Timestamp).toDate(), lastLoggedOutAt: json['last_logged_out_at'] == null ? null : (json['last_logged_out_at'] as Timestamp).toDate(), birthdate: (json['birthdate'] as Timestamp).toDate(), createdAt: (json['created_at'] as Timestamp).toDate(), updatedAt: json['updated_at'] == null ? null : (json['updated_at'] as Timestamp).toDate());
  Map<String, dynamic> get toJson => {"id": id, "username": username, "email": email, "phone_number": phoneNumber, "hashed_password": hashedPassword, "gender": gender, "bio": bio, "avatar": avatar, "use_avatar": useAvatar, "profile_photo_avatar": profilePhotoAvatar, "profile_photos": profilePhotos, 'notification_details': notificationDetails.toJson, 'is_online': isOnline, 'is_verified': isVerified, 'is_premium': isPremium, 'coins': coins, 'geo_point': geoPoint, 'match_detail': {"match": matchDetail.match, "is_matching": matchDetail.isMatching, "last_matched_at": matchDetail.lastMatchedAt?.toIso8601String()}, 'last_logged_at': lastLoggedAt.toIso8601String(), 'last_logged_out_at': lastLoggedOutAt?.toIso8601String(), "birthdate": birthdate.toIso8601String(), "created_at": createdAt.toIso8601String(), 'updated_at': updatedAt?.toIso8601String()};
  Map<String, dynamic> get toJsonFirebase => {"username": username, "email": email, "phone_number": phoneNumber, "hashed_password": hashedPassword, "gender": gender, "bio": bio, "avatar": avatar, "use_avatar": useAvatar, "profile_photo_avatar": profilePhotoAvatar, "profile_photos": profilePhotos, 'notification_details': notificationDetails.toJson, 'is_online': isOnline, 'is_verified': isVerified, 'is_premium': isPremium, 'coins': coins, 'geo_point': geoPoint, 'match_detail': {"match": matchDetail.match, "is_matching": matchDetail.isMatching, "last_matched_at": matchDetail.lastMatchedAt}, 'last_logged_at': lastLoggedAt, 'last_logged_out_at': lastLoggedOutAt, "birthdate": birthdate, "created_at": createdAt, "updated_at": updatedAt};
  static List<UserEntity> listFromSnapshot(List<dynamic> list) => list.map((e) => UserEntity.fromJson(e)).toList();

  static UserEntity sampleUser = UserEntity(id: "sample", username: "Executioner", phoneNumber: "905378689090", hashedPassword: "hashedPassword", profilePhotoAvatar: null, profilePhotos: null, gender: "M", bio: "Bu da benim işte hehhe", avatar: "8", useAvatar: true, notificationDetails: NotificationDetails(message: true, visitor: false, promotion: true, system: true), isOnline: true, isVerified: false, isPremium: false, coins: 0, geoPoint: null, matchDetail: MatchDetail(match: "", isMatching: false), lastLoggedAt: DateTime.now(), lastLoggedOutAt: null, birthdate: DateTime.now(), createdAt: DateTime.now(), updatedAt: null);
}

class NotificationDetails {
  final bool message;
  final bool visitor;
  final bool promotion;
  final bool system;
  NotificationDetails({required this.message, required this.visitor, required this.promotion, required this.system});
  factory NotificationDetails.fromJson(dynamic json) => NotificationDetails(message: json['message'], visitor: json['visitor'], promotion: json['promotion'], system: json['system']);
  Map<String, dynamic> get toJson => {"message": message, "visitor": visitor, "promotion": promotion, "system": system};
}

class ProfilePhoto {
  final String normal;
  final String blurred;
  final String? lowQuality;
  // final double width;
  // final double height;
  // final DateTime createdAt;
  // final DateTime? updatedAt;
  // ProfilePhoto({required this.normal, required this.blurred, required this.width, required this.height, required this.createdAt, this.updatedAt});
  ProfilePhoto({required this.normal, required this.blurred, required this.lowQuality});
  factory ProfilePhoto.fromJson(dynamic json) => ProfilePhoto(normal: json['normal'], blurred: json['blurred'], lowQuality: json['low_quality']);
  factory ProfilePhoto.fromJsonFirebase(dynamic json) => ProfilePhoto(normal: json['normal'], blurred: json['blurred'], lowQuality: json['low_quality']);
  Map<String, dynamic> get toJson => {"normal": normal, "blurred": blurred, "low_quality": lowQuality};
  Map<String, dynamic> get toJsonFirebase => {"normal": normal, "blurred": blurred, "low_quality": lowQuality};
  static List<ProfilePhoto> fromList(List<dynamic> list) => list.map((e) => ProfilePhoto.fromJson(e)).toList();
}

class MatchDetail {
  final String match;
  final bool isMatching;
  final DateTime? lastMatchedAt;
  MatchDetail({required this.match, required this.isMatching, this.lastMatchedAt});
  factory MatchDetail.fromJson(dynamic json) => MatchDetail(match: json['match'], isMatching: json['is_matching'], lastMatchedAt: json['last_matched_at'] == null ? null : DateTime.parse(json['last_matched_at']));
  factory MatchDetail.fromJsonFirebase(dynamic json) => MatchDetail(match: json['match'], isMatching: json['is_matching'], lastMatchedAt: json['last_matched_at'] == null ? null : (json['last_matched_at'] as Timestamp).toDate());
  Map<String, dynamic> get toJson => {"match": match, "is_matching": isMatching, "last_matched_at": lastMatchedAt};
  Map<String, dynamic> get toJsonFirebase => {"match": match, "is_matching": isMatching, "last_matched_at": lastMatchedAt};
}

class GeoPoint {
  double latitude;
  double longitude;
  double accuracy;
  GeoPoint({required this.latitude, required this.longitude, required this.accuracy});
  factory GeoPoint.fromJson(dynamic json) => GeoPoint(latitude: json['latitude'], longitude: json['longitude'], accuracy: json['accuracy']);
  Map<String, dynamic> get toJson => {"latitude": latitude, "longitude": longitude, "accuracy": accuracy}; 
}