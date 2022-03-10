import 'package:firebase_chat_app_using_getx/services/auth.dart';
import 'package:firebase_chat_app_using_getx/services/database.dart';
import 'package:firebase_chat_app_using_getx/ui/SignInScreen/sign_in_screen.dart';
import 'package:firebase_chat_app_using_getx/utils/PreferenceUtils.dart';
import 'package:firebase_chat_app_using_getx/utils/app_utils.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

class ChatRoomsController extends GetxController {
  Stream? chatRoomsStream;

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    DatabaseMethods()
        .getUserChats(PreferenceUtils.getString(keyUserId))
        .then((val) {
      if (kDebugMode) {
        print("val $val");
      }
      chatRoomsStream = val;
      update();
    });
  }

  signOut() async {
    AuthService().signOut();
    await PreferenceUtils.setString(keyUserId, "");
    Get.offAll(SignInScreen());
  }

  deletechat(var roomid) {
    DatabaseMethods().deleteChat(roomid);
    DatabaseMethods().deleteChats(roomid);
    showToast("Delete Successfully");
  }
}
