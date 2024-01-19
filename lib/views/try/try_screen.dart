// import 'package:ecinema_watch_together/utils/app/app_assets.dart';
// import 'package:ecinema_watch_together/utils/app/app_colors.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';

// const deg = 3.1415927 / 180;
// const rotateAngle = 45.0;
// const boxWidth = 200.0;
// const boxWidthStepTwo = 60.0;
// const boxWidthStepThree = 140.0;
// const boxHeightStepThree = 20.0;
// const loaderWidth = 100.0;

// class TryScreen extends StatefulWidget {
//   const TryScreen({super.key});

//   @override
//   State<TryScreen> createState() => _TryScreenState();
// }

// class _TryScreenState extends State<TryScreen> with TickerProviderStateMixin {

//   late AnimationController _controller1;
//   late Animation<double> _animation1;
//   late AnimationController _controller2;
//   late Animation<double> _animation2;
//   late AnimationController _controller3;
//   late Animation<double> _animation3;
//   late AnimationController _controller4;
//   late Animation<double> _animation4;

//   @override
//   void initState() {
//     _controller1 = AnimationController(duration: const Duration(milliseconds: 600), vsync: this);
//     _animation1 = Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(parent: _controller1, curve: Curves.easeOutBack));
//     _controller2 = AnimationController(duration: const Duration(milliseconds: 300), vsync: this);
//     _animation2 = Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(parent: _controller2, curve: Curves.decelerate));
//     _controller3 = AnimationController(duration: const Duration(milliseconds: 400), vsync: this);
//     _animation3 = Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(parent: _controller3, curve: Curves.decelerate));
//     _controller4 = AnimationController(duration: const Duration(milliseconds: 1200), vsync: this);
//     _animation4 = Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(parent: _controller4, curve: Curves.easeInOutQuart));
//     _controller1.addListener(() {
//       setState(() {});
//       if(_controller1.status == AnimationStatus.completed) {
//         _controller1.removeListener(() { });
//         _controller2.forward();
//         _controller2.addListener(() { 
//           setState(() {});
//           if(_controller2.status == AnimationStatus.completed) {
//             _controller2.removeListener(() { });
//             _controller3.forward();
//             _controller3.addListener(() { 
//               setState(() {});
//               if(_controller3.status == AnimationStatus.completed) {
//                 _controller3.removeListener(() { });
//                 _controller4.forward();
//                 _controller4.addListener(() {
//                   setState(() {});
//                   if(_controller4.status == AnimationStatus.completed) {
//                      Future.delayed(const Duration(milliseconds: 300), () {
//                       if(mounted) {
//                         _controller4.forward(from: 0.0);
//                       }
//                      });
//                   }
//                 });
//               }
//             });
//           }
//         });
//       }
//      });
//     _controller1.forward();
//     super.initState();
//   }

