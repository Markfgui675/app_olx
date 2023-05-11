import 'package:brasil_fields/brasil_fields.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:cpf_cnpj_validator/cpf_validator.dart';

class Formularios extends StatefulWidget {
  const Formularios({Key? key}) : super(key: key);

  @override
  State<Formularios> createState() => _FormulariosState();
}

class _FormulariosState extends State<Formularios> {

  TextEditingController _nomeController = TextEditingController();
  TextEditingController _idadeController = TextEditingController();
  TextEditingController _cpfController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  String _mensagem = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Formulário'),
      ),
      body: Container(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nomeController,
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                  hintText: 'Digite o seu nome'
                ),
                validator: (value){
                  if(value!.isEmpty){
                    return 'O campo é obrigatório';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _idadeController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  hintText: 'Digite sua idade'
                ),
                validator: (value){
                  if(value!.isEmpty){
                    return 'O campo é obrigatório';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _cpfController,
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  CpfInputFormatter()
                ],
                decoration: InputDecoration(
                    hintText: 'Digite seu cpf'
                ),
                validator: (value){
                  if(value!.isNotEmpty){
                    if(CPFValidator.isValid(value.toString())){
                      return null;
                    } else {
                      return 'O CPF inserido não é válido.';
                    }
                  } else if(value.isEmpty){
                    return 'Campo é obrigatório';
                  }
                  return null;
                },
              ),
              ElevatedButton(
                  onPressed: (){
                    if(_formKey.currentState!.validate()){
                      setState(() {
                        _mensagem = 'Bem vindo, ${_nomeController.text}';
                      });
                    }
                  },
                  child: Text('Salvar')
              ),
              Text(_mensagem, style: TextStyle(fontSize: 20),)
            ],
          ),
        )
      )
    );
  }
}

