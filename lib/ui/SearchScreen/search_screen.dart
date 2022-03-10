import 'package:firebase_chat_app_using_getx/ui/SearchScreen/search_controller.dart';
import 'package:firebase_chat_app_using_getx/utils/app_utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  SearchController? searchController;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SearchController>(
        init: SearchController(),
        builder: (controller) {
          searchController = controller;
          return Scaffold(
            appBar: appBar(),
            body: bodyView(),
          );
        });
  }

  AppBar appBar() {
    return AppBar(
      backgroundColor: const Color(0xFF574545),
      title: TextField(
        controller: searchController!.searchTextController,
        style: whiteRegular16,
        cursorColor: Colors.white,
        onEditingComplete: () {
          searchController!.initiateSearch();
        },
        decoration: const InputDecoration(
          hintText: "Search Username Here...",
          hintStyle: TextStyle(
            color: Colors.white70,
            fontSize: 16,
          ),
          border: InputBorder.none,
        ),
      ),
      actions: [
        InkWell(
          onTap: () {
            searchController!.initiateSearch();
          },
          child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: const Icon(
                Icons.search,
                color: Colors.white,
              )),
        ),
      ],
    );
  }

  Widget bodyView() {
    return searchController!.userDocumentSnapshot.isNotEmpty
        ? ListView.builder(
            padding: const EdgeInsets.only(top: 5),
            itemBuilder: (context, index) {
              return userView(
                  index, searchController!.userDocumentSnapshot[index].data());
            },
            itemCount: searchController!.userDocumentSnapshot.length,
          )
        : Container();
  }

  Widget userView(int index, var userData) {
    return InkWell(
      onTap: () {
        searchController!.createChatRoom(userData);
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
                backgroundColor: const Color(0xFF422D2D),
                child: Container(
                  padding: const EdgeInsets.all(8),
                  alignment: Alignment.center,
                  child: Text(
                    "${userData["userName"][0]}",
                    style: whiteBold16,
                  ),
                ),
              ),
              const SizedBox(
                width: 12,
              ),
              Text(
                "${userData["userName"]}",
                style: blackBold16,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
