// ignore_for_file: prefer_const_constructors, non_constant_identifier_names
//TODO UNDERSTOOD......

//! ChatStream gets value from initState(). Snapshots from getConversationMessage()
//! If Stream has value, then through chatMessageList() we make ListViewBuilder which has a MessageTile to show Messages.
//! Through above process we show Messages from Firestore using Streambuilder
//! initState() => Database: getConverstionMessage() => chatMessageList() => ListViewBuilder() => MessageTile()

//! To send message, Database: addConversationMessage()
//! Always use Map to add data to Firebase

import 'package:chatapp/helper/constants.dart';
import 'package:chatapp/services/database.dart';
import 'package:chatapp/widgits/widgits.dart';
import 'package:flutter/material.dart';

class ConversationScreen extends StatefulWidget {
  const ConversationScreen({Key? key, required this.chatRoomId})
      : super(key: key);
  final String chatRoomId;

  @override
  _ConversationScreenState createState() => _ConversationScreenState();
}

class _ConversationScreenState extends State<ConversationScreen> {
  DatabaseMethords databaseMethords = DatabaseMethords();
  TextEditingController message = TextEditingController();
  Stream? chatMessageStream;

  Widget ChatMessageList() {
    //Real time Chat. Thats why StreamBuilder
    return StreamBuilder(
        stream: chatMessageStream, //TODO stream to get TikTakToe data
        //! Where is the stream comming from. Db methord?
        builder: (context, AsyncSnapshot snapshot) {
          return snapshot.hasData
              ? ListView.builder(
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    return MessageTile(
                        snapshot.data!.docs[index].data()["message"],
                        message: snapshot.data!.docs[index].data()["message"],
                        isSendByMe:
                            snapshot.data!.docs[index].data()["sendBy"] ==
                                Constants.myName);
                  })
              : Container();
        });
  }

  sendMessage() { //TODO in button TikTakToe
    if (message.text.isNotEmpty) {
      Map<String, dynamic> messageMap = {
        //Depends on what you have written in Firestore
        // To save data in Firestore
        "message": message.text,
        "sendBy": Constants.myName,
        "time": DateTime.now().millisecondsSinceEpoch,
      };
      databaseMethords.addConversationMessage(widget.chatRoomId, messageMap);
      message.text = "";
    }
  }

  @override
  void initState() {
    databaseMethords.getConversationMessage(widget.chatRoomId).then((value) {
      setState(() {
        chatMessageStream = value;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: appBarMain(),
        body: Container(
          child: Stack(
            //box goes above the keyboard. Thats why Stack
            children: [
              ChatMessageList(), //TODO TIKTAKTOE game
              Container(
                alignment: Alignment.bottomCenter,
                child: Container(
                  // BottomTextField
                  padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                  color: Color(0x54FFFFFF),
                  child: Row(
                    children: [
                      Expanded(
                          child: TextField(
                              controller: message,
                              style: TextStyle(color: Colors.white),
                              decoration: InputDecoration(
                                  hintText: 'Message...',
                                  hintStyle: TextStyle(color: Colors.white54),
                                  border: InputBorder.none))),
                      GestureDetector(
                        onTap: () {
                          sendMessage(); //TODO in button TikTakToe
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
                            child: Image.asset('assets/images/send.png')),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}

class MessageTile extends StatelessWidget {
  const MessageTile(data,
      {Key? key, required this.message, required this.isSendByMe})
      : super(key: key);
  final String message;
  final bool isSendByMe;
  //SendbyMe = true means blue

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
          left: isSendByMe ? 0 : 24, right: isSendByMe ? 24 : 0),
      margin: EdgeInsets.symmetric(vertical: 8),
      width: MediaQuery.of(context).size.width,
      alignment: isSendByMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: isSendByMe
                  ? [const Color(0xff007EF4), const Color(0xff2A75BC)]
                  : [const Color(0x1AFFFFFF), const Color(0x1AFFFFFF)],
            ),
            borderRadius: isSendByMe
                ? BorderRadius.only(
                    topLeft: Radius.circular(23),
                    topRight: Radius.circular(23),
                    bottomLeft: Radius.circular(23),
                  )
                : BorderRadius.only(
                    topLeft: Radius.circular(23),
                    topRight: Radius.circular(23),
                    bottomRight: Radius.circular(23),
                  )),
        child: Text(
          message,
          style: TextStyle(color: Colors.white, fontSize: 17),
        ),
      ),
    );
  }
}
