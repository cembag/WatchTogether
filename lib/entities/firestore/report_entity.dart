// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:ecinema_watch_together/entities/app/content_type_entity.dart';
// import 'package:ecinema_watch_together/entities/firestore/abuse_entity.dart';
// import 'package:ecinema_watch_together/entities/firestore_entity.dart';

// class ReportEntity extends IFirestoreEntity {
//   final String from;
//   final String contentOwner;
//   final String content;
//   final ContentType contentType;
//   final AbuseEntity abuse;
//   ReportEntity({required super.id, required this.from, required this.contentOwner, required this.content, required this.contentType, required this.abuse, required super.createdAt, super.updatedAt});

//   factory ReportEntity.fromJson(dynamic json) => ReportEntity(id: json['id'], from: json['from'], contentOwner: json['content_owner'], content: json['content'], contentType: stringToContentType(json['content_type']), abuse: AbuseEntity.fromJson(json['abuse']), createdAt: DateTime.parse(json['created_at']), updatedAt: json['updated_at'] == null ? null : DateTime.parse(json['updated_at']));
//   factory ReportEntity.fromJsonFirebase(dynamic json) => ReportEntity(id: json['id'], from: json['from'], contentOwner: json['content_owner'], content: json['content'], contentType: stringToContentType(json['content_type']), abuse: AbuseEntity.fromJsonFirebase(json['abuse']), createdAt: (json['created_at'] as Timestamp).toDate(), updatedAt: json['updated_at'] == null ? null : (json['updated_at'] as Timestamp).toDate());
//   Map<String, dynamic> get toJson => {"id": id, "from": from, "content_owner": contentOwner, "content": content, "content_type": contentTypeToString(contentType), "abuse": abuse.toJson, "created_at": createdAt.toIso8601String(), "updated_at": updatedAt?.toIso8601String()};
//   Map<String, dynamic> get toJsonFirebase => {"from": from, "content_owner": contentOwner, "content": content, "content_type": contentTypeToString(contentType), "abuse": abuse.toJsonFirebase, "created_at": createdAt, "updated_at": updatedAt};
//   static List<ReportEntity> fromList(List<dynamic> list) => list.map((e) => ReportEntity.fromJson(e)).toList();
//   static List<ReportEntity> fromListFirebase(List<dynamic> list) => list.map((e) => ReportEntity.fromJsonFirebase(e)).toList();

//   static ReportEntity sample = ReportEntity(id: "id", from: "from", contentOwner: "contentOwner", content: "content", contentType: ContentType.text, abuse: AbuseEntity(id: "id", name: "Irkçılık", code: 204, createdAt: DateTime.now()), createdAt: DateTime.now());
// }