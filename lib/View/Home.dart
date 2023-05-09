import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../Models/Usuario.dart';
import 'inputCustomizado.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {

  bool _cadastrar = false;

  TextEditingController _email = TextEditingController();
  TextEditingController _senha = TextEditingController();

  String _mensagemErro = '';

  _cadastrarUsuario(Usuario usuario){
    FirebaseAuth auth = FirebaseAuth.instance;
    FirebaseFirestore db = FirebaseFirestore.instance;
    auth.createUserWithEmailAndPassword(email: usuario.email, password: usuario.senha).then(
        (firebaseUser){

          User? user = firebaseUser.user;

          db.collection('usuarios').doc(user!.uid).set(
            {
              'id':user.uid,
              'nome':usuario.nome,
              'email':usuario.email
            }
          );

        }
    );
  }

  _logarUsuario(Usuario usuario){

    FirebaseAuth auth = FirebaseAuth.instance;
    
    auth.signInWithEmailAndPassword(email: usuario.email, password: usuario.email).then(
        (firebaseUser){

        }
    );

  }

  _validarCampo(){

    String email = _email.text;
    String senha = _senha.text;

    if(email.isNotEmpty && email.contains("@")){
      if(senha.isNotEmpty && senha.length > 6){

        Usuario usuario = Usuario();
        usuario.email = email;
        usuario.senha = senha;

        if(_cadastrar){
          //cadastrar
          _cadastrarUsuario(usuario);
        } else {
          //logar
          _logarUsuario(usuario);
        }

      } else {
        setState(() {
          _mensagemErro = 'Preencha a senha com pelo menos 6 caracteres!';
        });
      }
    } else {
      setState(() {
        _mensagemErro = 'Preencha o e-mail válido';
      });
    }

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(''),
        centerTitle: true,
        backgroundColor: Color(0xff9c27b0),
      ),
      body: Container(
        padding: const EdgeInsets.all(16),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(bottom: 32),
                  child: Image.asset('imagens/logo.png', width: 200, height: 150,),
                ),
                InputCustomizado(controller: _email, hint: 'Email', autofocus: true, type: TextInputType.emailAddress),
                const SizedBox(height: 10,),
                InputCustomizado(controller: _senha, hint: 'Senha', type: TextInputType.text),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('Logar'),
                    Switch(
                        value: _cadastrar,
                        onChanged: (bool valor){
                          setState(() {
                            _cadastrar = valor;
                          });
                        },
                      activeTrackColor: Color(0xff9c27b0),
                      activeColor: Colors.white,
                    ),
                    const Text('Cadastrar'),
                  ],
                ),
                ElevatedButton(
                    onPressed: (){
                      _validarCampo();
                    },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xff9c27b0),
                    padding: EdgeInsets.fromLTRB(32, 16, 32, 16),
                  ),
                    child: _cadastrar ? const Text('Cadastrar', style: TextStyle(color: Colors.white, fontSize: 20),) :
                      const Text('Entrar', style: TextStyle(color: Colors.white, fontSize: 20),),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 20),
                  child: Text(_mensagemErro, style: TextStyle(fontWeight: FontWeight.bold, color: Colors.red, fontSize: 18),),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

