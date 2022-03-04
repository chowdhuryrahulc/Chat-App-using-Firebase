import 'package:cloud_firestore/cloud_firestore.dart';

class TikTakToeDatabase {
  getTikTakToeData(String chatRoomId) async {
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
  sendTikTakToeData(String chatRoomId, messageMap) {
    //TODO COPY OF addCONVERSATIONMESSAGE
    FirebaseFirestore.instance
        .collection("GameRoom")
        .doc(chatRoomId)
        .collection("tikTakToe")
        //todo add or update
        .add(messageMap)
        .catchError((e) {});
  }

  sendGameButtonData(String chatRoomId, messageMap) {
    FirebaseFirestore.instance
        .collection("GameRoom")
        .doc(chatRoomId)
        .collection("buttonListData")
        //todo add or update
        .add(messageMap)
        .catchError((e) {
      print(e);
    });
  }

  updateGameButtonData(String chatRoomId, messageMap) {
    FirebaseFirestore.instance
        .collection("GameRoom")
        .doc(chatRoomId)
        .collection("buttonListData").doc()
        .update(messageMap);
  }
}
