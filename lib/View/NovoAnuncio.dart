import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'Widgets/BotaoCustomizado.dart';

class NovoAnuncio extends StatefulWidget {
  const NovoAnuncio({Key? key}) : super(key: key);

  @override
  State<NovoAnuncio> createState() => _NovoAnuncioState();
}

class _NovoAnuncioState extends State<NovoAnuncio> {

  List<File> _listaImagens = [];

  final _formKey = GlobalKey<FormState>();

  Widget _adicionarImagem(){
    return FormField<List>(
      initialValue: _listaImagens,
      validator: (imagens){
        if(imagens!.length == 0){
          return 'Necessário selecionar uma imagem!';
        }
      },
      builder: (state){
        return Column(
          children: [
            Container(
              height: 100,
              child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: _listaImagens.length + 1,
                  itemBuilder: (context, index){

                    if(index == _listaImagens.length){
                      return Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8),
                        child: GestureDetector(
                          onTap: (){
                            _selecionarImagemGaleria();
                          },
                          child: CircleAvatar(
                            backgroundColor: Colors.grey[400],
                            radius: 50,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.add_a_photo, size: 40, color: Colors.grey[100],),
                                Text('Adicionar', style: TextStyle(color: Colors.grey[100], fontSize: 14, fontWeight: FontWeight.bold),)
                              ],
                            ),
                          ),
                        ),

                      );
                    }

                    if(_listaImagens.length > 0){

                    }

                    return Container();

                  }
              ),
            ),
            if(state.hasError)
              Container(
                child: Text('${state.errorText}', style: TextStyle(color: Colors.red, fontSize: 14),),
              )

          ],
        );
      },
    );
  }


  Future<void> _selecionarImagemGaleria() async {

    final ImagePicker picker = ImagePicker();
    final dynamic image = await picker.pickImage(source: ImageSource.gallery);

    if(image != null){
      setState(() {
        _listaImagens.add(image);
      });
    }

  }

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

                _adicionarImagem(),

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

