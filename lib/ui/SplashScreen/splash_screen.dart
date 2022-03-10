import 'package:firebase_chat_app_using_getx/ui/SplashScreen/splash_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  SplashController splashController = Get.put(SplashController());

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SplashController>(builder: (controller) {
      return Scaffold(
        body: bodyView(),
      );
    });
  }

  Widget bodyView() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: const [
        Center(
            child: Icon(
          Icons.forum_rounded,
          size: 100,
        ))
      ],
    );
  }
}
