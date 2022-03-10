import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_chat_app_using_getx/services/database.dart';
import 'package:firebase_chat_app_using_getx/utils/PreferenceUtils.dart';
import 'package:firebase_chat_app_using_getx/utils/app_utils.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class ChatController extends GetxController {
  Stream? chatMessageStream;

  TextEditingController messageController = TextEditingController();

  bool isLoading = false;
  String? imageUrl;

  final int _limit = 20;

  List<QueryDocumentSnapshot> listMessage = [];
  final ScrollController listScrollController = ScrollController();

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    Future.delayed(Duration.zero, () {
      if (kDebugMode) {
        print("------------------------------------------");
        print("keyChatRoomId ${PreferenceUtils.getString(keyChatRoomId)}");
        print("------------------------------------------");
      }
    });
    DatabaseMethods()
        .getChats(PreferenceUtils.getString(keyChatRoomId), _limit)
        .then((val) {
      if (kDebugMode) {
        print("val $val");
      }
      chatMessageStream = val;
      update();
    });
  }

  sendMessage({var type}) {
    if (type == 0) {
      if (messageController.text.isNotEmpty) {
        Map<String, dynamic> chatMessageMap = {
          "sendBy": PreferenceUtils.getString(keyUserId),
          "message": messageController.text,
          "type": 0,
          'time': DateTime.now().millisecondsSinceEpoch,
        };

        DatabaseMethods().sendMessage(
            PreferenceUtils.getString(keyChatRoomId), chatMessageMap);

        messageController.text = "";
        update();
      }
    } else {
      Map<String, dynamic> chatMessageMap = {
        "sendBy": PreferenceUtils.getString(keyUserId),
        "message": imageUrl,
        "type": 1,
        'time': DateTime.now().millisecondsSinceEpoch,
      };

      DatabaseMethods().sendMessage(
          PreferenceUtils.getString(keyChatRoomId), chatMessageMap);

      messageController.text = "";
      update();
    }
  }

  getImage() async {
    ImagePicker imagePicker = ImagePicker();
    PickedFile? pickedFile;

    pickedFile = await imagePicker.getImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      File imageFile = File(pickedFile.path);
      isLoading = true;
      update();
      uploadFile(imageFile);
    }
  }

  Future uploadFile(File imageFile) async {
    String fileName = DateTime.now().millisecondsSinceEpoch.toString();
    Reference reference = FirebaseStorage.instance.ref().child(fileName);
    UploadTask uploadTask = reference.putFile(imageFile);
    try {
      TaskSnapshot snapshot = await uploadTask;
      imageUrl = await snapshot.ref.getDownloadURL();
      isLoading = false;
      update();
      sendMessage(type: 1);
    } on FirebaseException catch (e) {
      isLoading = false;
      update();
      showToast(e.message ?? e.toString());
    }
  }
}
