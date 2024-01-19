import 'package:ecinema_watch_together/entities/firestore/private_message_entity.dart';
import 'package:ecinema_watch_together/entities/firestore/user_entity.dart';
import 'package:ecinema_watch_together/utils/route_paths.dart';
import 'package:ecinema_watch_together/views/auth/login/login_screen.dart';
import 'package:ecinema_watch_together/views/auth/register/register_completion/register_completion_screen.dart';
import 'package:ecinema_watch_together/views/auth/register/register_phone_number/register_phone_number_screen.dart';
import 'package:ecinema_watch_together/views/auth/register/register_verify_phone_number/resigter_verify_phone_number.dart';
import 'package:ecinema_watch_together/views/chat/global/global_chat_screen.dart';
import 'package:ecinema_watch_together/views/chat/private/chat/private_chat_screen.dart';
import 'package:ecinema_watch_together/views/chat/private/chats/private_chats_screen.dart';
import 'package:ecinema_watch_together/views/home/home_screen.dart';
import 'package:ecinema_watch_together/views/media_gallery/album/album_screen.dart';
import 'package:ecinema_watch_together/views/media_gallery/media_gallery_screen.dart';
import 'package:ecinema_watch_together/views/media_gallery/media_viewer/media_viewer_screen.dart';
import 'package:ecinema_watch_together/views/not_found/not_found_screen.dart';
import 'package:ecinema_watch_together/views/onboard/onboard_screen.dart';
import 'package:ecinema_watch_together/views/page_navigator_screen.dart';
import 'package:ecinema_watch_together/views/profile_photo/profile_photo_screen.dart';
import 'package:ecinema_watch_together/views/settings/settings_screen_screen.dart';
import 'package:ecinema_watch_together/views/splash_screen.dart';
import 'package:ecinema_watch_together/views/try/try_screen.dart';
import 'package:flutter/material.dart';
import 'package:photo_gallery/photo_gallery.dart';

