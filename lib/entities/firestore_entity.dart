import 'package:ecinema_watch_together/entities/base_entity.dart';

abstract class IFirestoreEntity implements IBaseEntity {
  final String id;
  final DateTime createdAt;
  DateTime? updatedAt;
  IFirestoreEntity({required this.id, required this.createdAt, required this.updatedAt});
}