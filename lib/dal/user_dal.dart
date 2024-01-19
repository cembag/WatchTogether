import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecinema_watch_together/dal/utils/to_map.dart';
import 'package:ecinema_watch_together/entities/firestore/user_entity.dart';
import 'package:ecinema_watch_together/entities/firestore_entity_repository.dart';
import 'package:ecinema_watch_together/utils/firebase_db_model.dart';

class UserDal extends IFirestoreEntityRepository<UserEntity> {

  static UserDal get instance => UserDal();
  final _firestore = FirebaseFirestore.instance;

  CollectionReference get _cl => _firestore.collection(DBModel.users);

  @override
  Future<void> delete(String id) async => _cl.doc(id).delete();

  @override
  Future<List<UserEntity>> getAll() async => await _cl.get().then((value) => value.docs.map((e) => UserEntity.fromJsonFirebase(toMap(e))).toList());

  @override
  Future<UserEntity?> getOne(String id) async => await _cl.doc(id).get().then((snapshot) => snapshot.exists ?  UserEntity.fromJsonFirebase(toMap(snapshot)) : null);

  @override
  Future<void> insert(UserEntity t) async => await _cl.add(t);

  @override
  Future<void> insertById(String id, UserEntity t) async => _cl.doc(id).set(t.toJsonFirebase);

  @override
  Future<void> update(String id, Map<String, dynamic> t) async => await _cl.doc(id).set(t, SetOptions(merge: true));
  
  @override
  Future<int> get count async => await _cl.count().get().then((snapshot) => snapshot.count);

  Future<bool> hasAccount(String id) async => getOne(id).then((user) => user != null);

  Future<bool> hasUsernameTaken(String username) async => _cl.where("username", isEqualTo: username).get().then((snapshot) => snapshot.docs.isNotEmpty);
}