class Routes {

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    if(settings.name == null) return _buildRoute(const NotFoundScreen());
    final hasParam = settings.name!.contains("?");
    final parameters = hasParam ? _getQueryParams(settings.name!.substring(settings.name!.indexOf("?") + 1, settings.name!.length)) : null;
    final routeName = hasParam ? settings.name!.substring(0, settings.name!.indexOf("?")) : settings.name;
    print("PARAMETERS: $parameters");
    switch(routeName) {
      case RoutePaths.splash:
        return _buildRoute(const SplashScreen());
      case RoutePaths.onboard:
        // return _buildRoute(const OnboardScreen());
        return _buildRoute(const OnboardScreen(), transition: PageTransition.bottomToTop);
      case RoutePaths.login:
        return _buildRoute(const LoginScreen(), transition: PageTransition.bottomToTop);
      case RoutePaths.registerPhoneNumber:
        return _buildRoute(const RegisterPhoneNumberScreen(), transition: PageTransition.bottomToTop);
      case RoutePaths.registerVerify:
        final args = settings.arguments as Map;
        final phoneNumber = args['phone_number'] as String;
        final remaining = args['remaining'] as int;
        return _buildRoute(RegisterVerifyPhoneNumberScreen(phoneNumber: phoneNumber, remaining: remaining,), transition: PageTransition.rightToLeft);
      case RoutePaths.registerCompletion:
        return _buildRoute(const RegisterCompletionScreen(), transition: PageTransition.bottomToTop);
      case RoutePaths.home:
        return _buildRoute(const PageNavigatorScreen(index: 0,));
      case RoutePaths.settings:
        return _buildRoute(const SettingsScreen());
      case RoutePaths.cinemaRoom:
        return _buildRoute(const HomeScreen());
      case RoutePaths.cinemaSaloons:
        return _buildRoute(const HomeScreen());
      case RoutePaths.cinemas:
        return _buildRoute(const HomeScreen());
      case RoutePaths.privateChatScreen:
        final args = settings.arguments as Map;
        final friendId = args['friend_id'] as String;
        final pendingMessages = args['pending_messages'] as List<PrivateMessage>?;
        return _buildRoute(PrivateChatScreen(friendId: friendId, pendingMessages: pendingMessages,), transition: PageTransition.bottomToTop);
      case RoutePaths.privateChatsScreen:
        return _buildRoute(const PrivateChatsScreen());
      case RoutePaths.globalChatScreen:
        return _buildRoute(const GlobalChatScreen());
      case RoutePaths.profilePhoto:
        final args = settings.arguments as Map;
        final user = args['user'] as UserEntity;
        return _buildRoute(ProfilePhotoScreen(user: user));
      case RoutePaths.mediaGallery:
        final args = settings.arguments as Map;
        final receivers = args['receivers'] == null ? null : args['receivers'] as List<String>;
        return _buildRoute(MediaGalleryScreen(receivers: receivers,), transition: PageTransition.bottomToTop);
      case RoutePaths.albumScreen:
        final args = settings.arguments as Map;
        final album = args['album'] as Album;
        final receivers = args['receivers'] == null ? null : args['receivers'] as List<String>;
        return _buildRoute(AlbumScreen(album: album, receivers: receivers,), transition: PageTransition.bottomToTop);
      case RoutePaths.mediaViewer:
        final args = settings.arguments as Map;
        final mediums = args['mediums'] as List<Medium>;
        final receivers = args['receivers'] == null ? null : args['receivers'] as List<String>;
        return _buildRoute(MediaViewerScreen(mediums: mediums, receivers: receivers,));
      case RoutePaths.tryy:
        return _buildRoute(const TryScreen());
      default:
        return _buildRoute(const NotFoundScreen());
    }
  }

    static _buildRoute(Widget screen, {PageTransition transition = PageTransition.none, Curve curve = Curves.ease}) {
    switch(transition) {
      case PageTransition.scale:
        return _scaleRouteBuilder(screen: screen, curve: curve);
      case PageTransition.fade:
        return _fadeRouteBuilder(screen: screen, curve: curve);
      case PageTransition.bottomToTop:
        return _slideRouteBuilder(screen: screen, begin: const Offset(0.0, 1.0), end: Offset.zero, curve: curve);
      case PageTransition.topToBottom:
        return _slideRouteBuilder(screen: screen, begin: const Offset(0.0, -1.0), end: Offset.zero, curve: curve);
      case PageTransition.leftToRight:
        return _slideRouteBuilder(screen: screen, begin: const Offset(-1.0, 0.0), end: Offset.zero, curve: curve);
      case PageTransition.rightToLeft:
        return _slideRouteBuilder(screen: screen, begin: const Offset(1.0, 0.0), end: Offset.zero, curve: curve);
      case PageTransition.none:
        return MaterialPageRoute(builder: (context) => screen);
      default:
        return MaterialPageRoute(builder: (context) => screen);
    }
  }

  static _fadeRouteBuilder({required Widget screen, required Curve curve}) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => screen,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
         var tween = Tween(begin: 0.0, end: 1.0).chain(CurveTween(curve: curve));
        return FadeTransition(
          opacity: animation.drive(tween),
          child: child,
        );
      }
    );
  }

  static _slideRouteBuilder({required Widget screen, required Offset begin, required Offset end, required Curve curve}) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => screen,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
    );
  }

  static _scaleRouteBuilder({required Widget screen, required Curve curve}) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => screen,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        var tween = Tween(begin: 0.0, end: 1.0).chain(CurveTween(curve: curve));
        return ScaleTransition(
          scale: animation.drive(tween),
          child: child,
        );
      },
    );
  }

  static Map<String, dynamic> _getQueryParams(String paramString) {
    Map<String, dynamic> queryParams = {};
    final parameters = paramString.split('&');
    for(var paramPairs in parameters) {
      final paramPair = paramPairs.split('=');
      final key = paramPair[0];
      final value = paramPair[1];
      if (value == "true") {
        queryParams[key] = true;
      } else if (value == "false") {
        queryParams[key] = false;
      } else {
        queryParams[key] = value;
      }
    }
    return queryParams;
  }
}

enum PageTransition {
  bottomToTop,
  rightToLeft,
  leftToRight,
  topToBottom,
  fade,
  scale,
  none,
}