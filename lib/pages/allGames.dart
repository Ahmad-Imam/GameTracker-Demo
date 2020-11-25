import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttergg/widgets/header.dart';

import 'game_profile.dart';
import 'home.dart';

class AllGames extends StatefulWidget {
  @override
  _AllGamesState createState() => _AllGamesState();
}

class _AllGamesState extends State<AllGames> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: header(context, titleText: "All Games"),
      backgroundColor: Colors.black54,
      body: StreamBuilder<QuerySnapshot>(
          stream: Firestore.instance.collection('games').snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
//            snapshot.data.documents.forEach((e) {
              //  print(snapshot.data.documents.first.documentID);
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Material(
                  color: Colors.grey.withOpacity(.1),
                  shadowColor: Colors.black,
                  elevation: 2,
                  clipBehavior: Clip.antiAlias,
                  borderRadius: BorderRadius.all(
                    Radius.circular(10),
                  ),
                  child: Card(
                    color: Colors.grey.withOpacity(.1),
                    child: GridView.count(
                        crossAxisCount: 2,
                        children: snapshot.data.documents
                            .map(
                              (e) => Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Material(

                              shadowColor: Colors.black,
                              elevation: 2,
                              clipBehavior: Clip.antiAlias,
                              borderRadius: BorderRadius.all(
                                Radius.circular(10),
                              ),

                              child: GestureDetector(
                                onTap: ()
                                {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => GameProfile(
//                                              id: snapshot.data.documents[index]
//                                                  ['id'],
                                            link: e.data['link'],
                                            name: e.data['name'],
                                          )));
                                },
                                child: Container(
                                  color: Colors.grey.withOpacity(.1),
                                  child: Image.network(e.data['link'],
                                    fit: BoxFit.fill,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        )
                            .toList()),
                  ),
                ),
              );
            }
            return CircularProgressIndicator();
          }),
    );
  }
}
