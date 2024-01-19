import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecinema_watch_together/entities/firestore/user_entity.dart';
import 'package:ecinema_watch_together/entities/firestore_entity_repository.dart';
import 'package:ecinema_watch_together/utils/firebase_db_model.dart';

class SaloonDal extends IFirestoreEntityRepository<UserEntity> {

  static SaloonDal get instance => SaloonDal();
  final _firestore = FirebaseFirestore.instance;

  CollectionReference get _cl => _firestore.collection(DBModel.cinemas);

  @override
  Future<void> delete(String id) async => _cl.doc(id).delete();

  @override
  Future<List<UserEntity>> getAll() async => await _cl.get().then((value) => value.docs.map((e) => UserEntity.fromJson(e.data())).toList());

  @override
  Future<UserEntity?> getOne(String id) async => await _cl.doc(id).get().then((snapshot) => UserEntity.fromJson(snapshot.data()));

  @override
  Future<void> insert(UserEntity t) async => await _cl.add(t);

  @override
  Future<void> insertById(String id, UserEntity t) async => _cl.doc(id).set(t);

  @override
  Future<void> update(String id, Map<String, dynamic> t) async => await _cl.doc(id).update(t);
  
  @override
  Future<int> get count async => await _cl.count().get().then((snapshot) => snapshot.count);
}