// ignore_for_file: deprecated_member_use, prefer_const_constructors, prefer_typing_uninitialized_variables, avoid_print

import 'dart:math';
import 'package:chatapp/TikTakToe/TikTakToeDatabase.dart';
import 'package:chatapp/TikTakToe/providers.dart';
import 'package:chatapp/helper/constants.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'customDialog.dart';
import 'gameButton.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key, required this.gameRoomId}) : super(key: key);
  final String gameRoomId;

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<GameButton>? buttonsList;
  List<int> player1 = [];
  List<int> player2 = [];
  String activePlayer = Constants.myName;
  TikTakToeDatabase tikTakToeDatabase = TikTakToeDatabase();
  Stream? getTikTakToeDataStream;

  @override
  void initState() {
    buttonsList = doInit();

    //TODO FOR tIKtAKtOE STREAM
    // tikTakToeDatabase.getTikTakToeData(widget.gameRoomId).then((value) {
    //   setState(() {
    //     getTikTakToeDataStream = value;
    //   });
    // });
    super.initState();
  }

// FOR MULTIPLAYER
  // void sendGameInformation(GameButton gameButton) {}

  doInit() {
    //TODO player2 is the other person.
    // Function called from initState
    player1 = [];
    player2 = [];
    // activePlayer = 1;
    //! ActiveButton toggles btw 1 and 2 in void playgame setState.
    List<GameButton> gameButtons = [
      // Used to uniquely identiy the 9 GameButton.
      GameButton(id: 1),
      GameButton(id: 2),
      GameButton(id: 3),
      GameButton(id: 4),
      GameButton(id: 5),
      GameButton(id: 6),
      GameButton(id: 7),
      GameButton(id: 8),
      GameButton(id: 9),
    ];
    Map<String, dynamic> activePlayerMap = {
        'activePlayer': activePlayer
      };
    tikTakToeDatabase.saveActivePlayerInFirestore(
            activePlayerMap, widget.gameRoomId);
       
    // int id = 0;
    String text = '';
    // Color bg = Colors.grey;
    String bg = 'grey';
    bool enabled = false;

    for (var id = 1; id < 10; id++) {
      Map<String, dynamic> gameMap = {
        'id': id,
        'text': text,
        'background': bg,
        'enabled': enabled
      };
      tikTakToeDatabase.sendGameButtonData(widget.gameRoomId, gameMap, id);
    }

    tikTakToeDatabase.getButtonData(widget.gameRoomId).then((value) {
      setState(() {
        getTikTakToeDataStream = value;
      });
    });

    return gameButtons;
  }

  void playGame(GameButton gameButton, int id) {
    setState(() {
      // when buttonPressed, it sets the State
      // to red color, X,
      if (activePlayer == Constants.myName) {
        // gameButton.text = "X";
        // gameButton.bg = Colors.red;
        // After player 1, player 2 gets chance
        // Adding id to the list.
        // player1.add(gameButton.id);

        //TODO BUTTON DATA UPDATING
        Map<String, dynamic> updateButtonDataMap = {
          'id': id,
          'text': "X",
          'background': 'red',
          'enabled': gameButton.enabled
        };
        tikTakToeDatabase.updateGameButtonData(
            widget.gameRoomId, updateButtonDataMap, gameButton.id);

        //TODO UPDATE IN FIRESTORE.
        Map<String, List> playersListMap = {
          activePlayer.toString(): player1,
        };
        tikTakToeDatabase.sendTikTakToeData(widget.gameRoomId, playersListMap);

        activePlayer = Provider.of<recieverNameProvider>(context, listen: false)
            .recieverName;
        tikTakToeDatabase.updateActivePlayerInFirestore(
            activePlayer, widget.gameRoomId);
        //context.watch<recieverNameProvider>().recieverName;
      }
      // else {
      //   // when player2 plays.
      //   gameButton.text = "0";
      //   gameButton.bg = Colors.black;
      //   activePlayer = 1;
      //   // player2.add(gameButton.id);
      // }
      // gameButton.enabled = false; // so that it is not played again.
      // int winner = checkWinner();
      // if (winner == -1) {
      //   // -1 by default.
      //   // .every means we have filled all the boxes.
      //   // means game is compleate.
      //   if (buttonsList!.every((p) => p.text != "")) {
      //     showDialog(
      //         context: context,
      //         builder: (_) => CustomDialog("Game Tied",
      //             "Press the reset button to start again.", resetGame));
      //   } else {
      //     // if there is a blank, means game is still going on. means autoplay.
      //     activePlayer == 2 ? autoPlay() : null;
      //     // Active player is 2, means 2 is playing.
      //   }
      // }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Tic Tac Toe"),
        ),
        body: StreamBuilder(
            //TODO TIKTOKDATA
            stream: getTikTakToeDataStream,
            builder: (context, AsyncSnapshot snapshot) {
              if (snapshot.hasData) {
                // print(snapshot.data.docs[2].data()['background'] ?? 'ggg');
                return Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Expanded(
                      child: GridView.builder(
                          padding: const EdgeInsets.all(10.0),
                          // GriDelegate controlls the layout of GridView
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                                  //TO Change Size here
                                  crossAxisCount: 3,
                                  childAspectRatio: 1.0,
                                  crossAxisSpacing: 9.0,
                                  mainAxisSpacing: 9.0),
                          itemCount: snapshot.data.docs.length, // 9 buttons
                          itemBuilder: (context, i) {
                            // print('DATAAAA');
                            // print(snapshot.data.docs[i].data()['enabled']);
                            return SizedBox(
                              width: 100.0,
                              height: 100.0,
                              child: RaisedButton(
                                padding: const EdgeInsets.all(8.0),
                                // if enabled, call a function
                                onPressed:
                                    snapshot.data.docs[i].data()['enabled'] ==
                                            false
                                        ? () {
                                            print('ONPRESSED INT ID');
                                            print(i);
                                            playGame(buttonsList![i], i);
                                          }
                                        : null,
                                child: Text(
                                  // Text innitially null
                                  //TODO update from snapshot
                                  // buttonsList![i].text,
                                  snapshot.data.docs[i].data()['text'],
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 20.0),
                                ),
                                // Innitially grey
                                //TODO need a ternary operator
                                color: snapshot.data.docs[i]
                                            .data()['background'] ==
                                        'grey'
                                    ? Colors.grey
                                    : Colors.red,
                                disabledColor: snapshot.data.docs[i]
                                            .data()['background'] ==
                                        'grey'
                                    ? Colors.grey
                                    : Colors.red,
                              ),
                            );
                          }),
                    ),
                    RaisedButton(
                      child: Text(
                        "Reset",
                        style: TextStyle(color: Colors.white, fontSize: 20.0),
                      ),
                      color: Colors.red,
                      padding: const EdgeInsets.all(20.0),
                      onPressed: resetGame,
                    )
                  ],
                );
              } else
                return Container();
            }));
  }

