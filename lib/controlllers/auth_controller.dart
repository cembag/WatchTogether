import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:get/get.dart';
import 'package:ecinema_watch_together/entities/firestore/user_entity.dart';
import 'package:ecinema_watch_together/services/route_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_storage/get_storage.dart';

class AuthController extends GetxController {

  @override
  void onReady() {
    firebaseUserSubscription = _auth.authStateChanges().listen(_onAuthStateChanged);
    super.onReady();
  }

  @override
  void dispose() {
    firebaseUserSubscription.cancel();
    if(appUserSubscription != null) {
      appUserSubscription!.cancel();
    }
    super.dispose();
  }
  
  StreamSubscription<DocumentSnapshot<Map<String, dynamic>>>? appUserSubscription;
  late final StreamSubscription<User?> firebaseUserSubscription;
  DateTime get _now => DateTime.now();
  static final _auth = FirebaseAuth.instance;
  static final _firestore = FirebaseFirestore.instance;

  final _storage = GetStorage();

  var firebaseUser = Rx<User?>(null);
  var appUser = Rx<UserEntity?>(null);
  var verificationId = "".obs;

  // void updateAppUser(Map<String, dynamic> json) {
  //   if(appUser.value == null) return;
  //   final map = {...appUser.value!.toJson, ...json};
  //   appUser.value = UserEntity.fromJson(map);
  // }

  // void setAppUser(UserEntity user) {
  //   appUser.value = user;
  // }

  // Future<void> _onUserStateChanged(bool fetched) async {
  //   print("ON_USER_STATE_CHANGED: $appUser");
  //   print("APP_USER_FETCHED: ${appUserFetched.value}");
  //   if(firebaseUser.value == null) return;
  //   if(!fetched) return;
  //   final hasRegistered = appUser.value != null;
  //   print("HAS_REGISTERED: $hasRegistered");
  //   if(hasRegistered) {
  //     RouteService.toHome();
  //   } else {
  //     RouteService.offAllRegisterCompletion();
  //   }
  //   updateStorage();
  // }

  Future<void> _onAuthStateChanged(User? fbUser) async {
    print("ON_AUTH_STATE_CHANGED");
    firebaseUser.value = fbUser;
    final splash = await _storage.read('splash');
    if(splash) {
      await Future.delayed(const Duration(seconds: 2));
      await _storage.write('splash', false);
      await _storage.save();
    }
    try {
      if(fbUser != null) {
        print("FIREBASE_USER_NOT_NULL");
        /// SUBSCRIBE TO APP USER
        _subscribeToAppUser(fbUser.uid);
      } else {
        _unSubscribeFromAppUser();
        final isFirst = await _storage.read("is_first");
        if(isFirst == null) {
          await _storage.write("is_first", true);
          return RouteService.offAllOnboard();
        }
        final isLoggedBefore = await _storage.read("is_logged_before");
        RouteService.offAllRegisterPhoneNumber();
        // if(isLoggedBefore == null) return RouteService.offAllRegisterPhoneNumber();
        // print("CP5");
        // RouteService.offAllRegisterPhoneNumber();
      }
    } catch (err) {
      print(err);
    }
  } 

  Future<void> _onAppUserSnapshot(DocumentSnapshot<Map<String, dynamic>> snapshot) async {
    if(snapshot.exists) {
      if(appUser.value == null) {
        appUser.value = UserEntity.fromJsonFirebase({...snapshot.data()!, 'id': snapshot.id});
        RouteService.toHome();
        // RouteService.offAllRegisterCompletion();
        await _goOnline();
        return;
      }
      appUser.value = UserEntity.fromJsonFirebase({...snapshot.data()!, 'id': snapshot.id});
    } else {
      RouteService.offAllRegisterCompletion();
      appUser.value = null;
    }
  }

  _subscribeToAppUser(uid) => appUserSubscription = _firestore.collection('users').doc(uid).snapshots().listen(_onAppUserSnapshot);
  _unSubscribeFromAppUser() {
    if(appUserSubscription != null) {
     appUserSubscription!.cancel();
    }
    appUser.value = null;
  }



  Future<void> _goOnline() async {
    final userId = firebaseUser.value!.uid;
    final database = FirebaseDatabase.instance;
    final userRef = FirebaseFirestore.instance.collection('users').doc(userId);
    await userRef.update({"is_online": true, "last_logged_at": _now});
    database.setPersistenceEnabled(true);
    database.ref('.info/connected').onValue.listen((_) {
      database.ref('/status/$userId')
      .onDisconnect()
      .set({'is_online': false, 'last_active': _now.millisecondsSinceEpoch})
      .then((_) {
        userRef.update({'is_online': true, 'last_logged_at': _now});
        database.ref('/status/$userId').set({'is_online': true, 'last_active': _now.millisecondsSinceEpoch});
      });
    });
  }

  // Future<void> updateStorage() async {
  //   await _storage.write('user', appUser.value == null ? null : jsonEncode(appUser.value!.toJson));
  //   await _storage.save();
  // }
}