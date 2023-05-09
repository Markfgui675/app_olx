import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'View/Home.dart';
import 'View/Login.dart';

class RouteGenerator{

  static Route<dynamic>? generateRoute(RouteSettings settings){

    final args = settings.arguments;

    switch(settings.name){
      case "/":
        return MaterialPageRoute(builder: (_) => Home());

      case "/login":
        return MaterialPageRoute(builder: (_) => Login());

      default:
        _erroRota();
    }

  }

  static Route<dynamic> _erroRota(){
    return MaterialPageRoute(
      builder: (_){
        return Scaffold(
          appBar: AppBar(
            title: Text('Tela não encontrada!'),
          ),
          body: Center(
            child: Text('Tela não encontrada'),
          ),
        );
      }
    );
  }

}