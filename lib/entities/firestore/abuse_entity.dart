import 'package:ecinema_watch_together/entities/app/abuse_priority.dart';

class AbuseEntity {
  final String name;
  final int code;
  final int? mainAbuse;
  final String? description;
  final String? url;
  final AbusePriority? priority;
  final double? importanceLevel;
  final List<String>? notAlloweds;
  final List<AbuseEntity>? subAbuses;

  AbuseEntity({required this.name, required this.code, this.mainAbuse, this.description, this.url, this.priority, this.importanceLevel, this.notAlloweds, this.subAbuses});
  factory AbuseEntity.fromJson(dynamic json) => AbuseEntity(name: json['name'], code: json['code'], mainAbuse: json['main_abuse'], description: json['description'], url: json['url'], priority: abusePriorityFromString(json['priority']), importanceLevel: json['importance_level'], notAlloweds: json['not_alloweds'], subAbuses: json['sub_abuses'] == null ? null : (json['sub_abuses'] as List<Map<String,dynamic>>).map((e) => AbuseEntity.fromJson(e)).toList());
  factory AbuseEntity.fromJsonFirebase(dynamic json) => AbuseEntity(name: json['name'], code: json['code'], mainAbuse: json['main_abuse'], description: json['description'], url: json['url'], priority: abusePriorityFromString(json['priority']), importanceLevel: json['importance_level'], notAlloweds: json['not_alloweds'], subAbuses: json['sub_abuses'] == null ? null : (json['sub_abuses'] as List<Map<String,dynamic>>).map((e) => AbuseEntity.fromJson(e)).toList());
  Map<String, dynamic> get toJson => {"name": name, "code": code, "main_abuse": mainAbuse, "description": description, "url": url, "priority": priority == null ? null : abusePriorityToString(priority!), "importance_level": importanceLevel, "not_alloweds": notAlloweds, "sub_abuses": subAbuses};
  Map<String, dynamic> get toJsonFirebase => {"name": name, "code": code, "main_abuse": mainAbuse, "description": description, "url": url, "priority": priority == null ? null : abusePriorityToString(priority!), "importance_level": importanceLevel, "not_alloweds": notAlloweds, "sub_abuses": subAbuses};
  static List<AbuseEntity> fromList(List<dynamic> list) => list.map((e) => AbuseEntity.fromJson(e)).toList();
  static List<AbuseEntity> fromListFirebase(List<dynamic> list) => list.map((e) => AbuseEntity.fromJsonFirebase(e)).toList();
}

// class AbuseEntity extends IFirestoreEntity {
//   final Map<String, dynamic> name;
//   final int code;
//   final String? mainAbuse;
//   final Map<String, dynamic>? description;
//   final String? url;
//   final List<Map<String, dynamic>>? notAlloweds;
//   final List<AbuseEntity>? subAbuses;

//   AbuseEntity({required super.id, required this.name, required this.code, this.mainAbuse, this.description, this.url, this.notAlloweds, this.subAbuses, required super.createdAt, super.updatedAt});
//   factory AbuseEntity.fromJson(dynamic json) => AbuseEntity(id: json['id'], name: json['name'], code: json['code'], mainAbuse: json['main_abuse'], description: json['description'], url: json['url'], notAlloweds: json['not_alloweds'], subAbuses: json['sub_abuses'] == null ? null : (json['sub_abuses'] as List<Map<String,dynamic>>).map((e) => AbuseEntity.fromJson(e)).toList(), createdAt: DateTime.parse(json['created_at']), updatedAt: json['updated_at'] == null ? null : DateTime.parse(json['updated_at']));
//   factory AbuseEntity.fromJsonFirebase(dynamic json) => AbuseEntity(id: json['id'], name: json['name'], code: json['code'], mainAbuse: json['main_abuse'], description: json['description'], url: json['url'], notAlloweds: json['not_alloweds'], subAbuses: json['sub_abuses'] == null ? null : (json['sub_abuses'] as List<Map<String,dynamic>>).map((e) => AbuseEntity.fromJson(e)).toList(), createdAt: (json['created_at'] as Timestamp).toDate(), updatedAt: json['updated_at'] == null ? null : (json['updated_at'] as Timestamp).toDate());
//   Map<String, dynamic> get toJson => {"id": id, "name": name, "code": code, "main_abuse": mainAbuse, "description": description, "url": url, "not_alloweds": notAlloweds, "sub_abuses": subAbuses, "created_at": createdAt.toIso8601String(), "updated_at": updatedAt?.toIso8601String()};
//   Map<String, dynamic> get toJsonFirebase => {"id": id, "name": name, "code": code, "main_abuse": mainAbuse, "description": description, "url": url, "not_alloweds": notAlloweds, "sub_abuses": subAbuses, "created_at": createdAt, "updated_at": updatedAt};
//   static List<AbuseEntity> fromList(List<dynamic> list) => list.map((e) => AbuseEntity.fromJson(e)).toList();
//   static List<AbuseEntity> fromListFirebase(List<dynamic> list) => list.map((e) => AbuseEntity.fromJsonFirebase(e)).toList();
// }