//TODO no need, player 2 will work in firebase.
  void autoPlay() {
    var emptyCells = [];
    var list = List.generate(9, (i) => i + 1);
    for (var cellID in list) {
      if (!(player1.contains(cellID) || player2.contains(cellID))) {
        emptyCells.add(cellID);
      }
    }

    var r = Random();
    var randIndex = r.nextInt(emptyCells.length - 1);
    var cellID = emptyCells[randIndex];
    int i = buttonsList!.indexWhere((p) => p.id == cellID);
    playGame(buttonsList![i], i);
  }

// Simple
  int checkWinner() {
    var winner = -1;
    //! Player1 & Player2 Contains list of which button he has tapped
    // winner = 1 or 2 if player wins.
    // if not completed, winner = -1
    if (player1.contains(1) && player1.contains(2) && player1.contains(3)) {
      winner = 1;
    }
    if (player2.contains(1) && player2.contains(2) && player2.contains(3)) {
      winner = 2;
    }

    // row 2
    if (player1.contains(4) && player1.contains(5) && player1.contains(6)) {
      winner = 1;
    }
    if (player2.contains(4) && player2.contains(5) && player2.contains(6)) {
      winner = 2;
    }

    // row 3
    if (player1.contains(7) && player1.contains(8) && player1.contains(9)) {
      winner = 1;
    }
    if (player2.contains(7) && player2.contains(8) && player2.contains(9)) {
      winner = 2;
    }

    // col 1
    if (player1.contains(1) && player1.contains(4) && player1.contains(7)) {
      winner = 1;
    }
    if (player2.contains(1) && player2.contains(4) && player2.contains(7)) {
      winner = 2;
    }

    // col 2
    if (player1.contains(2) && player1.contains(5) && player1.contains(8)) {
      winner = 1;
    }
    if (player2.contains(2) && player2.contains(5) && player2.contains(8)) {
      winner = 2;
    }

    // col 3
    if (player1.contains(3) && player1.contains(6) && player1.contains(9)) {
      winner = 1;
    }
    if (player2.contains(3) && player2.contains(6) && player2.contains(9)) {
      winner = 2;
    }

    //diagonal
    if (player1.contains(1) && player1.contains(5) && player1.contains(9)) {
      winner = 1;
    }
    if (player2.contains(1) && player2.contains(5) && player2.contains(9)) {
      winner = 2;
    }

    if (player1.contains(3) && player1.contains(5) && player1.contains(7)) {
      winner = 1;
    }
    if (player2.contains(3) && player2.contains(5) && player2.contains(7)) {
      winner = 2;
    }

    if (winner != -1) {
      if (winner == 1) {
        showDialog(
            context: context,
            builder: (_) => CustomDialog("Player 1 Won",
                "Press the reset button to start again.", resetGame));
      } else {
        showDialog(
            context: context,
            builder: (_) => CustomDialog("Player 2 Won",
                "Press the reset button to start again.", resetGame));
      }
    }

    return winner;
  }

  void resetGame() {
    buttonsList = doInit();
    // if (Navigator.canPop(context)) Navigator.pop(context);
    // setState(() {
    //   //! doinit will reset the game
    //   //! by setting player1 and player2 list to null
    //   buttonsList = doInit();
    // });
  }
}
