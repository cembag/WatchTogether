import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:get/get.dart';

// class HomeScreenController extends GetxController {
//   static HomeScreenController get instance => HomeScreenController();

//   @override
//   void onInit() {
//     super.onInit();
//     // addToCinemas();
//     _setup();
//   }

//   var cinemas = <CinemaEntity>[].obs;

//   // Future<void> addToCinemas() async {
//   //   final cinemaDal = CinemaDal();
//   //   await cinemaDal.insert(CinemaEntity.sampleCinema);
//   //   print("Added to cinemas");
//   // }

//   Future<void> _setup() async {
//     try {
//       await _getAllCinemas();
//     } catch (err) {
//       print("ERROR: $err");
//     }
//   }

//   Future<void> _getAllCinemas() async {
//     print("CINEMAS FETCHING");
//     final cinemaDal = CinemaDal();
//     cinemas.value = await cinemaDal.getAll();
//     update();
//   }
// }

class HomeScreenController extends GetxController {

  late final AppLifecycleListener _listener;
  late AppLifecycleState? _state;
  final List<String> _states = <String>[];
  final girls2= [
    "https://images.pexels.com/photos/1366919/pexels-photo-1366919.jpeg?cs=srgb&dl=pexels-eberhard-grossgasteiger-1366919.jpg&fm=jpg",
    "https://www.fotografindir.org/wp-content/uploads/2022/06/guzel-kiz-fotograflari-6.jpg",
    "https://www.eniyisor.com/wp-content/uploads/sosyal-medya-kiz-fotograflari-3.jpg",
    "https://www.technopat.net/sosyal/eklenti/cdfd69e8-2bfd-4c7d-9c9f-aa1f984ff801-jpeg.1236018/",
    "https://p4.wallpaperbetter.com/wallpaper/877/339/626/beautiful-girls-girl-1920x1080-wallpaper-preview.jpg",
    "https://images.pexels.com/photos/10230343/pexels-photo-10230343.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500",
    "https://www.fotografindir.org/wp-content/uploads/2022/09/fake-kizi-fotograflari-3.jpg",
    "https://galeri8.uludagsozluk.com/403/geceye-guzel-bir-kiz-fotografi-birak_888283_m.jpg",
    "https://i.ytimg.com/vi/4VHPYSZAYjA/hq720_2.jpg?sqp=-oaymwEYCKoDENAFSFryq4qpAwoIARUAAIhC0AEB&rs=AOn4CLAg1z0MCZio9ThwLVvk0mpnq1OEGg",
    "https://cdn1.ntv.com.tr/gorsel/L7zbiMKWyEScJpV4Yei2Ag.jpg?width=1000&mode=crop&scale=both",
    "https://ai-previews.123rf.com/ai-variation/preview/wm/sunselle/sunselle1211/sunselle121100165_5.jpg",
    "https://i.pinimg.com/736x/05/74/86/05748605cecbcd0747f33c2cbb286d5a.jpg",
    "https://kronos36.news/wp-content/uploads/2021/04/zoe-roth-instagram3.jpeg",
    "https://www.eniyisor.com/wp-content/uploads/fake-kiz-fotografi.jpg",
    "https://galeri13.uludagsozluk.com/734/fake-kiz-fotografi-paylasan-kiz_1316435.jpg",
    "https://iasbh.tmgrup.com.tr/b31d16/0/0/0/0/0/0?u=https://isbh.tmgrup.com.tr/sb/album/2022/01/03/1641203836645.jpg&mw=600&l=1",
    "https://i.pinimg.com/736x/5a/1d/b9/5a1db9227dfac71c149cd4ef7959dce7.jpg",
    "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcT5BWINVj7vx-Oqi2genSDAToTucW9xdBCQqg&usqp=CAU",
    "https://galeri.netfotograf.com/images/medium/17B82491179FEEF3.JPG",
    "https://www.eniyisor.com/wp-content/uploads/2022/12/genc-kiz-fotograflari-576x1024.jpg",
    "https://www.eniyisor.com/wp-content/uploads/2022/08/Kiz-Fotograflari-2.jpg",
    "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTNRU1rcdda2LTlIe0s870z_E2hiOC1tIM4Qg&usqp=CAU"
  ];
  var girls = [
    "https://i.ytimg.com/vi/4VHPYSZAYjA/hq720_2.jpg?sqp=-oaymwEYCKoDENAFSFryq4qpAwoIARUAAIhC0AEB&rs=AOn4CLAg1z0MCZio9ThwLVvk0mpnq1OEGg",
    "https://www.eniyisor.com/wp-content/uploads/2022/12/kiz-fotografi-807x1024.jpg",
  ].obs;
  late Offset cardStartPosition;
  double cardPositionX = 0;
  double cardPositionY = 0;
  double cardPosition2X = 0;
  double cardPosition2Y = 0;
  var order = 0.obs;

  bool get isOrderEven => order.value%2 == 0;

  AppLifecycleState? get appLifeCycleState => _state;
  AppLifecycleListener get appLifeCycleListener => _listener;

  @override
  void onInit() {
    _state = SchedulerBinding.instance.lifecycleState;
    _listener = AppLifecycleListener(
      onShow: () => _handleTransition('show'),
      onResume: () => _handleTransition('resume'),
      onHide: () => _handleTransition('hide'),
      onInactive: () => _handleTransition('inactive'),
      onPause: () => _handleTransition('pause'),
      onDetach: () => _handleTransition('detach'),
      onRestart: () => _handleTransition('restart'),
      onExitRequested: _onExitRequested,
      onStateChange: _handleStateChange,
    );
    super.onInit();
  }

  Future<AppExitResponse> _onExitRequested() async {
    print("ON EXIT RESPONSE");
    return AppExitResponse.exit;
  }

  void _handleStateChange(AppLifecycleState state) {
    _state = state;
    update();
  }

  void _handleTransition(String name) {
    _states.add(name);
    // AppLifecycleService.instance.handleTransition(name);
    update();
  }
}