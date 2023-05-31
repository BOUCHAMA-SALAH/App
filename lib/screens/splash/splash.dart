import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:camera/camera.dart';
import 'package:poc_app/screens/home/home.dart';
import 'package:flutter/material.dart';
import 'package:poc_app/size_config.dart';

class SplashScreen extends StatefulWidget {
  SplashScreen({Key? key, required this.camera}) : super(key: key);
  static String routeName = "/splash";
  final CameraDescription camera;

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
  }

  // _navigateToHome() async {
  //   await Future.delayed(Duration(milliseconds: 2500), (() {}));
  //   Navigator.pushReplacementNamed(context, Layout.routeName);
  // }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);

    return AnimatedSplashScreen(
      backgroundColor: Color(0xff282d36),
      splash: "assets/images/deepqual.png",
      splashIconSize: 300,
      nextScreen: Home(camera: widget.camera),
      splashTransition: SplashTransition.scaleTransition,
    );
  }
}
