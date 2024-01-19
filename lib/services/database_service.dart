// import 'package:ecinema_watch_together/entities/firestore/user.dart';
// import 'package:ecinema_watch_together/entities/firestore_entity.dart';
// import 'package:ecinema_watch_together/entities/firestore_entity_repository.dart';
// import 'package:ecinema_watch_together/utils/firebase_db_model.dart';

// class DatabaseService<T extends IFirestoreEntity> implements IFirestoreEntityRepository<T> {
//   final reference = FirestoreDbModel.reference<T>(T);

//   void printRef() {
//     if(reference == null) print("REFERENCE NULL");
//     print(reference.runtimeType);
//   }

//   @override
//   Future<void> delete(String id) {
//     throw UnimplementedError();
//   }

//   @override
//   Future<List<T>> getAll() {
//     throw UnimplementedError();
//   }

//   @override
//   Future<T?> getOne(String id) {
//     throw UnimplementedError();
//   }

//   @override
//   Future<void> insert(T t) {
//     throw UnimplementedError();
//   }

//   @override
//   Future<void> insertById(T t, String id) {
//     throw UnimplementedError();
//   }

//   @override
//   Map<String, dynamic> toJson() {
//     throw UnimplementedError();
//   }

//   @override
//   Future<void> update(String id, IFirestoreEntity t) {
//     throw UnimplementedError();
//   }


// }