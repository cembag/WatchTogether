import 'package:cloud_firestore/cloud_firestore.dart';

Map<String, dynamic> toMap(DocumentSnapshot<Object?> snap) => {...snap.data()! as Map<String, dynamic>, "id": snap.id};