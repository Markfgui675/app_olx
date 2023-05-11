import 'package:flutter/material.dart';

import 'Widgets/BotaoCustomizado.dart';

class NovoAnuncio extends StatefulWidget {
  const NovoAnuncio({Key? key}) : super(key: key);

  @override
  State<NovoAnuncio> createState() => _NovoAnuncioState();
}

class _NovoAnuncioState extends State<NovoAnuncio> {

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Novo anúncio'),
        backgroundColor: Color(0xff9c27b0),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[

                //FormField(builder: builder),

                Row(
                  children: [
                    Text('Estado'),
                    Text('Categoria'),
                  ],
                ),

                Text('Caixas de textos'),

                BotaoCustomizado(
                    texto: 'Criar novo anúncio',
                    onPressed: (){
                      if(_formKey.currentState!.validate()){

                      }
                    }),


              ],
            ),
          ),
        ),
      ),
    );
  }
}