//   @override
//   void dispose() {
//     _controller1.dispose();
//     _controller2.dispose();
//     _controller3.dispose();
//     _controller4.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final img = Image.asset(AppAssets.animationLogo);
//     final stepOne = !_animation1.isCompleted;
//     final stepTwo = _animation1.isCompleted && !_animation2.isCompleted;
//     final stepThree = _animation1.isCompleted && _animation2.isCompleted && !_animation3.isCompleted;
//     final stepFour = _animation1.isCompleted && _animation2.isCompleted && _animation3.isCompleted;
//     return Scaffold(
//       backgroundColor: AppColors.scaffoldBackgroundColor,
//       body: SizedBox(
//         width: Get.width,
//         height: Get.height,
//         child: Center(
//           child: Opacity(
//             opacity: stepOne ? _animation1.value >= 1 ? 1 : _animation1.value : 1,
//             child: Transform.rotate(
//               angle: (rotateAngle - (_animation1.value * rotateAngle)) * deg,
//               child: Container(
//                 clipBehavior: Clip.hardEdge,
//                 width: stepFour ? boxWidthStepThree : stepThree ? boxWidthStepTwo + ((boxWidthStepThree - boxWidthStepTwo) * _animation3.value) : stepTwo ? boxWidth - ((boxWidth - boxWidthStepTwo) * _animation2.value) : _animation1.value * boxWidth,
//                 height: stepFour ? boxHeightStepThree : stepThree ? boxWidthStepTwo - ((boxWidthStepTwo - boxHeightStepThree) * _animation3.value) : stepTwo ? boxWidth - ((boxWidth - boxWidthStepTwo) * _animation2.value) : _animation1.value * boxWidth,
//                 decoration: BoxDecoration(
//                   borderRadius: BorderRadius.circular(120),
//                   color: Colors.black
//                 ),
//                 child: Stack(
//                   alignment: Alignment.center,
//                   children: [
//                     /// IMAGE
//                     Padding(
//                       padding: const EdgeInsets.all(42),
//                       child: Opacity(
//                         opacity: stepTwo ? 1 - _animation2.value : _animation1.value >= 1 ? 1 : stepOne ? _animation1.value : 0,
//                         child: img
//                       ),
//                     ),
//                     /// Loader
//                     if(stepFour)
//                     Positioned(
//                       bottom: 0,
//                       left: ((boxWidthStepThree + loaderWidth) * _animation4.value) - loaderWidth,
//                       child: Container(
//                         width: loaderWidth,
//                         height: boxHeightStepThree,
//                         decoration:  BoxDecoration(
//                           borderRadius: BorderRadius.circular(60),
//                           gradient: const LinearGradient(colors: [Color.fromARGB(255, 224, 145, 27), AppColors.themeColor], begin: Alignment.centerLeft, end: Alignment.centerRight)
//                         ),
//                       ),
//                     )
//                   ],
//                 )
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
import 'dart:io';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

void main() {
  runApp(const TryScreen());
}

class TryScreen extends StatelessWidget {
  const TryScreen({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
          highlightColor: const Color(0xFFD0996F),
          canvasColor: const Color(0xFFFDF5EC),
          textTheme: TextTheme(
            headlineSmall: ThemeData.light()
                .textTheme
                .headlineSmall!
                .copyWith(color: const Color(0xFFBC764A)),
          ),
          iconTheme: IconThemeData(
            color: Colors.grey[600],
          ),
          appBarTheme: const AppBarTheme(
            backgroundColor: Color(0xFFBC764A),
            centerTitle: false,
            foregroundColor: Colors.white,
            actionsIconTheme: IconThemeData(color: Colors.white),
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ButtonStyle(
              backgroundColor: MaterialStateColor.resolveWith(
                  (states) => const Color(0xFFBC764A)),
            ),
          ),
          outlinedButtonTheme: OutlinedButtonThemeData(
            style: ButtonStyle(
              foregroundColor: MaterialStateColor.resolveWith(
                (states) => const Color(0xFFBC764A),
              ),
              side: MaterialStateBorderSide.resolveWith(
                  (states) => const BorderSide(color: Color(0xFFBC764A))),
            ),
          ),
          colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.blue)
              .copyWith(background: const Color(0xFFFDF5EC))),
      home: const HomePage(title: 'Image Cropper Demo'),
    );
  }
}

class HomePage extends StatefulWidget {
  final String title;

