import 'dart:ui';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:fluttergg/pages/home.dart';
import 'package:fluttergg/widgets/header.dart';
import 'package:configurable_expansion_tile/configurable_expansion_tile.dart';
import 'package:expansion_tile_card/expansion_tile_card.dart';
import 'package:google_fonts/google_fonts.dart';

class GameProfile extends StatefulWidget {
  GameProfile({this.id, this.link, this.name});

  final String id;
  final String link;
  final String name;

  @override
  _GameProfileState createState() => _GameProfileState();
}

class _GameProfileState extends State<GameProfile>
    with TickerProviderStateMixin {
  TabController _tabController;
  int _activeTabIndex;

  bool add_game_list_check_value = false;

  bool main_game_check_value = false;
  bool dlc_game_check_value = false;

  int maincom=0;
  int dlccom=0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //print('ID: ${widget.id}');
    _tabController = TabController(vsync: this, length: 2, initialIndex: 1);
  }

//  void addToList(value) {
//    setState(() {
//      add_game_list_check_value = value;
//      print(value);
//    });
//  }

  Map<String, bool> userlist = Map<String, bool>();
  Map<String, bool> comuserlist = Map<String, bool>();

  bool toUpdate = false;
  bool toUpdate2 = false;
  Future mainComplete(AsyncSnapshot snapshot) async {
    print('maincom maincom $maincom dlccom $dlccom');
    if (main_game_check_value == true) {
       // print('main update');
//        await Firestore.instance
//            .collection('users')
//            .document(currentUser.id)
//            .collection('comgameslist')
//            .document(snapshot.data.documents[0].documentID)
//            .setData({
//          'id': snapshot.data.documents[0].documentID,
//          'name': snapshot.data.documents[0]['name'],
//          'link': snapshot.data.documents[0]['link']
//        });
        await Firestore.instance
            .collection('games')
            .document(snapshot.data.documents[0].documentID.toString())
            .updateData({
          'mainGameUsers': userlist = {
            currentUser.id: true,
          },
        });
    }
    else{
      await Firestore.instance
          .collection('games')
          .document(snapshot.data.documents[0].documentID.toString())
          .updateData({
        'mainGameUsers': userlist = {
          currentUser.id: false,
        },
      });
    }

//    if (main_game_check_value == true && dlc_game_check_value == true) {
//      print('everything update');
////        await Firestore.instance
////            .collection('users')
////            .document(currentUser.id)
////            .collection('comgameslist')
////            .document(snapshot.data.documents[0].documentID)
////            .setData({
////          'id': snapshot.data.documents[0].documentID,
////          'name': snapshot.data.documents[0]['name'],
////          'link': snapshot.data.documents[0]['link']
////        });
//      await Firestore.instance
//          .collection('games')
//          .document(snapshot.data.documents[0].documentID.toString())
//          .updateData({
//        'completedUsers': userlist = {
//          currentUser.id: true,
//        },
//      });
//    }else{
//      await Firestore.instance
//          .collection('games')
//          .document(snapshot.data.documents[0].documentID.toString())
//          .updateData({
//        'mainGameUsers': userlist = {
//          currentUser.id: false,
//        },
//      });
//    }


//    else {
//      print('two');
////      await Firestore.instance
////          .collection('users')
////          .document(currentUser.id)
////          .collection('comgameslist')
////          .document(snapshot.data.documents[0].documentID)
////          .delete();
//      await Firestore.instance
//          .collection('games')
//          .document(snapshot.data.documents[0].documentID.toString())
//          .updateData({
//        'comuserlist': userlist = {
//          currentUser.id: false,
//        },
//      });
//
////      setState(() {
////        toUpdate = false;
////        toUpdate2 = false;
////      });
//    }

  }

  Future dlcComplete(AsyncSnapshot snapshot) async {
    print('dlccom  maincom $maincom dlccom $dlccom');
    if (dlc_game_check_value == true) {
      print('dlc update');
//        await Firestore.instance
//            .collection('users')
//            .document(currentUser.id)
//            .collection('comgameslist')
//            .document(snapshot.data.documents[0].documentID)
//            .setData({
//          'id': snapshot.data.documents[0].documentID,
//          'name': snapshot.data.documents[0]['name'],
//          'link': snapshot.data.documents[0]['link']
//        });
      await Firestore.instance
          .collection('games')
          .document(snapshot.data.documents[0].documentID.toString())
          .updateData({
        'dlcUsers': userlist = {
          currentUser.id: true,
        },
      });
    }
    else{
      await Firestore.instance
          .collection('games')
          .document(snapshot.data.documents[0].documentID.toString())
          .updateData({
        'dlcUsers': userlist = {
          currentUser.id: false,
        },
      });
    }
  }

  Future fullComplete(AsyncSnapshot snapshot) async {
    print('fullcom maincom $maincom dlccom $dlccom');
    if (maincom == 1 && dlccom == 1) {
     // print('FULL update');
        await Firestore.instance
            .collection('users')
            .document(currentUser.id)
            .collection('comgameslist')
            .document(snapshot.data.documents[0].documentID)
            .setData({
          'id': snapshot.data.documents[0].documentID,
          'name': snapshot.data.documents[0]['name'],
          'link': snapshot.data.documents[0]['link']
        });
      await Firestore.instance
          .collection('games')
          .document(snapshot.data.documents[0].documentID.toString())
          .updateData({
        'allCompleteUsers': userlist = {
          currentUser.id: true,
        },
      });
    }
    else{
      await Firestore.instance
          .collection('games')
          .document(snapshot.data.documents[0].documentID.toString())
          .updateData({
        'allCompleteUsers': userlist = {
          currentUser.id: false,
        },
      });

      await Firestore.instance
          .collection('users')
          .document(currentUser.id)
          .collection('comgameslist')
          .document(snapshot.data.documents[0].documentID).delete();

    }
  }

  Future halfComplete(AsyncSnapshot snapshot) async {
    print('half maincom $maincom dlccom $dlccom');
    if (maincom ^ dlccom==1) {
      // print('FULL update');
      await Firestore.instance
          .collection('users')
          .document(currentUser.id)
          .collection('halfcomgameslist')
          .document(snapshot.data.documents[0].documentID)
          .setData({
        'id': snapshot.data.documents[0].documentID,
        'name': snapshot.data.documents[0]['name'],
        'link': snapshot.data.documents[0]['link']
      });
      await Firestore.instance
          .collection('games')
          .document(snapshot.data.documents[0].documentID.toString())
          .updateData({
        'halfCompleteUsers': userlist = {
          currentUser.id: true,
        },
      });
    }
    else{
      await Firestore.instance
          .collection('games')
          .document(snapshot.data.documents[0].documentID.toString())
          .updateData({
        'halfCompleteUsers': userlist = {
          currentUser.id: false,
        },
      });

      await Firestore.instance
          .collection('users')
          .document(currentUser.id)
          .collection('halfcomgameslist')
          .document(snapshot.data.documents[0].documentID).delete();
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey.withOpacity(.1),
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(200),
          child: Stack(
            children: [

              AppBar(
                automaticallyImplyLeading: false,
//                leading:
//                GestureDetector(
//                    onTap: ()
//                    {
//                      //Navigator.pop(context);
//                      print('pressed');
//                    },
//                    child: Icon(Icons.arrow_back)),
                  bottom: PreferredSize(
                    preferredSize: Size.fromHeight(20),
                    child: Container(
                      color: Colors.black54.withOpacity(.9),
                      child: TabBar(
                        labelColor: Colors.red,
                        unselectedLabelColor: Colors.lightBlueAccent,
                        isScrollable: true,
                        indicatorWeight: 6,
                        indicatorSize: TabBarIndicatorSize.tab,
                        controller: _tabController,
                        tabs: [
                          Tab(
                            icon: Icon(
                              Icons.info,
                              color: Colors.white,
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
                        ],
                      ),
                    ),
                  ),
                  flexibleSpace: Positioned.fill(
                      child: CachedNetworkImage(
                        imageUrl: widget.link,
                        fit: BoxFit.fill,
                        placeholder: (context, url) => CircularProgressIndicator(),
                      ),
                  ),
              ),
//              Swiper(
//                itemBuilder: (BuildContext context, int index) {
//                  return index == 2
//                      ? Stack(
//                    children: [
//                      Positioned.fill(
//                        child: BackdropFilter(
//                          filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
//                          child: Container(
//                            color: Colors.black.withOpacity(0),
//                          ),
//                        ),
//                      ),
//                      Center(
//                        child: Icon(
//                          Icons.info,
//                          size: 80,
//                          color: Colors.red,
//                        ),
////                              child: new Text(
////                                widget.name,
////                                style: TextStyle(
////                                    color: Colors.amber,
////                                    fontSize: 50,
////                                    fontWeight: FontWeight.bold),
////                              ),
//                      ),
//                    ],
//                  )
//                      : Text('');
//                },
//                itemCount: 4,
//                pagination: new SwiperPagination(),
//                control: new SwiperControl(),
//              ),
              GestureDetector(
                  onTap: ()
                  {
                    print('pressed');
                    Navigator.pop(context);

                  },
                  child:
              Padding(
                padding: const EdgeInsets.all(30.0),
                child: Icon(Icons.arrow_back,color: Colors.white,),
              )),


            ],
          ),
        ),
        body: TabBarView(
          controller: _tabController,
          children: [

            StreamBuilder<QuerySnapshot>(
                stream: Firestore.instance
                    .collection('games')
                    .where('name', isEqualTo: widget.name)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    //print('Snappppp:${[snapshot.data.documents[0]['name']]}');
                    //snapshot.data.documents.map((doc) {
                    //print('sdgsfsdf:${[snapshot.data.documents[0]['name']]}');

                    var plafrom = snapshot.data.documents[0]['platform'];
                    //for (var i in qwe) print(i);

                    var ss = snapshot.data.documents[0]['ss'];
                    var type = snapshot.data.documents[0]['type'];

//                    var ss = snapshot.data.documents[0]['ss'];
//                    print('vadfadfad'+ss[0]);

                    // for(var q in ss)
                    // print('vsdfsdf'+q);

                    return SingleChildScrollView(
                      child: Container(
                        child: Column(
                          children: [
                            SizedBox(
                              height: 20,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 30.0),
                              child: Container(
                                alignment: Alignment.centerLeft,
                                child: Center(
                                  child: Text(
                                    'About',
                                    style: TextStyle(
                                        fontSize: 30, color: Colors.white70,fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                            ),

                            Padding(
                              padding: const EdgeInsets.all(15.0),
                              child: ClipRRect(
                                clipBehavior: Clip.antiAlias,
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(10)),
                                child: Card(
                                  color: Colors.grey.withOpacity(.05),
                                  child: Container(
                                    decoration: BoxDecoration(

                                      border: Border(
                                        left: BorderSide(
                                            color: Colors.white70.withOpacity(.3), width: 3),
                                        top: BorderSide(
                                            color: Colors.white70.withOpacity(.3), width: 3),
                                      ),
                                      //borderRadius: BorderRadius.all(Radius.circular(10)),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(10.0),
                                      child: Center(
                                        child: Text(
                                          '${snapshot.data.documents[0]['about']}',
                                          style: GoogleFonts.chivo(
                                            color: Colors.white70,
                                            fontSize: 25,
//                                          foreground: Paint()
//                                            ..style = PaintingStyle.stroke
//                                            ..strokeWidth = 2
//                                            ..color = Color(0xFFf5fff1),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.only(left: 15.0, right: 15),
                              child: Divider(
                                height: 10,
                                color: Colors.white,
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 30.0),
                              child: Container(
                                alignment: Alignment.centerLeft,
                                child: Center(
                                  child: Text(
                                    'Screenshots',
                                    style:
                                    TextStyle(
                                        fontSize: 30, color: Colors.white70,fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              height: 300,
                              child: Swiper(
                                scrollDirection: Axis.horizontal,
                                itemBuilder: (BuildContext context, int index) {
                                  return Row(
                                    children: [
                                      Expanded(
                                        child: Image.network(
                                          ss[index],
                                          //ss[index],
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ],
                                  );
                                },
                                itemCount: ss.length,
//                        pagination: SwiperPagination(),
                                layout: SwiperLayout.DEFAULT,
                                itemWidth: 500,
                                itemHeight: 300,
                                autoplay: true,
                              ),
                            ),
                            Padding(
                              padding:
                              const EdgeInsets.only(left: 15.0, right: 15),
                              child: Divider(
                                height: 10,
                                color: Colors.white,
                              ),
                            ),


                            // Text(i,style: TextStyle(color: Colors.white,fontSize: 100),),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                'Genre   ',
                                style: TextStyle(
                                    fontSize: 30, color: Colors.white70,fontWeight: FontWeight.bold),
//                                GoogleFonts.bitter(
//                                    fontSize: 35,
//                                    foreground: Paint()
//                                      ..style = PaintingStyle.stroke
//                                      ..strokeWidth = 2
//                                      ..color = Colors.grey.withOpacity(.9),
//                                    shadows: <Shadow>[
//                                      Shadow(
//                                        offset: Offset(3.5, 3.5),
//                                        blurRadius: 5.0,
//                                        color: Colors.grey.withOpacity(.5),
//                                      )
//                                    ]),
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                for (var i in plafrom)
                                  Padding(
                                    padding: const EdgeInsets.only(left: 15),
                                    child: Text(
                                      i + ' ',
                                      //'${snapshot.data.documents[0]['platform']}',
                                      style: GoogleFonts.bitter(
                                          fontSize: 30,
                                          color: Colors.white70
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Padding(
                              padding:
                              const EdgeInsets.only(left: 15.0, right: 15),
                              child: Divider(
                                height: 10,
                                color: Colors.white,
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                'Catagory   ',
                                style:TextStyle(
                                    fontSize: 30, color: Colors.white70,fontWeight: FontWeight.bold),
//                                style: GoogleFonts.bitter(
//                                  fontSize: 35,
//                                  foreground: Paint()
//                                    ..style = PaintingStyle.stroke
//                                    ..strokeWidth = 2
//                                    ..color = Colors.grey.withOpacity(.9),
//                                  shadows: <Shadow>[
//                                    Shadow(
//                                      offset: Offset(3.5, 3.5),
//                                      blurRadius: 5.0,
//                                      color: Colors.grey.withOpacity(.5),
//                                    )
//                                  ]),
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                for (var i in type)
                                  Padding(
                                    padding: const EdgeInsets.only(left: 15),
                                    child: Text(
                                      i + ' ',
                                      //'${snapshot.data.documents[0]['platform']}',
                                      style: GoogleFonts.bitter(
                                          fontSize: 30,
                                          color: Colors.white70
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                            SizedBox(
                              height: 10,
                            ),
                          ],
                        ),
                      ),
                    );
                  }
                  return CircularProgressIndicator();
                }),

//            Container(
//              color: Colors.blue,
//              child: ExpansionTile(
//                backgroundColor: Colors.redAccent,
//                title: Text(
//                  'test',
//                  style: TextStyle(color: Colors.white, fontSize: 100),
//                ),
//                children: [
//                  Text(
//                    'test',
//                    style: TextStyle(color: Colors.white, fontSize: 100),
//                  ),
//                  Text(
//                    'test',
//                    style: TextStyle(color: Colors.white, fontSize: 100),
//                  )
//
//                ],
//              ),
//            )

//            Column(
//              children: [
//                SizedBox(
//                  height: 20,
//                ),
//                Row(
//                  children: [
//                    Padding(
//                      padding: const EdgeInsets.only(left:30.0),
//                      child: Text(
//                        'About',style: TextStyle(fontSize: 20,color: Colors.white),
//                      ),
//                    ),
//                  ],
//                ),
//                Padding(
//                  padding: const EdgeInsets.all(15.0),
//                  child: ClipRRect(
//                    clipBehavior: Clip.antiAlias,
//                    borderRadius: BorderRadius.only( topLeft: Radius.circular(10)),
//                    child: Container(
//                      decoration: BoxDecoration(
//                        color: Colors.black54,
//
//                        border: Border(
//                          left: BorderSide(
//                              color: Colors.greenAccent,
//                              width: 5
//
//                          ),
//                          top: BorderSide(
//                              color: Colors.greenAccent,
//                              width: 5
//                          ),
//
//                        ),
//                        //borderRadius: BorderRadius.all(Radius.circular(10)),
//                      ),
//                      child: Padding(
//                        padding: const EdgeInsets.all(10.0),
//                        child: Center(
//                          child: Text(
//                            'Counter-Strike: Global Offensive (CS: GO) expands upon the team-based action gameplay that it pioneered when it was launched 19 years ago. CS: GO features new maps, characters, weapons, and game modes, and delivers updated versions of the classic CS content (de_dust2, etc.)."',
//                            style: TextStyle(color: Color(0xFFFEFCD7 ), fontSize: 20),
//                          ),
//                        ),
//                      ),
//                    ),
//                  ),
//                ),
//                Padding(
//                  padding: const EdgeInsets.only(left:15.0,right: 15),
//                  child: Divider(
//                    height: 10,
//                    color: Colors.white,
//                  ),
//                ),
//                SizedBox(
//                  height: 10,
//                ),
//                Image.network('https://images.alphacoders.com/519/thumb-1920-519792.jpg'),
//
//              ],
//            ),
//            Text(
//              'test',
//              style: TextStyle(color: Colors.white, fontSize: 100),
//            ),

            StreamBuilder<QuerySnapshot>(
                stream: Firestore.instance
                    .collection('games')
                    .where('name', isEqualTo: widget.name)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    //print('Snappppp:${[snapshot.data.documents[0]['name']]}');
                    //snapshot.data.documents.map((doc) {
                    //print('sdgsfsdf:${[snapshot.data.documents[0]['name']]}');
                    var qw = snapshot.data.documents[0]['platform'];
                    // for (var i in qw) print(i);

//                    print('print  ' +
//                        snapshot.data.documents[0].documentID.toString());

                    if (snapshot.data.documents[0]['userlist'] != null) {
                      snapshot.data.documents[0]['userlist']
                          .forEach((key, val) {
                        if (key == currentUser.id) {
                          //print('key $key    $val');
                          add_game_list_check_value = val;
                        }
                      });
                    }

                    if (snapshot.data.documents[0]['mainGameUsers'] != null) {
                      snapshot.data.documents[0]['mainGameUsers']
                          .forEach((key, val) {
                        if (key == currentUser.id) {
//                          print('key $key    $val');
                          main_game_check_value = val;
                         // print('main_game_check_value $key    $val');
//                          dlc_game_check_value = val;
//                          print('dlc_game_check_value $key    $val');
                        }
                      });
                    }

                    if (snapshot.data.documents[0]['dlcUsers'] != null) {
                      snapshot.data.documents[0]['dlcUsers']
                          .forEach((key, val) {
                        if (key == currentUser.id) {
//                          print('key $key    $val');
                          dlc_game_check_value = val;
                          //print('dlc_game_check_value $key    $val');
//                          dlc_game_check_value = val;
//                          print('dlc_game_check_value $key    $val');
                        }
                      });
                    }


                    var lst = snapshot.data.documents[0]['userlist'];

                    //print('main  '+main_game_check_value.toString()+'  dlc  '+dlc_game_check_value.toString());
                    //for(var p in lst[currentUser.id])
                    //print('adaca  '+ lst[currentUser.id].toString());
                    //print('gva  '+ p.toString());

//                    print("asdasd   "+ snapshot.data.documents[0].documentID);
                    return SingleChildScrollView(
                      child: Column(
                        children: [
                          Card(
                            margin: EdgeInsets.fromLTRB(30, 20, 30, 0),
                            //shadowColor: Colors.lightBlue,
                            color: Colors.grey.withOpacity(.2),
                            child: ListTile(
                              leading: Text(
                                'Add to List',
                                style: TextStyle(
                                    fontSize: 20, color: Colors.white70),
                              ),
                              trailing: Container(
                                width: 30,
                                child: Checkbox(
                                    value: add_game_list_check_value,
                                    //snapshot.data.documents[0]['userlist'][currentUser.id],
                                    checkColor: Colors.redAccent,
                                    activeColor: Colors.amberAccent,
                                    // inactiveColor: Colors.amberAccent,
                                    // disabledColor: Colors.amberAccent,
                                    onChanged: (value) async {
                                      setState(() {
                                        add_game_list_check_value = value;
//                                      print(value);
//                                      print(currentUser.id);
                                        if (value == true) {

                                           Firestore.instance
                                              .collection('users')
                                              .document(currentUser.id)
                                              .collection('gameslist')
                                              .document(snapshot
                                              .data.documents[0].documentID)
                                              .setData({
                                            'id': snapshot
                                                .data.documents[0].documentID,
                                            'name': snapshot.data.documents[0]
                                            ['name'],
                                            'link': snapshot.data.documents[0]
                                            ['link']
                                          });

                                           Firestore.instance
                                              .collection('games')
                                              .document(snapshot
                                              .data.documents[0].documentID
                                              .toString())
                                              .updateData({
                                            'userlist': userlist = {
                                              currentUser.id: true,
                                            },
                                          });
                                        }
                                        else {
                                           Firestore.instance
                                              .collection('users')
                                              .document(currentUser.id)
                                              .collection('gameslist')
                                              .document(snapshot
                                              .data.documents[0].documentID)
                                              .delete();

                                           Firestore.instance
                                              .collection('games')
                                              .document(snapshot
                                              .data.documents[0].documentID
                                              .toString())
                                              .updateData({
                                            'userlist': userlist = {
                                              currentUser.id: false,
                                            },
                                          });
                                        }
                                      });

                                    }),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(30, 50, 30, 0),
                            child: ExpansionTileCard(
                              baseColor: Colors.grey.withOpacity(.2),
                              expandedColor: Colors.grey.withOpacity(.1),
                              leading: CircleAvatar(
                  backgroundImage: NetworkImage(widget.link)),
                              title: Text(
                                'Game Completion',
                                style: TextStyle(color: Colors.grey),
                              ),
                              //subtitle: Text('Tap to see more!'),
                              trailing: Icon(
                                Icons.arrow_drop_down_circle,
                                color: Colors.grey.withOpacity(.9),
                              ),
                              children: <Widget>[
                                Divider(
                                  thickness: 1.0,
                                  height: 1.0,
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            10, 10, 10, 10),
                                        child: Text(
                                          "Main Game",
                                          style: TextStyle(fontSize: 25,color: Colors.grey)
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            120, 0, 0, 0),
                                        child: Checkbox(
                                          value: main_game_check_value,
                                          checkColor: Colors.redAccent,
                                          activeColor: Colors.amberAccent,
                                          // inactiveColor: Colors.amberAccent,
                                          // disabledColor: Colors.amberAccent,
                                          onChanged: (value) {
                                            setState(() {
                                              //print('value MAin game: $value');
                                              main_game_check_value = value;
                                              value==true?maincom=1:maincom=0;

                                              if(main_game_check_value==true) {
                                                add_game_list_check_value = true;

                                                Firestore.instance
                                                    .collection('games')
                                                    .document(snapshot
                                                    .data.documents[0].documentID
                                                    .toString())
                                                    .updateData({
                                                  'userlist': userlist = {
                                                    currentUser.id: true,
                                                  },
                                                });

                                                 Firestore.instance
                                                    .collection('users')
                                                    .document(currentUser.id)
                                                    .collection('gameslist')
                                                    .document(snapshot
                                                    .data.documents[0].documentID)
                                                    .setData({
                                                  'id': snapshot
                                                      .data.documents[0].documentID,
                                                  'name': snapshot.data.documents[0]
                                                  ['name'],
                                                  'link': snapshot.data.documents[0]
                                                  ['link']
                                                });


                                              }
                                              print(' add value +$add_game_list_check_value');

                                              //toUpdate = main_game_check_value;

                                              //print('MAin game: $toUpdate');
//                                              complete(snapshot);

                                              mainComplete(snapshot);
                                              fullComplete(snapshot);
                                              halfComplete(snapshot);
                                            });


                                          },
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            10, 10, 10, 10),
                                        child: Text(
                                          "DLC",
                                          style: TextStyle(fontSize: 25,color: Colors.grey)
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            200, 0, 0, 0),
                                        child: Checkbox(
                                          value: dlc_game_check_value,
                                          checkColor: Colors.redAccent,
                                          activeColor: Colors.amberAccent,
                                          // inactiveColor: Colors.amberAccent,
                                          // disabledColor: Colors.amberAccent,
                                          onChanged: (value)  {
                                            setState(() {

                                              //print('DLC: $value');
                                             // print('update: $toUpdate');
                                              dlc_game_check_value = value;
                                              value==true?dlccom=1:dlccom=0;
                                              if(dlc_game_check_value==true) {
                                                add_game_list_check_value = true;

                                                Firestore.instance
                                                    .collection('games')
                                                    .document(snapshot
                                                    .data.documents[0].documentID
                                                    .toString())
                                                    .updateData({
                                                  'userlist': userlist = {
                                                    currentUser.id: true,
                                                  },
                                                });

                                                Firestore.instance
                                                    .collection('users')
                                                    .document(currentUser.id)
                                                    .collection('gameslist')
                                                    .document(snapshot
                                                    .data.documents[0].documentID)
                                                    .setData({
                                                  'id': snapshot
                                                      .data.documents[0].documentID,
                                                  'name': snapshot.data.documents[0]
                                                  ['name'],
                                                  'link': snapshot.data.documents[0]
                                                  ['link']
                                                });


                                              }
                                              //toUpdate2 = value;
//                                              complete(snapshot);
                                              //print('DLC: $toUpdate2');
                                              dlcComplete(snapshot);
                                              fullComplete(snapshot);
                                              halfComplete(snapshot);

                                            });

//                                            if (value == true) {
//                                              await Firestore.instance
//                                                  .collection('users')
//                                                  .document(currentUser.id)
//                                                  .collection('comgameslist')
//                                                  .document(snapshot
//                                                  .data.documents[0].documentID)
//                                                  .setData({
//                                                'id': snapshot
//                                                    .data.documents[0].documentID,
//                                                'name': snapshot.data.documents[0]
//                                                ['name'],
//                                                'link': snapshot.data.documents[0]
//                                                ['link']
//                                              });
//
//                                              await Firestore.instance
//                                                  .collection('games')
//                                                  .document(snapshot
//                                                  .data.documents[0].documentID
//                                                  .toString())
//                                                  .updateData({
//                                                'comuserlist': userlist = {
//                                                  currentUser.id: true,
//                                                },
//                                              });
//                                            }
//                                            else {
//                                              await Firestore.instance
//                                                  .collection('users')
//                                                  .document(currentUser.id)
//                                                  .collection('comgameslist')
//                                                  .document(snapshot
//                                                  .data.documents[0].documentID)
//                                                  .delete();
//
//                                              await Firestore.instance
//                                                  .collection('games')
//                                                  .document(snapshot
//                                                  .data.documents[0].documentID
//                                                  .toString())
//                                                  .updateData({
//                                                'comuserlist': userlist = {
//                                                  currentUser.id: false,
//                                                },
//                                              });
//                                            }
                                          },
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(30, 50, 30, 0),
                            child: ExpansionTileCard(
                              baseColor: Colors.grey.withOpacity(.2),
                              expandedColor: Colors.grey.withOpacity(.5),
                              leading: CircleAvatar(
                                  backgroundImage: NetworkImage(widget.link)),
                              title: Text(
                                'Platform',
                                style: TextStyle(color: Colors.grey),
                              ),
                              //subtitle: Text('Tap to see more!'),
                              trailing: Icon(
                                Icons.arrow_drop_down_circle,
                                color: Colors.white30,
                              ),
                              children: <Widget>[
                                Divider(
                                  thickness: 1.0,
                                  height: 1.0,
                                ),
                                for (var q in qw)
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.fromLTRB(
                                              10, 10, 10, 10),
                                          child: Text(
                                            q,
                                            style: TextStyle(
                                                fontSize: 25,
                                                color: Colors.grey),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 0, horizontal: 0),
                                          child: Checkbox(
                                            value: true,
                                            checkColor: Colors.green,
                                            activeColor: Colors.white,
                                            // inactiveColor: Colors.white,
                                            // disabledColor: Colors.amberAccent,
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  }

                  return CircularProgressIndicator();
                }),

//            Padding(
//              padding: const EdgeInsets.all(8.0),
//              child: ConfigurableExpansionTile(
//                borderColorStart: Colors.blue,
//                borderColorEnd: Colors.black,
//                animatedWidgetFollowingHeader: const Icon(
//                  Icons.expand_more,
//                  color: const Color(0xFF707070),
//                ),
//                headerExpanded:
//                Flexible(child: Center(child: Text("A Header Changed"))),
//                header: Row(
//                  children: [
//                    Container(
//                        color: Colors.transparent,
//                        child: Center(child: Text("A Header"))),
//                    Container(
//                        color: Colors.transparent,
//                        child: Center(child: Text("A Header"))),
//                  ],
//                ),
//                headerBackgroundColorStart: Colors.grey,
//                expandedBackgroundColor: Colors.blue,
//                headerBackgroundColorEnd: Colors.teal,
//                children: [
//                  Row(
//                    children: <Widget>[Text("CHILD 1")],
//                  ),
//                  Row(
//                    children: <Widget>[Text("CHILD 2")],
//                  )
//                ],
//              ),
//            )
          ],
        ));
  }
}
