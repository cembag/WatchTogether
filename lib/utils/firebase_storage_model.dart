import 'package:ecinema_watch_together/utils/app/app_environment.dart';
import 'package:firebase_storage/firebase_storage.dart';

class FirebaseStorageModel {
  final storageUrl = AppEnvironment.storageUrl;

  Reference get cinemasRef => FirebaseStorage.instance.ref('/cinemas');
  Reference get usersRef => FirebaseStorage.instance.ref('/users');

  Reference cinemaStorageRef(String cinemaId) => cinemasRef.child('/$cinemaId');
  Reference userStorageRef(String userId) => cinemasRef.child('/$userId');

  Reference cinemaCoverPhotosRef(String cinemaId) => cinemaStorageRef(cinemaId).child('/cover');
  Reference userProfilPhotosRef(String userId) => userStorageRef(userId).child('/profil');
}