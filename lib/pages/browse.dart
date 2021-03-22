import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttergg/pages/home.dart';
import 'package:fluttergg/pages/catagory.dart';
import 'package:fluttergg/pages/platform_catagory.dart';
import 'package:fluttergg/pages/upload2.dart';
import 'package:fluttergg/pages/game_profile.dart';
import 'package:fluttergg/widgets/header.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:cached_network_image/cached_network_image.dart';

import 'package:animations/animations.dart';

class Browse extends StatefulWidget {
  @override
  _BrowseState createState() => _BrowseState();
}

class _BrowseState extends State<Browse> {


  int ab;
  @override
  void initState() {
    super.initState();
  }

  Widget _cont(DocumentSnapshot snapshot) {
    return Container(
      child: Text(
        snapshot.data['link'],
        style: TextStyle(color: Colors.white, fontSize: 20),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
//    dynamic aa = '45';

//  final a = postref.map((user) =>user["link"] ).toList().toString();

    return Scaffold(
      appBar: header(context, titleText: "Browse"),
      backgroundColor: Colors.grey.withOpacity(.15),
      body: Column(
        children: [
          Expanded(
            child: Container(
              height: 300,
              width: 500,
              child: StreamBuilder<QuerySnapshot>(
                  stream: Firestore.instance.collection('posts').snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return Hero(
                        tag: 'hero',
                        child: Swiper(
                          autoplay: true,
                          scrollDirection: Axis.vertical,
                          //autoplay: true,
                          itemBuilder: (BuildContext context, int index) {
                            ab=index;
                            //index==1?print(index):print('adsad'+index.toString());
                            /*aa = snapshot.data.documents[index]['link'];
                              print('aa: $aa');*/
                            return Container(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Expanded(
                                    child: Container(
                                      width: 200,
                                      height: 200,
                                      child: CachedNetworkImage(
                                        imageUrl: snapshot.data.documents[index]['link'],
                                        placeholder: (context, url) => CircularProgressIndicator(),
                                      ),
                                    ),
                                  ),
                                  Text(  ab==index?
                                    '${snapshot.data.documents[index]['tname']}':'vsdf',
                                    style: TextStyle(color: Colors.white,fontSize: 20),
                                  )
                                ],
                              ),
                            );
                          },
                          itemCount: snapshot.data.documents.length,
//                        pagination: SwiperPagination(),
                          layout: SwiperLayout.DEFAULT,

                          //itemWidth: 500,
                          //itemHeight: 300,
                          onTap: (index) {
//                          print(index);

                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Catagory(
                                          tname: snapshot.data.documents[index]
                                              ['tname'],
                                          link: snapshot.data.documents[index]
                                              ['link'],
                                        )));
                          },
                        ),
                      );
                    }
                    return CircularProgressIndicator();
                  }),
            ),
          ),
          SizedBox(
            height: 100,
          ),
          Container(
            height: 300,
            width: 500,
            child: StreamBuilder<QuerySnapshot>(
                stream: Firestore.instance.collection('platform').snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return Hero(
                      tag: 'hero1',
                      child: Swiper(
                        autoplay: true,
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (BuildContext context, int index) {
                          ab=index;
                          /*aa = snapshot.data.documents[index]['link'];
                            print('aa: $aa');*/
                          return Container(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Expanded(
                                  child: Container(
                                    height:200,
                                    width: 200,
                                    child: CachedNetworkImage(
                                      imageUrl: snapshot.data.documents[index]['link'],
                                      placeholder: (context, url) => CircularProgressIndicator(),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 20,
                                ),

                              ],
                            ),
                          );
                        },
                        itemCount: snapshot.data.documents.length,
//                        pagination: SwiperPagination(),
                        layout: SwiperLayout.DEFAULT,

                        itemWidth: 500,
                        itemHeight: 300,
                        onTap: (index) {
//                          print(index);

                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => PlatformCatagory(
                                    pname: snapshot.data.documents[index]
                                    ['pname'],
                                    link: snapshot.data.documents[index]
                                    ['link'],
                                  )));
                        },
                      ),
                    );
                  }
                  return CircularProgressIndicator();
                }),
          ),
        ],
      ),
    );
  }
}

class UserResult extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Text("User Result");
  }
}
