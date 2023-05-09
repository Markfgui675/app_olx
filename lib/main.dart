import 'package:flutter/material.dart';

import 'View/Home.dart';

void main(){

  runApp(MaterialApp(
    home: Home(),
    debugShowCheckedModeBanner: false,
    theme: ThemeData(
      primaryColor: Color(0xff9c27b0),
      colorScheme: ColorScheme.fromSwatch().copyWith(secondary: Color(0xff7b1fa2)),
    ),

  ));

}
