import 'package:app_olx/RouteGenerator.dart';
import 'package:app_olx/tests/mascaras_padroes.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:app_olx/tests/formulario.dart';

import 'View/Home.dart';
import 'View/Login.dart';

void main() async {

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(MaterialApp(
    home: Home(),
    debugShowCheckedModeBanner: false,
    theme: ThemeData(
      primaryColor: Color(0xff9c27b0),
      colorScheme: ColorScheme.fromSwatch().copyWith(secondary: Color(0xff7b1fa2)),
    ),
    initialRoute: "/",
    onGenerateRoute: RouteGenerator.generateRoute,

  ));

}
