import 'dart:io';
import 'package:validadores/validadores.dart';
import 'package:brasil_fields/modelos/estados.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'Widgets/BotaoCustomizado.dart';

class NovoAnuncio extends StatefulWidget {
  const NovoAnuncio({Key? key}) : super(key: key);

  @override
  State<NovoAnuncio> createState() => _NovoAnuncioState();
}

class _NovoAnuncioState extends State<NovoAnuncio> {

  List<dynamic> _listaImagens = [];
  List<DropdownMenuItem<String>> _listaDropEstados = [];
  List<DropdownMenuItem<String>> _listaDropCategorias = [];

  String? _itemSelecionadoEstado;
  String? _itemSelecionadoCategoria;

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
                      return Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8),
                        child: GestureDetector(
                           onTap: (){
                             showDialog(
                                 context: context,
                                 builder: (_){
                                   return Dialog(
                                     child: Column(
                                       mainAxisSize: MainAxisSize.min,
                                       children: [
                                         Image.file(_listaImagens[index]),
                                         TextButton(
                                             onPressed: (){
                                               setState(() {
                                                 _listaImagens.removeAt(index);
                                               });
                                               Navigator.pop(context);
                                             },
                                             child: Text('Excluir', style: TextStyle(color: Colors.red),)
                                         )
                                       ],
                                     ),
                                   );
                                 }
                             );
                           },
                          child: CircleAvatar(
                            radius: 50,
                            backgroundImage: FileImage(_listaImagens[index]),
                            child: Container(
                              color: Color.fromRGBO(255, 255, 255, 0.4),
                              alignment: Alignment.center,
                              child: Icon(Icons.delete, color: Colors.red,),
                            ),
                          ),
                        ),
                      );
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

    final File? imageFile = File(image.path);

    if(image != null){
      setState(() {
        _listaImagens.add(imageFile);
      });
    }
    print(_listaImagens);

  }

  _carregarItensDropDown(){

    //Estados
    for(var estado in Estados.listaEstadosAbrv){
      _listaDropEstados.add(
        DropdownMenuItem(child: Text(estado), value: estado,)
      );
    }

    //Categorias
    _listaDropCategorias.add(
      DropdownMenuItem(child: Text('Automóvel'), value: 'auto',)
    );
    _listaDropCategorias.add(
        DropdownMenuItem(child: Text('Imóvel'), value: 'imovel',)
    );
    _listaDropCategorias.add(
        DropdownMenuItem(child: Text('Eletrônicos'), value: 'eletro',)
    );
    _listaDropCategorias.add(
        DropdownMenuItem(child: Text('Moda'), value: 'moda',)
    );
    _listaDropCategorias.add(
        DropdownMenuItem(child: Text('Esportes'), value: 'esportes',)
    );

  }

  @override
  void initState() {
    super.initState();
    _carregarItensDropDown();
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
                    Expanded(
                        child: Padding(
                          padding: EdgeInsets.all(8),
                          child: DropdownButtonFormField(
                            value: _itemSelecionadoEstado,
                              hint: Text('Estados'),
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 20
                              ),
                              items: _listaDropEstados,
                              onChanged: (value){
                                _itemSelecionadoEstado = value;
                              },
                              validator: (value){
                                Validador().
                                  add(Validar.OBRIGATORIO, msg: "Campo obrigatório").
                                  valido(value, clearNoNumber: true);
                              },
                          ),
                        )
                    ),
                    Expanded(
                        child: Padding(
                          padding: EdgeInsets.all(8),
                          child: DropdownButtonFormField(
                            value: _itemSelecionadoCategoria,
                            hint: Text('Estados'),
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 20
                            ),
                            items: _listaDropCategorias,
                            onChanged: (value){
                              _itemSelecionadoCategoria = value;
                            },
                            validator: (value){
                              Validador().
                              add(Validar.OBRIGATORIO, msg: "Campo obrigatório").
                              valido(value, clearNoNumber: true);
                            },
                          ),
                        )
                    ),
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

