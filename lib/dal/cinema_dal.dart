import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecinema_watch_together/dal/utils/to_map.dart';
import 'package:ecinema_watch_together/entities/firestore/cinema_entity.dart';
import 'package:ecinema_watch_together/entities/firestore_entity_repository.dart';
import 'package:ecinema_watch_together/utils/firebase_db_model.dart';

class CinemaDal extends IFirestoreEntityRepository<CinemaEntity> {
  static CinemaDal get instance => CinemaDal();
  final _firestore = FirebaseFirestore.instance;

  CollectionReference get _cl => _firestore.collection(DBModel.cinemas);

  @override
  Future<void> delete(String id) async => _cl.doc(id).delete();

  @override
  Future<List<CinemaEntity>> getAll() async => await _cl.get().then((value) => value.docs.map((e) => CinemaEntity.fromJson(toMap(e))).toList());

  @override
  Future<CinemaEntity?> getOne(String id) async => await _cl.doc(id).get().then((snapshot) => snapshot.exists ? CinemaEntity.fromJson(toMap(snapshot)) : null);

  @override
  Future<void> insert(CinemaEntity t) async => await _cl.add(t);

  @override
  Future<void> insertById(String id, CinemaEntity t) async => _cl.doc(id).set(t);

  @override
  Future<void> update(String id, Map<String, dynamic> t) async => await _cl.doc(id).update(t);
  
  @override
  Future<int> get count async => await _cl.count().get().then((snapshot) => snapshot.count);
}
