import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecinema_watch_together/entities/app/multimedia_type.dart';

class MultimediaDetail {
  final String? url;
  final File? file;
  final ViewOnce? viewOnce;
  final MultimediaType type;
  MultimediaDetail({this.url, this.file, required this.type, this.viewOnce});

  factory MultimediaDetail.fromJson(dynamic json) => MultimediaDetail(url: json['url'], file: json['file'], viewOnce: json['view_once'] == null ? null : ViewOnce.fromJson(json['view_once']), type: multimediaFromString(json['type'])); 
  factory MultimediaDetail.fromJsonFirebase(dynamic json) => MultimediaDetail(url: json['url'], viewOnce: json['view_once'] == null ? null : ViewOnce.fromJsonFirebase(json['view_once']), type: multimediaFromString(json['type'])); 
  Map<String, dynamic> get toJson => {"url": url, "file": file, "view_once": viewOnce?.toJson, "type": multimediaToString(type)};
  Map<String, dynamic> get toJsonFirebase => {"url": url, "view_once": viewOnce?.toJsonFirebase, "type": multimediaToString(type)};
}

class ViewOnce {
  final bool viewed;
  final DateTime? viewedAt;
  ViewOnce({required this.viewed, this.viewedAt});
  factory ViewOnce.fromJson(dynamic json) => ViewOnce(viewed: json['viewed'], viewedAt: json['viewed_at'] == null ? null : DateTime.parse(json['viewed_at']));
  factory ViewOnce.fromJsonFirebase(dynamic json) => ViewOnce(viewed: json['viewed'], viewedAt: json['viewed_at'] == null ? null : (json['viewed_at'] as Timestamp).toDate());
  Map<String, dynamic> get toJson => {"viewed": viewed, "viewed_at": viewedAt?.toIso8601String()};
  Map<String, dynamic> get toJsonFirebase => {"viewed": viewed, "viewed_at": viewedAt};
}