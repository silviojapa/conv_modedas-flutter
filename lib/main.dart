import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

const request = "https://api.hgbrasil.com/finance?key=c9655aa5";

void main() async{
  runApp(MaterialApp(
    home: Home(),
    theme: ThemeData(
        hintColor: Colors.amber,
        primaryColor: Colors.white
    ),
  ));

}

Future<Map> getData() async{
  http.Response response = await http.get(request);
  return json.decode(response.body);
}


class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  
  double dolar;
  double euro;

  
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
          builder:(context, snapshot){
            switch(snapshot.connectionState){
              case ConnectionState.none:
              case ConnectionState.waiting:
                return Center(
                    child: Text("Carregando Dados...",
                    style: TextStyle(
                      color: Colors.amber,
                      fontSize: 25.0
                    ),
                    textAlign: TextAlign.center,),
                );
                default:
                  if(snapshot.hasError){
                    return Center(
                        child: Text("Erro ao Carregar Dados!",
                        style: TextStyle(color: Colors.amber, fontSize: 25.0),
                        textAlign: TextAlign.center,)
                    );
                  }else{
                    dolar = snapshot.data ["results"]["currencies"]["USD"]["buy"];
                    euro = snapshot.data ["results"]["currencies"]["EUR"]["buy"];
                    return SingleChildScrollView(
                        padding: EdgeInsets.all(10.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: <Widget>[
                            Icon(Icons.monetization_on, size: 130.0, color: Colors.amber,),
                            Divider(),
                            buildTextField("REAIS", "R\$: "),
                            Divider(),
                            buildTextField("DÓLAR", "US\$: "),
                            Divider(),
                            buildTextField("EURO", "€\$: "),
                          ],
                        ),
                      );
                  }//else fim
            }//switch fim
      })
    );
  }
}

buildTextField(String labelText, String prefixText){
  return  TextField(
    decoration: InputDecoration(
        labelText: labelText,
        labelStyle: TextStyle(color: Colors.amber),
        border: OutlineInputBorder(),
        prefixText: prefixText
    ),
    style: TextStyle(
        color: Colors.amber, fontSize: 25.0
    ),
  );
}

