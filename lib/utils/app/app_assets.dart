class AppAssets {
  static String get assetsPath => "assets/images/";
  static String get imageSignature => "ic_";

  static String _path(String imageName, {String imageExtension = ImageExtension.jpg}) => assetsPath + imageSignature + imageName + imageExtension;

  static final logoText = _path('ecinema-logo-text', imageExtension: ImageExtension.png);
  static final animationLogo = _path("ecinema-animation-logo", imageExtension: ImageExtension.png);
  static final iconFemale = _path("icon-female", imageExtension: ImageExtension.png);
  static final iconMale = _path("icon-male", imageExtension: ImageExtension.png);
  static final iconQuestion = _path("icon-question", imageExtension: ImageExtension.png);
  static final iconUser = _path("icon-user", imageExtension: ImageExtension.png);
  static final iconWorld = _path("icon-world", imageExtension: ImageExtension.png);
  static final iconFriends = _path("icon-friends", imageExtension: ImageExtension.png);
  static final iconChatFriend = _path("icon-chat-friend", imageExtension: ImageExtension.png);
  static final iconChatFriend2 = _path("icon-chat-friend", imageExtension: ImageExtension.png);
  static final iconChatWorld = _path("icon-chat-world", imageExtension: ImageExtension.png);
  static final iconChatWorld2 = _path("icon-chat-world2", imageExtension: ImageExtension.png);
  static final iconExclamation = _path("icon-exclamation", imageExtension: ImageExtension.png);
  static final iconExclamation2 = _path("icon-exclamation2", imageExtension: ImageExtension.png);
  static final iconExclamation3 = _path("icon-exclamation3", imageExtension: ImageExtension.png);
  static final onboardWallpaperOne = _path("onboard-wallpaper-one");
  static final onboardWallpaperTwo = _path("onboard-wallpaper-two");
  static final onboardWallpaperThree = _path("onboard-wallpaper-three");
  static final onboardWallpaperFour = _path("onboard-wallpaper-four");
  static final onboardWallpaperFive = _path("onboard-wallpaper-five");
}

class ImageExtension {
  static const String jpeg = '.jpeg';
  static const String jpg = '.jpg';
  static const String png = '.png';
  static const String gif = '.gif';
  static const String bmp = '.bmp';
  static const String tiff = '.tiff';
  static const String webp = '.webp';
  static const String raw = '.raw';
  static const String svg = '.svg';
  static const String psd = '.psd';
  static const String ico = '.ico';
}