import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

const request = "https://api.hgbrasil.com/finance?key=ce07447a";

void main() async {
  runApp(MaterialApp(
    home: Home(),
    theme: ThemeData(
        hintColor: Colors.amber,
        primaryColor: Colors.white
    ),
  ));
}

Future<Map> getData() async {
  http.Response response = await http.get(request);
  return json.decode(response.body);
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  final realController = TextEditingController();
  final dolarController = TextEditingController();
  final euroController = TextEditingController();
  final libraController = TextEditingController();
  final ieneController = TextEditingController();
  double dolar;
  double euro;
  double libra;
  double iene;

  void _clearAll(){
    realController.text = "";
    dolarController.text = "";
    euroController.text = "";
    libraController.text="";
    ieneController.text="";
  }

  void _realChanged(String text){
    if(text.isEmpty) {
      _clearAll();
      return;
    }
    double real = double.parse(text);
    dolarController.text = (real/dolar).toStringAsFixed(2);
    euroController.text = (real/euro).toStringAsFixed(2);
    libraController.text = (real/libra).toStringAsFixed(2);
    ieneController.text = (real/iene).toStringAsFixed(2);

  }

  void _dolarChanged(String text){
    if(text.isEmpty) {
      _clearAll();
      return;
    }
    double dolar = double.parse(text);
    realController.text = (dolar * this.dolar).toStringAsFixed(2);
    euroController.text = (dolar * this.dolar / euro).toStringAsFixed(2);
    libraController.text = (dolar * this.dolar / libra).toStringAsFixed(2);
    ieneController.text = (dolar * this.dolar / iene).toStringAsFixed(2);
  }

  void _euroChanged(String text){
    if(text.isEmpty) {
      _clearAll();
      return;
    }
    double euro = double.parse(text);
    realController.text = (euro * this.euro).toStringAsFixed(2);
    dolarController.text = (euro * this.euro / dolar).toStringAsFixed(2);
    libraController.text = (euro * this.euro / libra).toStringAsFixed(2);
    ieneController.text = (euro * this.euro / iene).toStringAsFixed(2);

  }
  void _libraChanged(String text){
    if(text.isEmpty) {
      _clearAll();
      return;
    }
    double libra = double.parse(text);
    realController.text = (libra * this.libra).toStringAsFixed(2);
    dolarController.text = (libra * this.libra / dolar).toStringAsFixed(2);
    euroController.text = (libra * this.libra / euro).toStringAsFixed(2);
    ieneController.text = (libra * this.libra / iene).toStringAsFixed(2);
  }
  void _ieneChanged(String text){
    if(text.isEmpty) {
      _clearAll();
      return;
    }
    double iene = double.parse(text);
    realController.text = (iene * this.iene).toStringAsFixed(2);
    dolarController.text = (iene * this.iene / dolar).toStringAsFixed(2);
    euroController.text = (iene * this.iene / euro).toStringAsFixed(2);
    libraController.text = (iene * this.iene / libra).toStringAsFixed(2);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          title: Text("\$ Conversor \$"),
          backgroundColor: Colors.amber,
          centerTitle: true,
        ),
        body: FutureBuilder<Map>(
            future: getData(),
            builder: (context, snapshot) {
              switch(snapshot.connectionState){case ConnectionState.none:
                case ConnectionState.waiting:
                  return Center(
                      child: Text("Carregando Dados...",
                        style: TextStyle(
                            color: Colors.amber,
                            fontSize: 25.0),
                        textAlign: TextAlign.center,)
                  );
                default:
                  if(snapshot.hasError){
                    return Center(
                        child: Text("Erro ao Carregar Dados :(",
                          style: TextStyle(
                              color: Colors.amber,
                              fontSize: 25.0),
                          textAlign: TextAlign.center,)
                    );
                  } else {
                    dolar = snapshot.data["results"]["currencies"]["USD"]["buy"];
                    euro = snapshot.data["results"]["currencies"]["EUR"]["buy"];
                    libra = snapshot.data["results"]["currencies"]["GBP"]["buy"];
                    iene = snapshot.data["results"]["currencies"]["JPY"]["buy"];

                    return SingleChildScrollView(
                      padding: EdgeInsets.all(10.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          Image.asset("assets/imagem/logo.png"),
                          buildTextField("Reais", "R\$: ", realController, _realChanged),
                          Divider(),
                          buildTextField("Dólares", "US\$: ", dolarController, _dolarChanged),
                          Divider(),
                          buildTextField("Euros", "€: ", euroController, _euroChanged),
                          Divider(),
                          buildTextField("Libra", "£: ", libraController, _libraChanged),
                          Divider(),
                          buildTextField("Iene", "¥: ", ieneController, _ieneChanged),
                        ],
                      ),
                    );
                  }
              }
            })
    );
  }
}

Widget buildTextField(String label, String prefix, TextEditingController c, Function f){
  return TextField(
    controller: c,
    decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: Colors.red),
        border: OutlineInputBorder(),
        prefixText: prefix
    ),
    style: TextStyle(
        color: Colors.white70, fontSize: 25.0
    ),
    onChanged: f,
    keyboardType: TextInputType.numberWithOptions(decimal: true),
  );
}








