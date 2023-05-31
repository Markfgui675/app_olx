import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:app_olx/View/Widgets/inputCustomizado.dart';
import 'package:brasil_fields/brasil_fields.dart';
import 'package:flutter/services.dart';
import 'package:validadores/validadores.dart';
import 'package:brasil_fields/modelos/estados.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../Models/Anuncio.dart';
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

  late Anuncio _anuncio;

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

  _salvarAnuncio() async {

    //upload imagens no Storage
    await _uploadImagens();
    print('Lista imagens: ${_anuncio.fotos.toString()}');

    //salvar anuncio no firestore

  }

  Future _uploadImagens() async {
    FirebaseStorage storage = FirebaseStorage.instance;
    Reference raiz = storage.ref();

    for(var imagem in _listaImagens){

      String nomeImagem = DateTime.now().microsecondsSinceEpoch.toString();
      Reference arquivo = raiz.
        child('meus_anuncios').
        child(_anuncio.id).
        child(nomeImagem);

      UploadTask uploadTask = arquivo.putFile(imagem);
      TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() => null);

      String url = await taskSnapshot.ref.getDownloadURL();
      _anuncio.fotos.add(url);

    }
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
    _anuncio = Anuncio();
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
                              onSaved: (estado){
                                _anuncio.estado = estado!;
                              },
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 20
                              ),
                              items: _listaDropEstados,
                              onChanged: (value){
                                _itemSelecionadoEstado = value;
                              },
                              validator: (value){
                                return Validador().
                                  add(Validar.OBRIGATORIO, msg: "Campo obrigatório").
                                  valido(value);
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
                            onSaved: (categoria){
                              _anuncio.categoria = categoria!;
                            },
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 20
                            ),
                            items: _listaDropCategorias,
                            onChanged: (value){
                              _itemSelecionadoCategoria = value;
                            },
                            validator: (value){
                              return Validador().
                              add(Validar.OBRIGATORIO, msg: "Campo obrigatório").
                              valido(value);
                            },
                          ),
                        )
                    ),
                  ],
                ),

                Padding(
                  padding: EdgeInsets.only(bottom: 15, top: 15),
                  child: InputCustomizado(
                    hint: 'Título',
                    onSaved: (titulo){
                      _anuncio.titulo = titulo!;
                    },
                    inputFormatter: [],
                    validator: (valor){
                      return Validador().
                      add(Validar.OBRIGATORIO, msg: "Campo obrigatório").
                      valido(valor);
                    },
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 15),
                  child: InputCustomizado(
                    hint: 'Preço',
                    onSaved: (preco){
                      _anuncio.preco = preco!;
                    },
                    type: TextInputType.number,
                    inputFormatter: [
                      FilteringTextInputFormatter.digitsOnly,
                      RealInputFormatter(centavos: true)
                    ],
                    validator: (valor){
                      return Validador().
                      add(Validar.OBRIGATORIO, msg: "Campo obrigatório").
                      valido(valor);
                    },
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 15),
                  child: InputCustomizado(
                    hint: 'Telefone',
                    type: TextInputType.phone,
                    onSaved: (telefone){
                      _anuncio.telefone = telefone!;
                    },
                    inputFormatter: [
                      FilteringTextInputFormatter.digitsOnly,
                      TelefoneInputFormatter()
                    ],
                    validator: (valor){
                      return Validador().
                        add(Validar.OBRIGATORIO, msg: "Campo obrigatório").
                        valido(valor);
                    },
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 15),
                  child: InputCustomizado(
                    hint: 'Descrição',
                    type: TextInputType.text,
                    onSaved: (descricao){
                      _anuncio.descricao = descricao!;
                    },
                    maxLines: null,
                    inputFormatter: [],
                    validator: (valor){
                      return Validador().
                        add(Validar.OBRIGATORIO, msg: "Campo obrigatório").
                        maxLength(200, msg: 'Máximo de 200 caracteres').
                        valido(valor);
                    },
                  ),
                ),

                BotaoCustomizado(
                    texto: 'Criar novo anúncio',
                    onPressed: (){
                      if(_formKey.currentState!.validate()){

                        //salva campos
                        _formKey.currentState!.save();

                        //salva anuncio
                        _salvarAnuncio();

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

