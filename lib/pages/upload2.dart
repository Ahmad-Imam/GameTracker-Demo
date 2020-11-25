import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:fluttergg/widgets/header.dart';

class Upload2 extends StatefulWidget {
  Upload2({this.id, this.link});

  final String id;
  final String link;

  @override
  _Upload2State createState() => _Upload2State();
}

class _Upload2State extends State<Upload2> with TickerProviderStateMixin {
  TabController _tabController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print('ID: ${widget.id}');
    _tabController = TabController(vsync: this, length: 2, initialIndex: 1);
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

    TabController asdf;
    return Scaffold(
        backgroundColor: Colors.black54,
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(200),
          child: AppBar(
            backgroundColor: Colors.black,
            flexibleSpace: Image.network(widget.link,fit: BoxFit.fill,),
            bottom: TabBar(
              controller: _tabController,
              tabs: [
                Tab(
                  child: Text(
                    'asdasdva',style: TextStyle(fontSize: 20),
                  ),
                ),
                Tab(
                  child: Text(
                    'hdfsa',style: TextStyle(fontSize: 20),
                  ),
                )
              ],

            ),
          ),
        ),
        body: TabBarView(
          controller: _tabController,
          children: [
            StreamBuilder<QuerySnapshot>(
                stream: Firestore.instance
                    .collection('games')
                    .where('type', isEqualTo: widget.id)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    //final List<String> lst=
                    print('Snap:${snapshot.data}');
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ListView(
                          children: snapshot.data.documents.map((doc) {
                            return Container(
                              child: Image.network(
                                doc.data['link'],
                                fit: BoxFit.fill,
                              ),
                            );
                          }).toList()),
                    );
                  }
                  return CircularProgressIndicator();
                }),
            Text('test',style: TextStyle(color: Colors.white,fontSize: 100),),
          ],
        )
    );
  }
}
