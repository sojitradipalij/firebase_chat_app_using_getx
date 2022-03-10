import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_chat_app_using_getx/utils/PreferenceUtils.dart';
import 'package:flutter/foundation.dart';

class DatabaseMethods {
  Future<void> addUserInfo(userData) async {
    FirebaseFirestore.instance
        .collection("users")
        .add(userData)
        .catchError((e) {
      if (kDebugMode) {
        print(e.toString());
      }
    });
  }

  getUserInfo(String email) async {
    return FirebaseFirestore.instance
        .collection("users")
        .where("userEmail", isEqualTo: email)
        .get()
        .catchError((e) {
      if (kDebugMode) {
        print(e.toString());
      }
    });
  }

  getAllUserInfo(String userName) async {
    return FirebaseFirestore.instance
        .collection("users")
        .where("userName", isEqualTo: userName)
        .where("UserId", isNotEqualTo: PreferenceUtils.getString(keyUserId))
        .get()
        .catchError((e) {
      if (kDebugMode) {
        print(e.toString());
      }
    });
  }

  Future<bool?> addChatRoom(chatRoom, chatRoomId) async {
    await FirebaseFirestore.instance
        .collection("chatRoom")
        .doc(chatRoomId)
        .set(chatRoom)
        .catchError((e) {
      if (kDebugMode) {
        print(e);
      }
    });
  }

  getChats(String chatRoomId, int limit) async {
    return FirebaseFirestore.instance
        .collection("chatRoom")
        .doc(chatRoomId)
        .collection("chats")
        .orderBy('time', descending: true)
        .snapshots();
  }

  deleteChat(String chatRoomId) {
    return FirebaseFirestore.instance
        .collection("chatRoom")
        .doc(chatRoomId)
        .collection("chats")
        .get()
        .then((value) {
      value.docs.forEach((element) async {
        await FirebaseFirestore.instance
            .collection("chatRoom")
            .doc(chatRoomId)
            .collection("chats")
            .doc(element.id)
            .delete()
            .then((value) {
          if (kDebugMode) {
            print("Success!");
          }
        });
      });
    });
  }

  deleteChats(String chatRoomId) async {
    return FirebaseFirestore.instance
        .collection("chatRoom")
        .doc(chatRoomId)
        .delete();
  }

  Future<void> sendMessage(String chatRoomId, chatMessageData) async {
    await FirebaseFirestore.instance
        .collection("chatRoom")
        .doc(chatRoomId)
        .collection("chats")
        .add(chatMessageData)
        .catchError((e) {
      if (kDebugMode) {
        print(e.toString());
      }
    });
  }

  getUserChats(String itIsMyID) async {
    if (kDebugMode) {
      print("itIsMyID $itIsMyID");
    }
    return FirebaseFirestore.instance
        .collection("chatRoom")
        .where('userIds', arrayContains: itIsMyID)
        .snapshots();
  }
}
