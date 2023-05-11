import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {

  List<String> itensMenu = [];

  _escolhaMenuitem(String itemEscolhido){

    switch(itemEscolhido){
      case "Meus anúncios":
        Navigator.pushNamed(context, '/meus-anuncios');
        break;
      case "Entrar":
        Navigator.pushNamed(context, '/login');
        break;
      case "Sair":
        _deslogarUsuario();
        break;
    }

  }

  _deslogarUsuario(){
    FirebaseAuth auth = FirebaseAuth.instance;
    auth.signOut();
    Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
  }


  Future _verficaUsuarioLogado() async {

    FirebaseAuth auth = FirebaseAuth.instance;

    User? usuarioLogado = await auth.currentUser;

    if(usuarioLogado == null){
      setState(() {
        itensMenu = [
          'Entrar'
        ];
      });
    } else {
      setState(() {
        itensMenu = [
          'Meus anúncios',
          'Sair'
        ];
      });
    }

  }

  @override
  void initState() {
    super.initState();
     _verficaUsuarioLogado();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('OLX'),
        backgroundColor: Color(0xff9c27b0),
        actions: [
          PopupMenuButton<String>(
            onSelected: _escolhaMenuitem,
            itemBuilder: (context){

              return itensMenu.map((String item){
                return PopupMenuItem<String>(
                  value: item,
                  child: Text(item),
                );
              }).toList();

            }
          )
        ],
      ),
      body: Center(
        child: Text('Anúncios'),
      ),

    );
  }
}

