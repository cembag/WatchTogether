import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecinema_watch_together/entities/firestore/cinema_category_entity.dart';
import 'package:ecinema_watch_together/entities/firestore_entity.dart';

class CinemaEntity extends IFirestoreEntity {
  final String title;
  final int time;
  final List<CinemaCategoryEntity> categories;
  final List<dynamic> coverPhotos;
  final DateTime publishedAt;
  final List<dynamic> availableCaptions;
  final String url;
  CinemaEntity({required super.id, required this.title, required this.time, required this.categories, required this.coverPhotos, required this.publishedAt, required this.availableCaptions, required this.url, required super.createdAt, super.updatedAt});

  // CinemaEntity.fromJso(dynamic json) : title = json['title'], time = json['time'], categories = json['ca'], coverPhotos = json['asd'], publishedAt = json['asd'], availableCaptions = json["asd"], url = json['url'], super(id: "", createdAt: DateTime.now(), updatedAt: DateTime.now());
  factory CinemaEntity.fromJson(dynamic json) => CinemaEntity(id: json['id'], title: json['title'], time: json['time'], categories: CinemaCategoryEntity.listFromSnapshot(json['categories']), coverPhotos: json['cover_photos'], publishedAt: (json['published_at'] as Timestamp).toDate(), availableCaptions: json['available_captions'], url: json['url'],  createdAt: (json['created_at'] as Timestamp).toDate(), updatedAt: (json['updated_at'] as Timestamp).toDate());
  Map<String, dynamic> get toJson => {"id": id, "title": title, "time": time, "categories": categories.map((e) => e.toJson), "cover_photos": coverPhotos, "published_at": publishedAt, "available_captions": availableCaptions, "url": url, "created_at": createdAt, "updated_at": updatedAt};
  Map<String, dynamic> get toJsonFirebase => {"title": title, "time": time, "categories": categories.map((e) => e.toJson), "cover_photos": coverPhotos, "published_at": publishedAt, "available_captions": availableCaptions, "url": url, "created_at": createdAt, "updated_at": updatedAt};
  static List<CinemaEntity> listFromSnapshot(List<dynamic> list) => list.map((e) => CinemaEntity.fromJson(e)).toList();
  static CinemaEntity sampleCinema = CinemaEntity(id: "NvSojt1PTV1cAQW9adVD", title: "Alvin ve sincaplar", time: 3782, categories: [CinemaCategoryEntity(id: "NvSojt1PTV1cAQW9adV2", name: "Fantastik", createdAt: DateTime.now(), updatedAt: DateTime.now()), CinemaCategoryEntity(id: "NvSojt1PTV1cAQW9adV2", name: "Macera", createdAt: DateTime.now(), updatedAt: DateTime.now()), CinemaCategoryEntity(id: "NvSojt1PTV1cAQW9adV2", name: "Aile", createdAt: DateTime.now(), updatedAt: DateTime.now())], coverPhotos: [], publishedAt: DateTime.now(), availableCaptions: ["Türkçe", "İngilizce"], url: "", createdAt: DateTime.now(), updatedAt: DateTime.now());
}