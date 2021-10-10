// ignore_for_file: file_names, prefer_const_constructors
//! USED IN MAIN, SIGNIN AND SIGNUP

import 'package:chatapp/helper/Authenticate.dart';
import 'package:chatapp/helper/constants.dart';
import 'package:chatapp/helper/helperfunctions.dart';
import 'package:chatapp/services/auth.dart';
import 'package:chatapp/services/database.dart';
import 'package:chatapp/views/conversation_screen.dart';
import 'package:chatapp/views/search.dart';
import 'package:chatapp/views/signIn.dart';
import 'package:chatapp/widgits/widgits.dart';
import 'package:flutter/material.dart';

class ChatRoom extends StatefulWidget {
  const ChatRoom({Key? key}) : super(key: key);

  @override
  _ChatRoomState createState() => _ChatRoomState();
}

String? _myName;

class _ChatRoomState extends State<ChatRoom> {
  Authmethords authmethords = Authmethords();
  DatabaseMethords databaseMethords = DatabaseMethords();

  Stream? chatRoomStream;

  Widget chatRoomList() {
    //Same as ConversationScreen
    return StreamBuilder(
        stream: chatRoomStream,
        builder: (context, AsyncSnapshot snapshot) {
          return snapshot.hasData
              ? ListView.builder(
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    return ChatRoomTile(
                      userName: snapshot.data!.docs[index].data["chatRoomId"]
                          .toString()
                          .replaceAll("_", "")
                          .replaceAll(Constants.myName, ""),
                      chatRoomId: snapshot.data!.docs[index].data["chatRoomId"],
                    );
                  })
              : Container();
        });
  }

  // @override
  // void initState() {
  //   getUserInfo();
  //   super.initState();
  // }

  //bcoz we cant use async in initState
  Future getUserInfo() async {
    _myName = await Helperfunctions.getuserNameSharedPreference();
    databaseMethords.getChatRoom(Constants.myName).then((value) {
      setState(() {
        chatRoomStream = value;
      });
    });
    // setState(() async {
    //   // Constants.myName = (await Helperfunctions.getuserNameSharedPreference())!;
    // });
    print("$_myName");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Image.asset(
          "assets/images/logo.png",
          height: 50,
        ),
        actions: [
          GestureDetector(
              onTap: () {
                authmethords.signOut();
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const Authenticate()));
              },
              child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: const Icon(Icons.exit_to_app)))
        ],
      ),
      // body: chatRoomList(),
      floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.search),
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => const SearchScreen()));
          }),
    );
  }
}

class ChatRoomTile extends StatelessWidget {
  const ChatRoomTile(
      {Key? key, required this.userName, required this.chatRoomId})
      : super(key: key);
  final String userName;
  final String chatRoomId;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ConversationScreen(
                      chatRoomId: chatRoomId,
                    )));
      },
      child: Container(
        color: Colors.black26,
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Row(
          children: [
            Container(
              height: 40,
              width: 40,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  color: Colors.blue, borderRadius: BorderRadius.circular(40)),
              child: Text(
                "$userName.substring(0,1)",
                style: mediumTextFieldStyle(),
              ), //Provides 1st String value
            ),
            SizedBox(width: 8),
            Text(
              userName,
              style: mediumTextFieldStyle(),
            )
          ],
        ),
      ),
    );
  }
}
