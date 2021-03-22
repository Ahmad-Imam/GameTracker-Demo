import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttergg/pages/home.dart';
import 'package:fluttergg/widgets/header.dart';
import 'package:google_fonts/google_fonts.dart';

import 'create_account.dart';
import 'game_profile.dart';

final usersRef = Firestore.instance.collection('users');

class Profile extends StatefulWidget {
  final String profileId;

  Profile({this.profileId});

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
//  Widget _images(DocumentSnapshot doc){
//    return Image.network(doc['link'],height: 300,width: 300,);
//  }

  @override
  Widget build(context) {
    return Scaffold(
      //appBar: header(context, titleText: "Timeline"),
      backgroundColor: Colors.grey.withOpacity(.15),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            StreamBuilder(
                stream: Firestore.instance
                    .collection('users')
                    .document(widget.profileId == null
                        ? currentUser.id
                        : widget.profileId)
                    .snapshots(),
                builder: (context, snapshot) {
                  print(
                      'asd   ${widget.profileId}  curruser  ${currentUser.id}');

                  if (snapshot.hasData) {
                    // print('kjasd + ${snapshot.data['displayName']}');
                    return Container(
                      height: MediaQuery.of(context).size.height * 0.40,
                      width: MediaQuery.of(context).size.width,
//                      color: Colors.white70,
                      child: Stack(
                        alignment: Alignment.topCenter,
                        children: [
                          Positioned(
                            child: Container(
                              color: Colors.white,
                              child: CachedNetworkImage(
                                imageUrl: '${snapshot.data['coverlink']}',
                                fit: BoxFit.fill,
                              ),
                            ),
                          ),
                          Positioned(
                            top: 180,
                            child: Stack(
                              children: [
                                CircleAvatar(
                                  radius: 40.0,
                                  backgroundColor: Colors.grey,
                                  backgroundImage: NetworkImage(
                                      '${snapshot.data['photoUrl']}'),
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(50, 60, 0, 0),
                                  child: GestureDetector(
                                    onTap: () {
                                      if (widget.profileId == null)
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    CreateAccount()));
                                    },
                                    child: Container(
                                        decoration: BoxDecoration(
                                            color: Colors.black,
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(10))),
                                        child: Icon(
                                          Icons.add_a_photo,
                                          color: Colors.white70,
                                        )),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Positioned(
                            top: 270,
                            child: Container(
                              child: Text(
                                snapshot.data['displayName'],
                                textAlign: TextAlign.center,
                                style: GoogleFonts.bitter(
                                    color: Colors.white, fontSize: 30),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  } else
                    return CircularProgressIndicator();
                }),
            Padding(
              padding: const EdgeInsets.fromLTRB(6, 0, 6, 0),
              child: Divider(
                thickness: .3,
                height: 15,
                color: Colors.grey,
              ),
            ),
            Text(
              'Added',
              style: GoogleFonts.bitter(fontSize: 30, color: Colors.white70),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(6, 0, 6, 0),
              child: Divider(
                thickness: .3,
                height: 15,
                color: Colors.grey,
              ),
            ),
            StreamBuilder<QuerySnapshot>(
                stream: Firestore.instance
                    .collection('users')
                    .document(widget.profileId == null
                        ? currentUser.id
                        : widget.profileId)
                    .collection('gameslist')
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    // print('Thisssss ${snapshot.data.documents.first.data}');
//                  return Text(
//                    'Timeline',
//                    style: TextStyle(fontSize: 150, color: Colors.white),
//                  ),
                    //snapshot.data.documents.forEach((doc) {
                    return Container(
                      width: 135 * snapshot.data.documents.length.toDouble(),
                      child: Card(
                        elevation: 3,
                        color: Colors.white70.withOpacity(.2),
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.height * 0.22,
                          child: ListView(
                            scrollDirection: Axis.horizontal,
                            children: snapshot.data.documents
                                .map(
                                  (e) => Padding(
                                    padding: snapshot.data.documents.length == 1
                                        ? const EdgeInsets.all(6.0)
                                        : const EdgeInsets.all(8.0),
                                    child: Material(
                                      shadowColor: Colors.black,
                                      elevation: 3,
                                      clipBehavior: Clip.antiAlias,
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(10),
                                      ),
                                      child: GestureDetector(
                                        onTap: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      GameProfile(
//                                              id: snapshot.data.documents[index]
//                                                  ['id'],
                                                        link: e['link'],
                                                        name: e['name'],
                                                      )));
                                        },
                                        child: Container(
                                          color: Colors.black,
//                                   clipBehavior: Clip.antiAlias,
                                          child: Image.network(
                                            e['link'],
//                                height: 40,
                                            width: 115,
                                            fit: BoxFit.fill,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                )
                                .toList(),
                          ),
                        ),
                      ),
                    );
                    // });
                    return Text('asd');
                  } else
                    return CircularProgressIndicator();
                }),
            Padding(
              padding: const EdgeInsets.fromLTRB(6, 0, 6, 0),
              child: Divider(
                thickness: .3,
                height: 15,
                color: Colors.grey,
              ),
            ),
            Text(
              'Completed',
              style: GoogleFonts.bitter(fontSize: 30, color: Colors.white70),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(6, 0, 6, 0),
              child: Divider(
                thickness: .3,
                height: 15,
                color: Colors.grey,
              ),
            ),
            StreamBuilder<QuerySnapshot>(
                stream: Firestore.instance
                    .collection('users')
                    .document(widget.profileId == null
                        ? currentUser.id
                        : widget.profileId)
                    .collection('comgameslist')
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    // print('This2 ${snapshot.data.documents.first.data}');
//                  return Text(
//                    'Timeline',
//                    style: TextStyle(fontSize: 150, color: Colors.white),
//                  ),
                    //snapshot.data.documents.forEach((doc) {
                    return Container(
                      width: 135 * snapshot.data.documents.length.toDouble(),
                      child: Card(
                        elevation: 3,
                        color: Colors.white70.withOpacity(.2),
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.height * 0.22,
                          child: ListView(
                            scrollDirection: Axis.horizontal,
                            children: snapshot.data.documents
                                .map(
                                  (e) => Padding(
                                    padding: snapshot.data.documents.length == 1
                                        ? const EdgeInsets.all(6.0)
                                        : const EdgeInsets.all(8.0),
                                    child: Material(
                                      shadowColor: Colors.black,
                                      elevation: 2,
                                      clipBehavior: Clip.antiAlias,
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(10),
                                      ),
                                      child: GestureDetector(
                                        onTap: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      GameProfile(
//                                              id: snapshot.data.documents[index]
//                                                  ['id'],
                                                        link: e['link'],
                                                        name: e['name'],
                                                      )));
                                        },
                                        child: Container(
                                          color: Colors.black,
//                                   clipBehavior: Clip.antiAlias,
                                          child: Image.network(
                                            e['link'],
//                                height: 40,
                                            width: 115,
                                            fit: BoxFit.fill,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                )
                                .toList(),
                          ),
                        ),
                      ),
                    );
                    // });
                    return Text('asd');
                  } else
                    return CircularProgressIndicator();
                }),
            Padding(
              padding: const EdgeInsets.fromLTRB(6, 0, 6, 0),
              child: Divider(
                thickness: .3,
                height: 15,
                color: Colors.grey,
              ),
            ),
            Text(
              'Unfinished',
              style: GoogleFonts.bitter(fontSize: 30, color: Colors.white70),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(6, 0, 6, 0),
              child: Divider(
                thickness: .3,
                height: 15,
                color: Colors.grey,
              ),
            ),
            StreamBuilder<QuerySnapshot>(
                stream: Firestore.instance
                    .collection('users')
                    .document(widget.profileId == null
                        ? currentUser.id
                        : widget.profileId)
                    .collection('halfcomgameslist')
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    //print('This ${snapshot.data}');
//                  return Text(
//                    'Timeline',
//                    style: TextStyle(fontSize: 150, color: Colors.white),
//                  ),
                    //snapshot.data.documents.forEach((doc) {
                    return Container(
                      width: 135 * snapshot.data.documents.length.toDouble(),
                      child: Card(
                        elevation: 3,
                        color: Colors.white70.withOpacity(.2),
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.height * 0.22,
                          child: ListView(
                            scrollDirection: Axis.horizontal,
                            children: snapshot.data.documents
                                .map(
                                  (e) => Padding(
                                    padding: snapshot.data.documents.length == 1
                                        ? const EdgeInsets.all(6.0)
                                        : const EdgeInsets.all(8.0),
                                    child: Material(
                                      shadowColor: Colors.black,
                                      elevation: 2,
                                      clipBehavior: Clip.antiAlias,
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(10),
                                      ),
                                      child: Hero(
                                        tag: 'add',
                                        child: GestureDetector(
                                          onTap: () {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        GameProfile(
//                                              id: snapshot.data.documents[index]
//                                                  ['id'],
                                                          link: e['link'],
                                                          name: e['name'],
                                                        )));
                                          },
                                          child: Container(
                                            color: Colors.black,
//                                   clipBehavior: Clip.antiAlias,
                                            child: Image.network(
                                              e['link'],
//                                height: 40,
                                              width: 115,
                                              fit: BoxFit.fill,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                )
                                .toList(),
                          ),
                        ),
                      ),
                    );
                    // });
                    return Text('asd');
                  } else
                    return CircularProgressIndicator();
                }),
            Padding(
              padding: const EdgeInsets.fromLTRB(6, 0, 6, 0),
              child: Divider(
                thickness: .3,
                height: 15,
                color: Colors.grey,
              ),
            ),
//          SingleChildScrollView(
//            scrollDirection: Axis.horizontal,
//            child: StreamBuilder<QuerySnapshot>(
//                stream: Firestore.instance.collection('users').document(currentUser.id).collection('gameslist').snapshots(),
//                builder: (context, snapshot) {
//                  if (snapshot.hasData) {
////                  return Text(
////                    'Timeline',
////                    style: TextStyle(fontSize: 150, color: Colors.white),
////                  ),
//                    snapshot.data.documents.forEach((doc) {
//                      print(doc.documentID);
//                    });
//                    return Row(
//                      children: [
//                        Container(
//                          width: 150,
//                          height: 200,
//                          decoration: BoxDecoration(
//                              borderRadius: BorderRadius.all(Radius.circular(100))
//                          ),
//                          child: Card(
//
//                              child: Container(
//                                color: Colors.red,
//                              )
////                      Image.network(
////                        '${snapshot.data.documents.first.data['link']}',
////                        //width: 250,
////                        //height: 300,
////                        fit: BoxFit.fill,
////                        //style: TextStyle(fontSize: 50, color: Colors.white),
////                      ),
//                          ),
//                        ),
//                        Container(
//                          width: 150,
//                          height: 200,
//                          decoration: BoxDecoration(
//                              borderRadius: BorderRadius.all(Radius.circular(100))
//                          ),
//                          child: Card(
//
//                              child: Container(
//                                color: Colors.blue,
//                              )
////                      Image.network(
////                        '${snapshot.data.documents.first.data['link']}',
////                        //width: 250,
////                        //height: 300,
////                        fit: BoxFit.fill,
////                        //style: TextStyle(fontSize: 50, color: Colors.white),
////                      ),
//                          ),
//                        ),
//                        Container(
//                          width: 150,
//                          height: 200,
//                          decoration: BoxDecoration(
//                              borderRadius: BorderRadius.all(Radius.circular(100))
//                          ),
//                          child: Card(
//
//                              child: Container(
//                                color: Colors.green,
//                              )
////                      Image.network(
////                        '${snapshot.data.documents.first.data['link']}',
////                        //width: 250,
////                        //height: 300,
////                        fit: BoxFit.fill,
////                        //style: TextStyle(fontSize: 50, color: Colors.white),
////                      ),
//                          ),
//                        ),
//                      ],
//                    );
//
//                  }
//                  else
//                    return CircularProgressIndicator();
//                }
//
//            ),
//          ),

//              Text(
//                'Complete',
//                style: TextStyle(fontSize: 200, color: Colors.white),
//              ),
//              Text(
//                'Unfinished',
//                style: TextStyle(fontSize: 300, color: Colors.white),
//              ),
//              Text(
//                'Timeline',
//                style: TextStyle(fontSize: 400, color: Colors.white),
//              ),
          ],
        ),
      ),
    );
  }
}
