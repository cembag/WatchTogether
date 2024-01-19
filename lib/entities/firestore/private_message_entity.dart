import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecinema_watch_together/entities/firestore/multimedia_detail.dart';
import 'package:ecinema_watch_together/entities/firestore_entity.dart';

class PrivateMessage extends IFirestoreEntity {
  // final UserDetail sender;
  final String sender;
  final String? text;
  final MultimediaDetail? multimedia;
  final PrivateReadDetail readDetail;
  final bool? isSent;
  final String? reply;
  List<String> viewers;
  List<String>? favourites;
  // final Map<String, UserDetail> users;
  // final List<ReadDetail> reads; 
  PrivateMessage({required super.id, required this.sender, required this.text, this.multimedia, required this.readDetail, this.isSent, this.reply, required this.viewers, this.favourites, required super.createdAt, super.updatedAt});

  factory PrivateMessage.fromJson(dynamic json) => PrivateMessage(id: json['id'], sender: json['sender'], text: json['text'], multimedia: json['multimedia'] == null ? null : MultimediaDetail.fromJson(json['multimedia']), readDetail: PrivateReadDetail.fromJson(json['read_detail']), isSent: json['is_sent'] ?? true, reply: json['reply'], viewers: <String>[...json['viewers']], favourites: json['favourites'] == null ? null : <String>[...json['favourites']], createdAt: DateTime.parse(json['created_at']), updatedAt: json['updated_at'] == null ? null : DateTime.parse(json['updated_at']));
  factory PrivateMessage.fromJsonFirebase(dynamic json) => PrivateMessage(id: json['id'], sender: json['sender'], text: json['text'], multimedia: json['multimedia'] == null ? null : MultimediaDetail.fromJson(json['multimedia']), readDetail: PrivateReadDetail.fromJsonFirebase(json['read_detail']), reply: json['reply'], viewers: <String>[...json['viewers']], favourites: json['favourites'] == null ? null : <String>[...json['favourites']], createdAt: (json['created_at'] as Timestamp).toDate(), updatedAt: json['updated_at'] == null ? null : (json['updated_at'] as Timestamp).toDate());
  Map<String, dynamic> get toJson => {"id": id, "sender": sender, "text": text, "multimedia": multimedia?.toJson, "read_detail": readDetail.toJson, "is_sent": isSent, "reply": reply, "viewers": viewers, "favourites": favourites, "created_at": createdAt.toIso8601String(), "updated_at": updatedAt?.toIso8601String()};
  Map<String, dynamic> get toJsonFirebase => {"id": id, "sender": sender, "text": text, "multimedia": multimedia?.toJson, "read_detail": readDetail.toJsonFirebase, "reply": reply, "viewers": viewers, "favourites": favourites, "created_at": createdAt, "updated_at": updatedAt};
  static List<PrivateMessage> fromList(List<dynamic> list) => list.map((e) => PrivateMessage.fromJson(e)).toList();
  static List<PrivateMessage> fromListFirebase(List<dynamic> list) => list.map((e) => PrivateMessage.fromJsonFirebase(e)).toList();
  static PrivateMessage sample = PrivateMessage(id: "id", sender: "sampleSender", text: "text", multimedia: null, readDetail: PrivateReadDetail.sample, viewers: [], isSent: true, createdAt: DateTime.now());
}

class PrivateReadDetail {
  final bool isRead;
  final DateTime? createdAt;
  PrivateReadDetail({required this.isRead, required this.createdAt});

  factory PrivateReadDetail.fromJson(dynamic json) => PrivateReadDetail(isRead: json['is_read'], createdAt: json['created_at'] == null ? null : DateTime.parse(json['created_at']));
  factory PrivateReadDetail.fromJsonFirebase(dynamic json) => PrivateReadDetail(isRead: json['is_read'], createdAt: json['created_at'] == null ? null : (json['created_at'] as Timestamp).toDate());
  Map<String, dynamic> get toJson => {"is_read": isRead, "created_at": createdAt?.toIso8601String()};
  Map<String, dynamic> get toJsonFirebase => {"is_read": isRead, "created_at": createdAt};
  static List<PrivateReadDetail> fromList(List<dynamic> list) => list.map((e) => PrivateReadDetail.fromJson(e)).toList();
  static List<PrivateReadDetail> fromListFirebase(List<dynamic> list) => list.map((e) => PrivateReadDetail.fromJsonFirebase(e)).toList();
  static PrivateReadDetail sample = PrivateReadDetail(isRead: true, createdAt: DateTime.now());
}
