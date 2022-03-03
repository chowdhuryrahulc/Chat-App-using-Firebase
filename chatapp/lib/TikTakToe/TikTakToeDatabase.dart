import 'package:cloud_firestore/cloud_firestore.dart';

class TikTakToeDatabase {
  getTikTakToeData(String chatRoomId)async{
    //TODO COPY OF GETCONVERSATIONMESSAGE
      // Gives stream of database data
    return await FirebaseFirestore.instance
        .collection("GameRoom")
        .doc(chatRoomId)
        .collection("tikTakToeDynamic")
        // .orderBy("time", descending: false)
        .snapshots();
  }

//TODO messageMap needs to change to the TikTakToe game
sendTikTakToeData(String chatRoomId, messageMap){
    //TODO COPY OF addCONVERSATIONMESSAGE
    FirebaseFirestore.instance
        .collection("GameRoom")
        .doc(chatRoomId)
        .collection("tikTakToeDynamic")
        .add(messageMap)
        .catchError((e) {
    });

}

}