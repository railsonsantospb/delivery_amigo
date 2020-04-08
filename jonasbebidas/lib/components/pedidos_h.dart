import 'package:flutter/material.dart';

class Pedidos extends StatefulWidget {
  @override
  _PedidosState createState() => _PedidosState();
}

class _PedidosState extends State<Pedidos> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: ListView.builder(

      itemCount: 2,
      itemBuilder: (BuildContext context, index){
        return Card(
          elevation: 10.0,

        child: ListTile(


          title: new Text("Dados da Compra"),

          subtitle: Align(

          child: Column(
            children: <Widget>[

              new Row(
                // section the gelada ou natural
                children: <Widget>[

                  Padding(
                    padding: const EdgeInsets.all(0.0),
                    child: new Text("Data da Compra: "),
                  ),

                  Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: new Text("20/04/2020",
                      style: TextStyle(color: Colors.deepOrange),),
                  ),

                ],
              ),
              new Row(
                // section the gelada ou natural
                children: <Widget>[

                  Padding(
                    padding: const EdgeInsets.all(0.0),
                    child: new Text("Hora da Compra: "),
                  ),

                  Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: new Text("10:15",
                      style: TextStyle(color: Colors.deepOrange),),
                  ),

                ],
              ),

              new Row(
                // section the gelada ou natural
                children: <Widget>[

                  Padding(
                    padding: const EdgeInsets.all(0.0),
                    child: new Text("Bebidas"),
                  ),

                  Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: new Text("Vinhos, Cerjevas",
                      style: TextStyle(color: Colors.deepOrange),),
                  ),

                ],
              ),
              new Row(
                // section the gelada ou natural
                children: <Widget>[

                  Padding(
                    padding: const EdgeInsets.all(0.0),
                    child: new Text("Valor"),
                  ),

                  Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: new Text("R\$ 10,00",
                      style: TextStyle(color: Colors.deepOrange),),
                  ),

                ],
              ),

            ],
          )),

        ),
      );
      }
      ),
    );
  }
}