  const HomePage({
    Key? key,
    required this.title,
  }) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  XFile? _pickedFile;
  CroppedFile? _croppedFile;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: !kIsWeb ? AppBar(title: Text(widget.title)) : null,
      body: _body()
    );
  }

  Widget _body() {
    if (_croppedFile != null || _pickedFile != null) {
      return _imageCard();
    } else {
      return _uploaderCard();
    }
  }

  Widget _imageCard() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: kIsWeb ? 24.0 : 16.0),
            child: Card(
              elevation: 4.0,
              child: Padding(
                padding: const EdgeInsets.all(kIsWeb ? 24.0 : 16.0),
                child: _image(),
              ),
            ),
          ),
          const SizedBox(height: 24.0),
          _menu(),
        ],
      ),
    );
  }

  Widget _image() {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    if (_croppedFile != null) {
      final path = _croppedFile!.path;
      return ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: 0.8 * screenWidth,
          maxHeight: 0.7 * screenHeight,
        ),
        child: kIsWeb ? Image.network(path) : Image.file(File(path)),
      );
    } else if (_pickedFile != null) {
      final path = _pickedFile!.path;
      return ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: 0.8 * screenWidth,
          maxHeight: 0.7 * screenHeight,
        ),
        child: kIsWeb ? Image.network(path) : Image.file(File(path)),
      );
    } else {
      return const SizedBox.shrink();
    }
  }

  Widget _menu() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        FloatingActionButton(
          onPressed: () {
            _clear();
          },
          backgroundColor: Colors.redAccent,
          tooltip: 'Delete',
          child: const Icon(Icons.delete),
        ),
        if (_croppedFile == null)
          Padding(
            padding: const EdgeInsets.only(left: 32.0),
            child: FloatingActionButton(
              onPressed: () {
                _cropImage();
              },
              backgroundColor: const Color(0xFFBC764A),
              tooltip: 'Crop',
              child: const Icon(Icons.crop),
            ),
          )
      ],
    );
  }

  Widget _uploaderCard() {
    return Center(
      child: Card(
        elevation: 4.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0),
        ),
        child: SizedBox(
          width: kIsWeb ? 380.0 : 320.0,
          height: 300.0,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: DottedBorder(
                    radius: const Radius.circular(12.0),
                    borderType: BorderType.RRect,
                    dashPattern: const [8, 4],
                    color: Theme.of(context).highlightColor.withOpacity(0.4),
                    child: Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.image,
                            color: Theme.of(context).highlightColor,
                            size: 80.0,
                          ),
                          const SizedBox(height: 24.0),
                          Text(
                            'Upload an image to start',
                            style: kIsWeb
                                ? Theme.of(context)
                                    .textTheme
                                    .headlineSmall!
                                    .copyWith(
                                        color: Theme.of(context).highlightColor)
                                : Theme.of(context)
                                    .textTheme
                                    .bodyMedium!
                                    .copyWith(
                                        color:
                                            Theme.of(context).highlightColor),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 24.0),
                child: ElevatedButton(
                  onPressed: () {
                    _uploadImage();
                  },
                  child: const Text('Upload'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _cropImage() async {
    if (_pickedFile != null) {
      final croppedFile = await ImageCropper().cropImage(
        sourcePath: _pickedFile!.path,
        compressFormat: ImageCompressFormat.jpg,
        compressQuality: 100,
        uiSettings: [
          AndroidUiSettings(
              toolbarTitle: 'Cropper',
              toolbarColor: Colors.deepOrange,
              toolbarWidgetColor: Colors.white,
              initAspectRatio: CropAspectRatioPreset.original,
              lockAspectRatio: false),
          IOSUiSettings(
            title: 'Cropper',
          ),
          WebUiSettings(
            context: context,
            presentStyle: CropperPresentStyle.dialog,
            boundary: const CroppieBoundary(
              width: 520,
              height: 520,
            ),
            viewPort:
                const CroppieViewPort(width: 480, height: 480, type: 'circle'),
            enableExif: true,
            enableZoom: true,
            showZoomer: true,
          ),
        ],
      );
      if (croppedFile != null) {
        final uint8List = await croppedFile.readAsBytes();
        
        setState(() {
          _croppedFile = croppedFile;
        });
      }

    }
  }

  Future<void> _uploadImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _pickedFile = pickedFile;
      });
    }
  }

  void _clear() {
    setState(() {
      _pickedFile = null;
      _croppedFile = null;
    });
  }
}