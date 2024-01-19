import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecinema_watch_together/dal/utils/to_map.dart';
import 'package:ecinema_watch_together/entities/firestore/private_chat_detail_entity.dart';
import 'package:ecinema_watch_together/entities/firestore_entity_repository.dart';
import 'package:ecinema_watch_together/utils/firebase_db_model.dart';

class PrivateChatDal extends IFirestoreEntityRepository<PrivateChatDetail> {

  static PrivateChatDal get instance => PrivateChatDal();
  final _firestore = FirebaseFirestore.instance;

  CollectionReference get _cl => _firestore.collection(DBModel.users);

  @override
  Future<void> delete(String id) async => _cl.doc(id).delete();

  @override
  Future<List<PrivateChatDetail>> getAll() async => await _cl.get().then((value) => value.docs.map((e) => PrivateChatDetail.fromJsonFirebase(toMap(e))).toList());

  @override
  Future<PrivateChatDetail?> getOne(String id) async => await _cl.doc(id).get().then((snapshot) => snapshot.exists ?  PrivateChatDetail.fromJsonFirebase(toMap(snapshot)) : null);

  @override
  Future<void> insert(PrivateChatDetail t) async => await _cl.add(t);

  @override
  Future<void> insertById(String id, PrivateChatDetail t) async => _cl.doc(id).set(t.toJsonFirebase);

  @override
  Future<void> update(String id, Map<String, dynamic> t) async => await _cl.doc(id).update(t);
  
  @override
  Future<int> get count async => await _cl.count().get().then((snapshot) => snapshot.count);
}