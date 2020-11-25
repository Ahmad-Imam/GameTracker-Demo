@JS()
library t;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:js/js.dart';

@JS()
external int test();

class MyOwn {
  MyOwn();

  int get value => test();
}

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyOwn myOwn = MyOwn();

  @override
  Widget build(BuildContext context) {
    return Text(
      myOwn.value.toString(),
      style: GoogleFonts.roboto(color: Colors.black, fontSize: 50),
    );
  }
}
