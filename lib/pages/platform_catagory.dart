import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:fluttergg/widgets/header.dart';

import 'game_profile.dart';

class PlatfromCatagory extends StatefulWidget {
  PlatfromCatagory({this.id, this.link, this.pname});

  final String id;
  final String link;
  final String pname;


  @override
  _PlatfromCatagoryState createState() => _PlatfromCatagoryState();
}

class _PlatfromCatagoryState extends State<PlatfromCatagory> with TickerProviderStateMixin {
  TabController _tabController;
  int _activeTabIndex;

  List<String> a = ['pc','ps4'];


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //print('ID: ${widget.id}');
    _tabController = TabController(vsync: this, length: 3, initialIndex: 1);
    //print('${widget.pname}');


  }


  @override
  Widget build(BuildContext context) {
//    String a;
//    goto() {
////      Firestore.instance.collection('posts').getDocuments().then((QuerySnapshot snapshot) =>
////      snapshot.documents.forEach((DocumentSnapshot doc) {
////
////      })
////      );
//      return a;
//    }

//    print('val a  ' + widget.data);



    return Scaffold(
        backgroundColor: Colors.black54,
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(270),
          child: Stack(
            children: [
              AppBar(
                backgroundColor: Colors.black54,
                  bottom: PreferredSize(
                    preferredSize: Size.fromHeight(20),
                    child: Container(
                      color: Colors.black54.withOpacity(.9),
                      child: TabBar(
                        indicatorWeight: 6,
                        indicatorSize: TabBarIndicatorSize.tab,
                        controller: _tabController,
                        tabs: [
                          Tab(
                            icon: Icon(
                              Icons.info,
                              color:  Colors.white,
                            ),
//                            child: Text(
//                              'Tab1',
//                              style: TextStyle(fontSize: 20),
//                            ),
                          ),
                          Tab(
                            icon: Icon(
                              Icons.grid_on,
                              color: Colors.white,
                            ),
//                            child: Text(
//                              'Tab2',
//                              style: TextStyle(fontSize: 20),
//                            ),
                          ),
                          Tab(
                            icon: Icon(
                              Icons.image,
                              color: Colors.white,
                            ),
//                            child: Text(
//                              'Tab2',
//                              style: TextStyle(fontSize: 20),
//                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  flexibleSpace: Positioned.fill(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Expanded(
                            child: CachedNetworkImage(
                              imageUrl: widget.link,
                              placeholder: (context, url) => CircularProgressIndicator(),
                            ),
                          ),
                          Text(widget.pname,style: TextStyle(color: Colors.white,fontSize: 50),),
                        ],
                      ))),
            ],
          ),
        ),
        body: TabBarView(
          controller: _tabController,
          children: [
            StreamBuilder<QuerySnapshot>(
                stream:
            Firestore.instance
                .collection('games')
                //.where('ex', isEqualTo: widget.pname)
                .where('platform',arrayContainsAny: [widget.pname])
//                .where('platform1', isEqualTo: widget.pname)
                .snapshots(),

                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    //final List<String> lst=
                   // print('Snap:${snapshot.data.documents}');
                    return Padding(
                      padding: const EdgeInsets.only(top :8.0),
                      child: ListView(
                          children: snapshot.data.documents.map((doc) {
                     //       print('Snap:${doc.data['link']}');
                            return GestureDetector(

                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => GameProfile(
//                                              id: snapshot.data.documents[index]
//                                                  ['id'],
                                          link: doc['link'],
                                          name: doc['name'],
                                        )));
                              },


                              child: Container(
                                height: 250,
                                width: 300,
                                child: CachedNetworkImage(
                                  imageUrl: doc.data['link'],
                                  placeholder: (context, url) => CircularProgressIndicator(),
                                ),
                              ),
                            );
                          }).toList()),
                    );
                  }
                  return CircularProgressIndicator();
                }),
            SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(
                    height: 20,
                  ),
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left:30.0),
                        child: Text(
                          'About',style: TextStyle(fontSize: 20,color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: ClipRRect(
                      clipBehavior: Clip.antiAlias,
                      borderRadius: BorderRadius.only( topLeft: Radius.circular(10)),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.black54,

                          border: Border(
                            left: BorderSide(
                                color: Colors.greenAccent,
                                width: 5

                            ),
                            top: BorderSide(
                                color: Colors.greenAccent,
                                width: 5
                            ),

                          ),
                          //borderRadius: BorderRadius.all(Radius.circular(10)),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Center(
                            child: Text(
                              'Counter-Strike: Global Offensive (CS: GO) expands upon the team-based action gameplay that it pioneered when it was launched 19 years ago. CS: GO features new maps, characters, weapons, and game modes, and delivers updated versions of the classic CS content (de_dust2, etc.)."',
                              style: TextStyle(color: Color(0xFFFEFCD7 ), fontSize: 20),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left:15.0,right: 15),
                    child: Divider(
                      height: 10,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Image.network('https://images.alphacoders.com/519/thumb-1920-519792.jpg'),

                ],
              ),
            ),
            StreamBuilder<QuerySnapshot>(
                stream:
                Firestore.instance
                    .collection('games')
                    .where('ex', isEqualTo: widget.pname)
                // .where('platform',arrayContainsAny: [widget.pname])
//                .where('platform1', isEqualTo: widget.pname)
                    .snapshots(),

                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    //final List<String> lst=
                    //print('Snap:${snapshot.data.documents}');
                    return Padding(
                      padding: const EdgeInsets.only(top :8.0),
                      child: ListView(
                          children: snapshot.data.documents.map((doc) {
                          //  print('Snap:${doc.data['link']}');
                            return GestureDetector(

                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => GameProfile(
//                                              id: snapshot.data.documents[index]
//                                                  ['id'],
                                          link: doc['link'],
                                          name: doc['name'],
                                        )));
                              },


                              child: Container(
                                height: 250,
                                width: 300,
                                child: CachedNetworkImage(
                                  imageUrl: doc.data['link'],
                                  placeholder: (context, url) => CircularProgressIndicator(),
                                ),
                              ),
                            );
                          }).toList()),
                    );
                  }
                  return CircularProgressIndicator();
                }),

          ],
        ));
  }
}
