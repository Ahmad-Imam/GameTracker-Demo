import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttergg/pages/home.dart';
import 'package:fluttergg/pages/profile.dart';
import 'package:fluttergg/pages/timeline.dart';
import 'package:fluttergg/widgets/header.dart';

class ActivityFeed extends StatefulWidget {
  @override
  _ActivityFeedState createState() => _ActivityFeedState();
}

class _ActivityFeedState extends State<ActivityFeed> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: header(context, titleText: "User List"),
      backgroundColor: Colors.grey.withOpacity(.15),
      body: StreamBuilder<QuerySnapshot>(
        stream: Firestore.instance.collection('users').snapshots(),
        builder: (context, snapshot) {
          if(snapshot.hasData) {
//            snapshot.data.documents.forEach((e) {

              //  print(snapshot.data.documents.first.documentID);
              return ListView(

                children: snapshot.data.documents.map((e) => e.documentID==currentUser.id?
                Container() :
                    Padding(
                    padding: const EdgeInsets.all(20.0),
                child: RaisedButton(
                  color: Colors.lightBlueAccent.withOpacity(.9 ),
                  onPressed: ()
                  {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => Profile(
//                                              id: snapshot.data.documents[index]
//                                                  ['id'],
                              profileId: e.documentID,
                            )));
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        CircleAvatar(
                          backgroundImage: NetworkImage(e.data['photoUrl']),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(50,0,0,0),
                          child: Text("  ${e.data['displayName']}",
                            style: TextStyle(color: Colors.black),),
                        ),
                      ],
                    ),
                  ),
                ),
              )
                ).toList()

              );
          }
          return CircularProgressIndicator();
        }
      ),
    );
  }
}

class ActivityFeedItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Text('Activity Feed Item');
  }
}
