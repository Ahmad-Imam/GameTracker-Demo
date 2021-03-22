import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:fluttergg/pages/game_profile.dart';
import 'package:fluttergg/widgets/header.dart';

class Catagory extends StatefulWidget {
  Catagory({this.tname, this.link, this.pname});

  final String tname;
  final String link;
  final String pname;

  @override
  _CatagoryState createState() => _CatagoryState();
}

class _CatagoryState extends State<Catagory> with TickerProviderStateMixin {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //print('ID: ${widget.id}');
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
        body: CustomScrollView(
          slivers: [
            SliverAppBar(
              backgroundColor: Colors.grey.withOpacity(.1),
              pinned: true,
              expandedHeight: 200.0,
              title: Center(child: Text('Catagory')),
              flexibleSpace: FlexibleSpaceBar(
                background: Hero(
                  tag: 'hero',
                  child: Column(
                    children: [
                      Expanded(
                        child: CachedNetworkImage(
                          imageUrl: widget.link,
                          placeholder: (context, url) =>
                              CircularProgressIndicator(),
                        ),
                      ),
                      Text(
                        widget.tname,
                        style: TextStyle(color: Colors.white, fontSize: 50),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            //Text('vavasfaf',style: TextStyle(color: Colors.white,fontSize: 100),),

//        SliverList(
//          delegate:
//          SliverChildListDelegate([Text('vavasfaf',style: TextStyle(color: Colors.white,fontSize: 50),),]),
//        ),
            StreamBuilder<QuerySnapshot>(
                stream: Firestore.instance
                    .collection('games')
                    .where('type', arrayContainsAny: [widget.tname])
                    //.where('platform', isEqualTo: widget.pname)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
//                   QuerySnapshot snap= Firestore.instance.collection('games').where('type',isEqualTo: widget.id).getDocuments();
                    //final List<String> lst=
                    //print('sbap:${snapshot.data}');
                    return SliverList(
                      delegate: SliverChildBuilderDelegate((context, index) {
                        return Container(
                          color: Colors.grey.withOpacity(.1),
                          child: Column(children: [
//                              Container(
//                                  height: 200,
//                                  width: 200,
//                                  child: Text('vavasfaf',style: TextStyle(color: Colors.white,fontSize: 50),)),
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => GameProfile(
//                                              id: snapshot.data.documents[index]
//                                                  ['id'],
                                              link: snapshot.data
                                                  .documents[index]['link'],
                                              name: snapshot.data
                                                  .documents[index]['name'],
                                            )));
                              },
                              child: Container(
                                height: 250,
                                width: 350,
                                child: Column(
                                  children: [
                                    CachedNetworkImage(
                                      imageUrl: snapshot.data.documents[index]
                                          ['link'],
                                      placeholder: (context, url) =>
                                          CircularProgressIndicator(),
                                      fit: BoxFit.cover,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ]),
                        );
                      },
                          childCount: snapshot.hasData
                              ? snapshot.data.documents.length
                              : 0),
                    );
                  }
                  return SliverList(
                    delegate:
                        SliverChildListDelegate([CircularProgressIndicator()]),
                  );
                }),
          ],
        ));
  }
}
