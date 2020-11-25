import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttergg/models/user.dart';
import 'package:fluttergg/pages/userlist.dart';
import 'package:fluttergg/pages/create_account.dart';
import 'package:fluttergg/pages/profile.dart';
import 'package:fluttergg/pages/browse.dart';
import 'package:fluttergg/pages/timeline.dart';
import 'package:fluttergg/pages/catagory.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

import 'allGames.dart';
import 'chat_screen.dart';

final GoogleSignIn googleSignIn = GoogleSignIn();
final usersRef = Firestore.instance.collection('users');
final DateTime timestamp = DateTime.now();
User currentUser;
//String a = 'http://via.placeholder.com/350x150';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool isAuth = false;
  PageController pageController;
  int pageIndex = 0;
  File file;
  //String username;

  @override
  void initState() {
    super.initState();
    pageController = PageController();
    // Detects when user signed in
    googleSignIn.onCurrentUserChanged.listen((account) {
      handleSignIn(account);
    }, onError: (err) {
      print('Error signing in: $err');
    });
    // Reauthenticate user when app is opened


    googleSignIn.signInSilently(suppressErrors: false).then((account) {
      handleSignIn(account);
    }).catchError((err) {
      print('Error signing in: $err');
    });
  }

  handleSignIn(GoogleSignInAccount account) {
    if (account != null) {
      createUserInFirestore();
      setState(() {
        isAuth = true;
      });
    } else {
      setState(() {
        isAuth = false;
      });
    }
  }

  createUserInFirestore() async {
    // 1) check if user exists in users collection in database (according to their id)
    final GoogleSignInAccount user = googleSignIn.currentUser;
    DocumentSnapshot doc = await usersRef.document(user.id).get();

    if (!doc.exists) {
      // 2) if the user doesn't exist, then we want to take them to the create account page
//       final username = await Navigator.push(
//          context, MaterialPageRoute(builder: (context) => CreateAccount()));

      // 3) get username from create account, use it to make new user document in users collection
      usersRef.document(user.id).setData({
        "id": user.id,
        //"username": username,
        "photoUrl": user.photoUrl,
        "email": user.email,
        "displayName": user.displayName,
        "bio": "",
        "timestamp": timestamp
      });

      doc = await usersRef.document(user.id).get();
    }

    currentUser = User.fromDocument(doc);
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  login() {
    googleSignIn.signIn();
  }

  logout() {
    googleSignIn.signOut();
  }

  onPageChanged(int pageIndex) {
    setState(() {
      this.pageIndex = pageIndex;
    });
  }

  onTap(int pageIndex) {
    pageController.animateToPage(
      pageIndex,
      duration: Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  bool iconn=true;
  Scaffold buildAuthScreen() {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SlidingUpPanel(
        renderPanelSheet: true,
        backdropEnabled: true,
        backdropOpacity: .2,
        //backdropTapClosesPanel: true,
        color: Colors.grey.withOpacity(.05),
        minHeight: 50,
        maxHeight: 130,
        onPanelOpened: ()
        {
          setState(() {
            iconn=false;
          });

        },
        onPanelClosed: ()
        {
          setState(() {
            iconn=true;
          });
        },
        panel: Stack(
          children: [
            Positioned.fill(
              top:80,
              left:0,
              child: Column(
                children: [
                  CupertinoTabBar(
                      currentIndex: pageIndex,
                      onTap: onTap,
                      activeColor: Colors.greenAccent,
                      backgroundColor: Colors.transparent,

                      items: [
                        BottomNavigationBarItem(
                          icon: Icon(
                            Icons.apps,
                            size: 35.0,
                          ),
                        ),
                        BottomNavigationBarItem(icon: Icon(Icons.assignment)),
                        BottomNavigationBarItem(icon: Container(
                            child: Icon(Icons.search))),
                        BottomNavigationBarItem(icon: Icon(Icons.chat)),

                        BottomNavigationBarItem(icon: Icon(Icons.account_circle)),
                      ]),
                ],
              ),
            ),
            Container(

              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    iconn?Icons.change_history:Icons.arrow_drop_down_circle,
                    color: Colors.greenAccent,
                  )
                ],
              ),
            ),
//            Center(
//              child: Text("This is the sliding Widget"),
//            ),
          ],
        ),
        body: PageView(
          children: <Widget>[
//            Upload(),


            Browse(),
            AllGames(),
            ActivityFeed(),
            ChatScreen(),
            Profile(),

            //Timeline(),

//            RaisedButton(
//              child: Text('Logout'),
//              onPressed: logout,
//            ),


          ],
          controller: pageController,
          scrollDirection: Axis.horizontal,
//          allowImplicitScrolling:true,
//          pageSnapping: true,
          onPageChanged: onPageChanged,
        //physics: NeverScrollableScrollPhysics(),
        ),
      ),
//      bottomNavigationBar: CupertinoTabBar(
//          currentIndex: pageIndex,
//          onTap: onTap,
//          activeColor: Theme.of(context).primaryColor,
//          items: [
//            BottomNavigationBarItem(icon: Icon(Icons.whatshot)),
//            BottomNavigationBarItem(icon: Icon(Icons.notifications_active)),
//            BottomNavigationBarItem(
//              icon: Icon(
//                Icons.photo_camera,
//                size: 35.0,
//              ),
//            ),
//            BottomNavigationBarItem(icon: Icon(Icons.search)),
//            BottomNavigationBarItem(icon: Icon(Icons.account_circle)),
//          ]),
    );
    // return RaisedButton(
    //   child: Text('Logout'),
    //   onPressed: logout,
    // );
  }

  Scaffold buildUnAuthScreen() {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            colors: [
              Theme.of(context).accentColor,
              Theme.of(context).primaryColor,
            ],
          ),
        ),
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text(
              'GameTracker',
              style: TextStyle(
                fontFamily: "Signatra",
                fontSize: 90.0,
                color: Colors.white,
              ),
            ),
            GestureDetector(
              onTap: login,
              child: Container(
                width: 260.0,
                height: 60.0,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(
                      'assets/images/google_signin_button.png',
                    ),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return isAuth ? buildAuthScreen() : buildUnAuthScreen();
  }
}
