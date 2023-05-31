import 'package:flutter/material.dart';
import 'package:poc_app/screens/splash/splash.dart';
import 'package:camera/camera.dart';
import 'package:poc_app/theme.dart';

Future<void> main() async {
  late List<CameraDescription> _cameras;
  WidgetsFlutterBinding.ensureInitialized();
  _cameras = await availableCameras();
  if (_cameras != null)
    runApp(MyApp(
      camera: _cameras[0],
    ));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key, required this.camera}) : super(key: key);
  final CameraDescription camera;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'DeepQual',
      theme: theme(context),
      home: SplashScreen(camera: camera),
    );
  }
}
