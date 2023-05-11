import 'package:app_olx/View/Widgets/BotaoCustomizado.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../Models/Usuario.dart';
import 'Widgets/inputCustomizado.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {

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
              'email':usuario.email
            }
          );

          Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);

        }
    );
  }

  _logarUsuario(Usuario usuario){

    FirebaseAuth auth = FirebaseAuth.instance;
    
    auth.signInWithEmailAndPassword(email: usuario.email, password: usuario.senha).then(
        (firebaseUser){

          Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);

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
                InputCustomizado(controller: _senha, hint: 'Senha', type: TextInputType.text, obscure: true,),
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
                BotaoCustomizado(
                    texto: _cadastrar ? 'Cadastrar':'Entrar',
                    onPressed: (){
                      _validarCampo();
                    }),
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

