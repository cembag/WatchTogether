import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_storage/get_storage.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:country_picker/country_picker.dart';
import 'package:ecinema_watch_together/routes.dart';
import 'package:ecinema_watch_together/controlllers/auth_controller.dart';
import 'package:ecinema_watch_together/controlllers/main_controller.dart';
import 'package:ecinema_watch_together/firebase_options.dart';
import 'package:ecinema_watch_together/services/app_services.dart';
import 'package:ecinema_watch_together/utils/app/app_environment.dart';
import 'package:ecinema_watch_together/utils/app/app_theme.dart';
import 'package:ecinema_watch_together/utils/route_paths.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:ecinema_watch_together/services/remote_config_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();
  await dotenv.load(fileName: AppEnvironment.fileName);
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform).then((_) {
    Get.put(AuthController());
    Get.put(MainController());
  });
  await FirebaseAppCheck.instance.activate(androidProvider: AndroidProvider.debug, appleProvider: AppleProvider.debug);
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
    ),
  );
  await RemoteConfigService.instance.initialize();
  FlutterNativeSplash.remove();
  // final user = UserEntity(id: "", username: "deneme", phoneNumber: "44", hashedPassword: "", profilePhotos: null, profilePhotoAvatar: null, gender: "M", bio: "", avatar: "10", useAvatar: true, isOnline: true, notificationDetails: NotificationDetails(message: false, visitor: false, promotion: false, system: false), isVerified: false, isPremium: false, coins: 0, matchDetail: MatchDetail(match: "", isMatching: false, lastMatchedAt: null), lastLoggedAt: DateTime.now(), lastLoggedOutAt: null, birthdate: DateTime.now(), createdAt: DateTime.now());
  // final user2 = UserEntity(id: "", username: "deneme2", phoneNumber: "44", hashedPassword: "", profilePhotos: null, profilePhotoAvatar: null, gender: "M", bio: "", avatar: "10", useAvatar: true, isOnline: true, notificationDetails: NotificationDetails(message: false, visitor: false, promotion: false, system: false), isVerified: false, isPremium: false, coins: 0, matchDetail: MatchDetail(match: "", isMatching: false, lastMatchedAt: null), lastLoggedAt: DateTime.now(), lastLoggedOutAt: null, birthdate: DateTime.now(), createdAt: DateTime.now());
  // FirebaseFirestore.instance.collection('users').add(user.toJsonFirebase);
  // FirebaseFirestore.instance.collection('users').add(user2.toJsonFirebase);
  runApp(const ECinemaWatchTogether());
}

class ECinemaWatchTogether extends StatelessWidget {
  const ECinemaWatchTogether({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      theme: appTheme,
      debugShowCheckedModeBanner: false,
      initialRoute: RoutePaths.splash,
      routingCallback: (_) => AppServices.hideKeyboard(),
      onGenerateRoute: Routes.onGenerateRoute,
      // supportedLocales: AppConstants.supportedLocales, 
      localizationsDelegates: const [
        CountryLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      builder: (context, child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(textScaleFactor: 1),
          child: child!,
        );
      },
    );
  }
}