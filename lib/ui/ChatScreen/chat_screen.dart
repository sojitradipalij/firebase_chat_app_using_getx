import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_chat_app_using_getx/ui/ChatScreen/chat_controller.dart';
import 'package:firebase_chat_app_using_getx/utils/PreferenceUtils.dart';
import 'package:firebase_chat_app_using_getx/utils/app_utils.dart';
import 'package:firebase_chat_app_using_getx/utils/full_photo_page.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChatScreen extends StatefulWidget {
  final String? userName;
  final String? chatRoomId;

  const ChatScreen({Key? key, this.userName, this.chatRoomId})
      : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  ChatController? chatController;

  @override
  Widget build(BuildContext context) {
    if (kDebugMode) {
      print("userName ${widget.userName}");
      print("chatRoomId ${widget.chatRoomId}");
    }

    return GetBuilder<ChatController>(
        init: ChatController(),
        builder: (controller) {
          chatController = controller;
          return Scaffold(
            appBar: appBar(),
            body: bodyView(),
          );
        });
  }

  AppBar appBar() {
    return AppBar(
      title: Text(widget.userName!),
    );
  }

  Widget bodyView() {
    return Stack(
      children: [
        Column(
          children: [
            Expanded(child: chatMessages()),
            uploadImageView(),
            const SizedBox(
              height: 63,
            ),
          ],
        ),
        buildInput()
      ],
    );
  }

  Widget uploadImageView() {
    return chatController!.isLoading
        ? Align(
            alignment: Alignment.centerRight,
            child: Container(
              alignment: Alignment.center,
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                color: const Color(0xFFF2F2F2),
                borderRadius: BorderRadius.circular(10),
              ),
              margin:
                  const EdgeInsets.only(top: 8, bottom: 8, left: 15, right: 15),
              child: const CircularProgressIndicator(
                color: primaryColor,
              ),
            ),
          )
        : const SizedBox.shrink();
  }

  Widget uploadImageView1() {
    return !chatController!.isLoading
        ? Container(
            child: const Center(
              child: CircularProgressIndicator(
                color: primaryColor,
              ),
            ),
            color: Colors.white.withOpacity(0.8),
          )
        : const SizedBox.shrink();
  }

  Widget chatMessages() {
    return StreamBuilder(
      stream: chatController!.chatMessageStream,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          QuerySnapshot qSnap = snapshot.data as QuerySnapshot;
          chatController!.listMessage = qSnap.docs;
          return ListView.builder(
              reverse: true,
              itemCount: chatController!.listMessage.length,
              itemBuilder: (context, index) {
                return itemMessage(chatController!.listMessage[index].data());
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

  Widget itemMessage(var itemData) {
    bool sendByMe =
        PreferenceUtils.getString(keyUserId) == "${itemData["sendBy"]}";

    if (kDebugMode) {
      print("sendByMe $sendByMe");
      print("docs $itemData");
    }

    return itemData["type"] == null || itemData["type"] == 0
        ? Container(
            padding:
                const EdgeInsets.only(top: 8, bottom: 8, left: 15, right: 15),
            alignment: sendByMe ? Alignment.centerRight : Alignment.centerLeft,
            child: Container(
              margin: sendByMe
                  ? const EdgeInsets.only(left: 30)
                  : const EdgeInsets.only(right: 30),
              padding: const EdgeInsets.only(
                  top: 12, bottom: 12, left: 18, right: 20),
              decoration: BoxDecoration(
                  borderRadius: sendByMe
                      ? const BorderRadius.only(
                          topLeft: Radius.circular(23),
                          topRight: Radius.circular(23),
                          bottomLeft: Radius.circular(23))
                      : const BorderRadius.only(
                          topLeft: Radius.circular(23),
                          topRight: Radius.circular(23),
                          bottomRight: Radius.circular(23)),
                  gradient: LinearGradient(
                    colors: sendByMe
                        // ? [const Color(0xAD004D40), const Color(0xAD004D40)]
                        ? [const Color(0xFFE7E4E4), const Color(0xFFE7E4E4)]
                        : [const Color(0xffE8E8E8), const Color(0xffE8E8E8)],
                  )),
              child: Text("${itemData["message"]}",
                  textAlign: TextAlign.start,
                  style: TextStyle(
                    color: sendByMe ? Colors.black : Colors.black,
                    // fontSize: 15,
                  )),
            ),
          )
        : Container(
            alignment: sendByMe ? Alignment.centerRight : Alignment.centerLeft,
            child: OutlinedButton(
              child: Material(
                child: Image.network(
                  itemData["message"],
                  loadingBuilder: (BuildContext context, Widget child,
                      ImageChunkEvent? loadingProgress) {
                    if (loadingProgress == null) return child;
                    return Container(
                      decoration: const BoxDecoration(
                        color: Color(0xFFE7E4E4),
                        borderRadius: BorderRadius.all(
                          Radius.circular(8),
                        ),
                      ),
                      width: 200,
                      height: 200,
                      child: Center(
                        child: CircularProgressIndicator(
                          color: primaryColor,
                          value: loadingProgress.expectedTotalBytes != null &&
                                  loadingProgress.expectedTotalBytes != null
                              ? loadingProgress.cumulativeBytesLoaded /
                                  loadingProgress.expectedTotalBytes!
                              : null,
                        ),
                      ),
                    );
                  },
                  errorBuilder: (context, object, stackTrace) {
                    return Material(
                      child: Image.asset(
                        'images/img_not_available.jpeg',
                        width: 200,
                        height: 200,
                        fit: BoxFit.cover,
                      ),
                      borderRadius: const BorderRadius.all(
                        Radius.circular(8),
                      ),
                      clipBehavior: Clip.hardEdge,
                    );
                  },
                  width: 200,
                  height: 200,
                  fit: BoxFit.cover,
                ),
                borderRadius: const BorderRadius.all(Radius.circular(8)),
                clipBehavior: Clip.hardEdge,
              ),
              onPressed: () {
                Get.to(FullPhotoPage(
                  url: itemData["message"],
                ));
              },
              style: ButtonStyle(
                  padding: MaterialStateProperty.all<EdgeInsets>(
                      const EdgeInsets.all(0))),
            ),
            margin:
                const EdgeInsets.only(top: 8, bottom: 8, left: 15, right: 15),
          );
  }

  Widget buildInput() {
    return Container(
      alignment: Alignment.bottomCenter,
      width: Get.size.width,
      child: Container(
        height: 58,
        color: const Color(0xFF574545),
        alignment: Alignment.center,
        child: Row(
          children: [
            Material(
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 1),
                child: IconButton(
                  icon: const Icon(
                    Icons.image,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    chatController!.getImage();
                  },
                ),
              ),
              color: Colors.transparent,
            ),
            Expanded(
                child: TextField(
              controller: chatController!.messageController,
              style: whiteRegular16,
              cursorColor: Colors.white,
              decoration: const InputDecoration(
                  hintText: "Message ...",
                  hintStyle: TextStyle(
                    color: Colors.white70,
                    fontSize: 16,
                  ),
                  border: InputBorder.none),
            )),
            const SizedBox(
              width: 16,
            ),
            GestureDetector(
              onTap: () {
                chatController!.sendMessage(type: 0);
              },
              child: Container(
                  height: 40,
                  width: 40,
                  decoration: BoxDecoration(
                      gradient: const LinearGradient(
                          colors: [Color(0x36FFFFFF), Color(0x0FFFFFFF)],
                          begin: FractionalOffset.topLeft,
                          end: FractionalOffset.bottomRight),
                      borderRadius: BorderRadius.circular(40)),
                  padding: const EdgeInsets.all(10),
                  alignment: Alignment.center,
                  child: const Icon(
                    Icons.send,
                    color: Colors.white,
                    size: 20,
                  )),
            ),
            const SizedBox(
              width: 10,
            ),
          ],
        ),
      ),
    );
  }
}
