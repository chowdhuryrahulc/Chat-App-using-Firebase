/*
//update is left. 
//in sending, we are always adding a new list, and not updating.
//Problem: First time add, then update.
// Problem: Should update in the same place as in add. 
//     But how did chat app did this?
//     They only added. Did the Same.

RECIEVING:
  only stream will be recieved in streamBuilder, and nothing else.
  Colors etc should come from Firebase data.

player1 list checks who is the winner. 
Colors is not controlled from PlayersList
Q) What controlls that? GameButton.
  setState of gameButton[i] controlls Colors
Q) so should we change the type of data send? to what?

Problem: send buttonList to Firebase and keep updating.
1. in initState
    Problem: Send all the data, not single. Need for loop perhaps.

2. update


*/