// ignore_for_file: prefer_const_constructors, avoid_print
//TODO UNDERSTOOD......

//? Main(search Button) to initite search.
//? Where initiate search takes texteditingcontroller and searches in DB. Provides value to Querysnapshot. Then setState makes searchlist start.
//? From searchList it goes to searchTile.
//! QuerySnapshot comes from texteditingcontroller, gets value at initiateStart, goes through searchList to searchTile, and shows value.
//? use createChatRoomAndStartConversation() to create a chatroom which accepts Map and Id. Id is type username_username2, and Map is Id and List of both users as added in Firebase

import 'package:chatapp/helper/constants.dart';
import 'package:chatapp/services/database.dart';
import 'package:chatapp/views/conversation_screen.dart';
import 'package:chatapp/widgits/widgits.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../TikTakToe/homePage.dart';
import '../TikTakToe/providers.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  DatabaseMethords databaseMethords = DatabaseMethords();
  TextEditingController search = TextEditingController();
  QuerySnapshot? searchSnapshot;

  Widget searchList() {
    return searchSnapshot != null
        ? ListView.builder(
            itemCount: searchSnapshot!.docs.length, //docoments changed to docs
            //whenever you have ListView inside Column, use ShrinkWrap
            shrinkWrap: true,
            itemBuilder: (context, index) {
              return searchTile(
                //name, email is key in Firebase
                userName: searchSnapshot!.docs[index]["name"],
                userEmail: searchSnapshot!.docs[index]["email"],
              );
            })
        : Container();
  }

  // Create Chatroom, send user to Conversation screen
  // If user array in Firebase contains the username then show
  createChatRoomAndStartConversation({String? userName}) {
    //? Here userName is raw username. eg:- RawTech, terminator etc.
    if (userName != Constants.myName) {
      
      //See bottommost function, you provide 2 string and it gives chatroomId
      String chatRoomId =
          getChatRoomId(userName!, Constants.myName); //!Generate unique id
      //returns eg:- rahul_mita or abhinav_shreya etc
      // Firestore has a users type string list
      List<String> users = [userName, Constants.myName];
      // String, dynamic is because in Firebase our Chatroom has an array and string
      Map<String, dynamic> chatRoomMap = {
        "users": users,
        "chatroomid":
            chatRoomId, //chatroomId needs to be same whenever we are Send Message and Recieve Message from the same user
      };
      DatabaseMethords().createChatRoom(chatRoomId, chatRoomMap);
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>
              HomePage(gameRoomId: chatRoomId)
                  // ConversationScreen(chatRoomId: chatRoomId)
                  ));
    } else {
      print("You cannot send message to yourself");
    }
  }

  initiateSearch() {
    databaseMethords.getUserByUsername(search.text).then((val) {
      //?this returns QuerySnapshot

      setState(() {
        // context.read<recieverNameProvider>().getRecieverName(val);
        searchSnapshot = val;
    // print('RECIEVERSSS');
    //     print(searchSnapshot!.docs[1]["name"]);
        // print(val);
      });
    });
  }

  Widget searchTile({String? userName, String? userEmail}) {
    // For Named Parameters we use {} inside ()
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                userName!,
                style: mediumTextFieldStyle(),
              ),
              Text(
                userEmail!,
                style: mediumTextFieldStyle(),
              ),
            ],
          ),
          Spacer(),
          GestureDetector(
            onTap: () {
        context.read<recieverNameProvider>().getRecieverName(userName);
              createChatRoomAndStartConversation(userName: userName);
            },
            child: Container(
              decoration: BoxDecoration(
                  color: Colors.blue, borderRadius: BorderRadius.circular(30)),
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: Text("Message", style: mediumTextFieldStyle()),
            ),
          )
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarMain(),
      body: Container(
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              color: Color(0x54FFFFFF),
              child: Row(
                children: [
                  Expanded(
                      child: TextField(
                          controller: search,
                          style: TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                              hintText: 'Search username',
                              hintStyle: TextStyle(color: Colors.white54),
                              border: InputBorder.none))),
                  GestureDetector(
                    onTap: () {
                      initiateSearch();
                    },
                    child: Container(
                        height: 40,
                        width: 40,
                        decoration: BoxDecoration(
                            gradient: LinearGradient(colors: const [
                              Color(0x36FFFFFF),
                              Color(0x0FFFFFFF)
                            ]),
                            borderRadius: BorderRadius.circular(40)),
                        padding: EdgeInsets.all(12),
                        child: Image.asset('assets/images/search_white.png')),
                  )
                ],
              ),
            ),
            searchList()
          ],
        ),
      ),
    );
  }
}

//Provide this Function 2 String and it will provide chatroomId
//! Generate unique ID
getChatRoomId(String recieversName, String myName) {
  // print(recieversName);
        // context.read<recieverNameProvider>().getRecieverName(val);
  print(getInitials(recieversName));
  int recieve = getInitials(recieversName).codeUnitAt(0);
  // print(getInitials(myName).codeUnitAt(0));
  print('SENDERS NAME');
  print(myName);
  print(getInitials(myName)); //! return null

  int my = getInitials(myName).codeUnitAt(0);
  print(my);
  print("$myName\_$recieversName");
  if (my >= recieve) {
    return "$myName\_$recieversName";
  } else
    return "$recieversName\_$myName";
  //String a = name of person you want to send message
  //String b = myName
  // if (a.substring(0, 1).codeUnitAt(0) > b.substring(0, 1).codeUnitAt(0)) {
  // return "$myName\_$recieversName";
  // } else {
  //   return "$a\_$b";
  // }
}

String getInitials(String bank_account_name) => bank_account_name.isNotEmpty
    ? bank_account_name.trim().split(' ').map((l) => l[0]).take(2).join()
    : '';
//? UTF-16 code generated by codeUnitAt(0) is eg:- 97,107 etc
//? return "$b\_$a"; => eg:- rahul_mita
//? return "$a\_$b"; => eg:- mita_rahul
//? so getChatRoomId is rahul_mita or mita_rahul
