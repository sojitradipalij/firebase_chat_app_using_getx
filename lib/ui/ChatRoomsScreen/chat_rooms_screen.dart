import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_chat_app_using_getx/ui/ChatRoomsScreen/chat_rooms_controller.dart';
import 'package:firebase_chat_app_using_getx/ui/ChatScreen/chat_screen.dart';
import 'package:firebase_chat_app_using_getx/ui/SearchScreen/search_screen.dart';
import 'package:firebase_chat_app_using_getx/utils/app_utils.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../utils/PreferenceUtils.dart';

class ChatRoomsScreen extends StatefulWidget {
  const ChatRoomsScreen({Key? key}) : super(key: key);

  @override
  State<ChatRoomsScreen> createState() => _ChatRoomsScreenState();
}

class _ChatRoomsScreenState extends State<ChatRoomsScreen> {
  ChatRoomsController? chatRoomsController;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ChatRoomsController>(
        init: ChatRoomsController(),
        builder: (controller) {
          chatRoomsController = controller;
          return Scaffold(
            appBar: appBar(),
            body: bodyView(),
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                Get.to(SearchScreen());
              },
              child: const Icon(Icons.search),
            ),
          );
        });
  }

  AppBar appBar() {
    return AppBar(
      title: const Text("Chat Rooms"),
      actions: [
        InkWell(
          onTap: () {
            chatRoomsController!.signOut();
          },
          child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: const Icon(
                Icons.logout,
                color: Colors.white,
              )),
        ),
      ],
    );
  }

  Widget bodyView() {
    return StreamBuilder(
      stream: chatRoomsController!.chatRoomsStream,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          QuerySnapshot qSnap = snapshot.data as QuerySnapshot;
          List<DocumentSnapshot> docs = qSnap.docs;
          return ListView.builder(
              padding: const EdgeInsets.only(top: 8),
              itemCount: docs.length,
              itemBuilder: (context, index) {
                return userView(docs[index].data());
              });
        } else {
          if (kDebugMode) {
            print("no data");
          }
          return Container();
        }
      },
    );
  }

  Widget userView(var userData) {
    String userName;

    if (userData["userIds"][0] == PreferenceUtils.getString(keyUserId)) {
      userName = userData["users"][1];
    } else {
      userName = userData["users"][0];
    }

    if (kDebugMode) {
      print("userData $userData");
    }
    return GestureDetector(
      onTap: () async {
        // searchController.createChatRoom(userData);
        await PreferenceUtils.setString(keyChatRoomId, userData["chatRoomId"]);
        Get.to(ChatScreen(
          chatRoomId: userData["chatRoomId"],
          userName: userName,
        ));
      },
      onLongPress: () {
        if (kDebugMode) {
          print("chatRoomId ${userData["chatRoomId"]}");
        }
        chatRoomsController!.deletechat(userData["chatRoomId"]);
      },
      child: Card(
        elevation: 2,
        margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Container(
          padding: const EdgeInsets.all(8),
          child: Row(
            children: [
              CircleAvatar(
                radius: 20,
                backgroundColor: const Color(0xFF868181),
                child: Container(
                  padding: const EdgeInsets.all(8),
                  alignment: Alignment.center,
                  child: Text(
                    userName[0],
                    style: whiteBold16,
                  ),
                ),
              ),
              const SizedBox(
                width: 12,
              ),
              Text(
                userName,
                style: blackBold16,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
