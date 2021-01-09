import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttergg/constants.dart';
import 'package:fluttergg/pages/home.dart';
import 'package:google_fonts/google_fonts.dart';



import '../push_gen.dart';

final _firestore = Firestore.instance;
//FirebaseUser loggedsuser;

class ChatScreen extends StatefulWidget {
  static String id = 'chat_screen';
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final messageController = TextEditingController();
  //final _auth = FirebaseAuth.instance;

  String message;

//  void getCurrentUser() async {
//    try {
//      final currentuser = await _auth.currentUser();
//      if (currentuser != null) {
//        loggedsuser = currentuser;
//        print(loggedsuser.email);
//      }
//    } catch (e) {
//      print(e);
//    }
//  }

  void messageStream() async {
    await for (var snapshot in _firestore.collection('messages').snapshots()) {
      for (var message in snapshot.documents) {
        print(message.data);
      }
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //getCurrentUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: null,
        actions: <Widget>[
//          IconButton(
//              icon: Icon(Icons.close),
//              onPressed: () async {
////                messageStream();
////                _auth.signOut();
////
////                final SharedPreferences prefs =
////                await SharedPreferences.getInstance();
////                prefs.setString('username', null);
////
////                Navigator.pushNamed(context, WelcomeScreen.id);
//                //Implement logout functionality
//
//                print('pressed close');
//              }),
        ],
        title: Center(child: Text('Global Chat')),
        backgroundColor: Colors.black,
      ),
      body: SafeArea(
        child: Container(
          color: Colors.black.withOpacity(.9),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Container(
                decoration: kMessageContainerDecoration,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Expanded(
                      child: TextField(
                        style: TextStyle(color: Colors.white70),
                        controller: messageController,
                        onChanged: (value) {
                          message = value;
                          //Do something with the user input.
                        },
                        decoration: kMessageTextFieldDecoration,
                      ),
                    ),
                    FlatButton(
                      onPressed: () {
                        messageController.clear();
                        //Implement send functionality.
                        _firestore
                            .collection('messages')
                            .document(PushIdGenerator.generatePushChildName())
                            .setData({
                          'text': message,
                          'sender': currentUser.email,
                        });
                      },
                      child: Text(
                        'Send',
                        style: kSendButtonTextStyle,
                      ),
                    ),
                  ],
                ),
              ),
              MessagesStream(),
              SizedBox(
                height: 30,
              )

            ],
          ),
        ),
      ),
    );
  }
}

class MessagesStream extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _firestore.collection('messages').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final messages = snapshot.data.documents.reversed;
          List<MessageBubble> messageBubbles = [];
          for (var message in messages) {
            final messageText = message.data['text'];
            final messageSender = message.data['sender'];

            final curuser = currentUser.email;

            final messageBubble = MessageBubble();
            messageBubbles.add(MessageBubble(
              text: messageText,
              sender: messageSender,
              isme: curuser == messageSender,
            ));
          }
          return Expanded(
            child: ListView(
              reverse: true,
              padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
              children: messageBubbles,
            ),
          );
        }
        return Container();
      },
    );
  }
}

class MessageBubble extends StatelessWidget {
  final String sender;
  final String text;
  final bool isme;

  MessageBubble({this.text, this.sender, this.isme});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(5),
      child: Column(
        crossAxisAlignment:
        isme ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            sender,
            style: TextStyle(fontSize: 12, color: Colors.white70),
          ),
          Material(
            elevation: 5,
            borderRadius: isme
                ? BorderRadius.only(
              topLeft: Radius.circular(30),
              //topRight: Radius.circular(30),
              bottomLeft: Radius.circular(30),
              bottomRight: Radius.circular(30),
            )
                : BorderRadius.only(
              //topLeft: Radius.circular(30),
              topRight: Radius.circular(30),
              bottomLeft: Radius.circular(30),
              bottomRight: Radius.circular(30),
            ),
            color: isme ? Colors.lightBlueAccent : Colors.grey,
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
              child: Text(
                '$text',
                style: GoogleFonts.roboto(fontSize: 17),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
