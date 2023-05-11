import 'package:brasil_fields/brasil_fields.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class MascarasPadroes extends StatefulWidget {
  const MascarasPadroes({Key? key}) : super(key: key);

  @override
  State<MascarasPadroes> createState() => _MascarasPadroesState();
}

class _MascarasPadroesState extends State<MascarasPadroes> {

  TextEditingController _cpfController = TextEditingController();
  TextEditingController _cnpjController = TextEditingController();
  TextEditingController _cepController = TextEditingController();
  TextEditingController _telefoneController = TextEditingController();
  TextEditingController _dataController = TextEditingController();
  TextEditingController _moedaController = TextEditingController();

  String? _valorRecuperado;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Máscaras e Padrões'),
        centerTitle: true,
      ),

      body: Container(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [

            //cpf
            TextField(
              controller: _cpfController,
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                CpfInputFormatter()
              ],
              decoration: InputDecoration(
                hintText: 'CPF'
              ),
            ),

            //cnpj
            TextField(
              controller: _cnpjController,
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                CnpjInputFormatter()
              ],
              decoration: InputDecoration(
                  hintText: 'CNPJ'
              ),
            ),

            //cep
            TextField(
              controller: _cepController,
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                CepInputFormatter()
              ],
              decoration: InputDecoration(
                  hintText: 'CEP'
              ),
            ),

            //telefone
            TextField(
              controller: _telefoneController,
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                TelefoneInputFormatter()
              ],
              decoration: InputDecoration(
                  hintText: 'Telefone'
              ),
            ),

            //data
            TextField(
              controller: _dataController,
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                DataInputFormatter()
              ],
              decoration: InputDecoration(
                  hintText: 'Data'
              ),
            ),

            //moeda
            TextField(
              controller: _moedaController,
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                RealInputFormatter(centavos: true)
              ],
              decoration: InputDecoration(
                  hintText: 'Moeda'
              ),
            ),

            ElevatedButton(
                onPressed: (){
                  setState(() {

                    /*
                    String moedaDb = _moedaController.text.toString();
                    moedaDb = moedaDb.replaceAll(".", "");

                    double valorDouble = double.parse(moedaDb);
                    var formataor = NumberFormat("#,##0.00", "pt_BR");
                    var resultado = formataor.format(valorDouble);

                    //_valorRecuperado = resultado;

                     */

                    for(var item in Estados.listaEstados){
                      print("item: ${item}");
                    }

                  });
                },
                child: Text('Recuperar valor')
            ),

            Text('Valor: $_valorRecuperado', style: TextStyle(fontSize: 25),)

          ],
        ),
      ),
    );
  }
}

