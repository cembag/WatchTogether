import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecinema_watch_together/entities/firestore_entity.dart';

class CinemaCategoryEntity extends IFirestoreEntity {
  final String name;
  CinemaCategoryEntity({required super.id, required this.name, required super.createdAt, required super.updatedAt});

  factory CinemaCategoryEntity.fromJson(dynamic json) => CinemaCategoryEntity(id: json['id'], name: json['name'], createdAt: (json['created_at'] as Timestamp).toDate(), updatedAt: (json['updated_at'] as Timestamp).toDate());
  Map<String, dynamic> get toJson => {"id": id, "name": name, "created_at": createdAt, "updated_at": updatedAt};
  Map<String, dynamic> get toJsonFirebase => {"name": name, "created_at": createdAt, "updated_at": updatedAt};
  static List<CinemaCategoryEntity> listFromSnapshot(List<dynamic> list) => list.map((e) => CinemaCategoryEntity.fromJson(e)).toList();
}