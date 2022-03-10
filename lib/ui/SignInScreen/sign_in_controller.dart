import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_chat_app_using_getx/services/auth.dart';
import 'package:firebase_chat_app_using_getx/services/database.dart';
import 'package:firebase_chat_app_using_getx/ui/ChatRoomsScreen/chat_rooms_screen.dart';
import 'package:firebase_chat_app_using_getx/utils/PreferenceUtils.dart';
import 'package:firebase_chat_app_using_getx/utils/loading_dialog.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SignInController extends GetxController {
  final formKey = GlobalKey<FormState>();
  AuthService authService = AuthService();

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  bool isSecure = true;

  @override
  void onInit() {
    super.onInit();
    PreferenceUtils.init();
  }

  setSecureUnSecure() {
    isSecure = !isSecure;
    update();
  }

  signInWithEmailAndPassword() async {
    Get.focusScope?.unfocus();
    if (formKey.currentState!.validate()) {
      showLoader(Get.context);
      await authService
          .signInWithEmailAndPassword(
              emailController.text, passwordController.text)
          .then((result) async {
        Get.back();
        if (result != null) {
          if (kDebugMode) {
            print(result.toString());
            print(result.toString());
          }

          await PreferenceUtils.setString(keyUserId, result.uid);
          if (kDebugMode) {
            print("uid : ${result.uid}");
          }
          await PreferenceUtils.setString(keyUserEmail, "${result.email}");

          QuerySnapshot userInfoSnapshot =
              await DatabaseMethods().getUserInfo(emailController.text);

          final userData =
              userInfoSnapshot.docs[0].data() as Map<String, dynamic>;
          if (kDebugMode) {
            print("${userData["userName"]}");
          }

          await PreferenceUtils.setString(
              keyUserName, "${userData["userName"]}");

          Get.offAll(const ChatRoomsScreen());
        }
      });
    }
  }
}
