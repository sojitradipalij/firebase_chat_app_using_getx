import 'package:firebase_chat_app_using_getx/ui/ChatRoomsScreen/chat_rooms_screen.dart';
import 'package:firebase_chat_app_using_getx/ui/SignInScreen/sign_in_screen.dart';
import 'package:firebase_chat_app_using_getx/utils/PreferenceUtils.dart';
import 'package:get/get.dart';

class SplashController extends GetxController {
  @override
  void onInit() {
    super.onInit();
    PreferenceUtils.init();
    Future.delayed(const Duration(seconds: 3), () {
      if (PreferenceUtils.getString(keyUserId) != "") {
        Get.offAll(const ChatRoomsScreen());
      } else {
        Get.offAll(const SignInScreen());
      }
    });
  }
}
