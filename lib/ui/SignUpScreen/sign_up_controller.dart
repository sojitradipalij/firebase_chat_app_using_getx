import 'package:firebase_chat_app_using_getx/services/auth.dart';
import 'package:firebase_chat_app_using_getx/services/database.dart';
import 'package:firebase_chat_app_using_getx/ui/ChatRoomsScreen/chat_rooms_screen.dart';
import 'package:firebase_chat_app_using_getx/utils/PreferenceUtils.dart';
import 'package:firebase_chat_app_using_getx/utils/loading_dialog.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SignUpController extends GetxController {
  final formKey = GlobalKey<FormState>();
  AuthService authService = AuthService();
  DatabaseMethods databaseMethods = DatabaseMethods();

  TextEditingController userNameController = TextEditingController();
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

  signUpWithEmailAndPassword() async {
    if (formKey.currentState!.validate()) {
      Get.focusScope?.unfocus();
      showLoader(Get.context);
      await authService
          .signUpWithEmailAndPassword(
              emailController.text, passwordController.text)
          .then((result) async {
        Get.back();
        if (result != null) {
          if (kDebugMode) {
            print("result : $result");
          }

          await PreferenceUtils.setString(keyUserId, "${result.uid}");
          await PreferenceUtils.setString(
              keyUserName, userNameController.text.toString());
          await PreferenceUtils.setString(keyUserEmail, emailController.text);

          Map<String, dynamic> userDataMap = {
            "UserId": result.uid,
            "userName": userNameController.text,
            "userEmail": emailController.text
          };

          databaseMethods.addUserInfo(userDataMap);

          Get.offAll(const ChatRoomsScreen());
        }
      });
    }
  }
}
