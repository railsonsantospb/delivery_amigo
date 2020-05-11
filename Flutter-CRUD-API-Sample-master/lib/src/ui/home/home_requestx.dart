import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_crud_api_sample_app/src/api/api_service_cat.dart';
import 'package:flutter_crud_api_sample_app/src/api/api_service_rx.dart';
import 'package:flutter_crud_api_sample_app/src/model/category.dart';
import 'package:flutter_crud_api_sample_app/src/model/requestx.dart';
import 'package:flutter_crud_api_sample_app/src/ui/formadd/form_category.dart';
import 'dart:convert';
import 'package:flutter/widgets.dart';


GlobalKey<ScaffoldState> _scaffoldState = GlobalKey<ScaffoldState>();

class HomeRequestX extends StatefulWidget {


  @override
  _HomeRequestXState createState() => _HomeRequestXState();
}

class _HomeRequestXState extends State<HomeRequestX> {
  BuildContext context;
  ApiServiceRX apiService;
  TextEditingController editingController = TextEditingController();

  var items = List<RequestX>();


  @override
  void initState() {
    super.initState();
    apiService = ApiServiceRX();
  }

  @override
  Widget build(BuildContext context) {
    this.context = context;


    return SafeArea(



      child: FutureBuilder(

        future: apiService.getRequestX(),
        builder: (BuildContext context, AsyncSnapshot<List<RequestX>> snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text(
                  "Something wrong with message: ${snapshot.error.toString()}"),
            );
          } else if (snapshot.connectionState == ConnectionState.done) {

//            setState(() {});
            List<RequestX> rx = snapshot.data;

//            print(cat);
            if(rx.isEmpty == true){
              return Stack(
                children: <Widget>[
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Center(
                        child: Icon(Icons.not_interested, color: Colors.red, size: 100.0,),
                      ),
                      Center(
                        child: Text('NENHUM PEDIDO REGISTRADO'),
                      ),
                    ],
                  ),
                ],
              );
            } else {
              return MaterialApp(
                debugShowCheckedModeBanner: false,
                theme: ThemeData(
                  primaryColor: Colors.deepOrange,
                  accentColor: Colors.deepOrange,
                ),
                home: Scaffold(
                  key: _scaffoldState,

                  body: _buildListView(rx),
                ),
              );
            }
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),

    );
  }


  Widget _buildListView(List<RequestX> rxs) {
    return  Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child:  ListView.builder(
        shrinkWrap: true,
        itemBuilder: (context, index) {
          RequestX rx = rxs[index];

          return Padding(
            padding: const EdgeInsets.only(top: 1.0),
            child: Card(
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
                              child: new Text("Cliente: "),
                            ),

                            Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: new Text(rx.client,
                                style: TextStyle(color: Colors.deepOrange),),
                            ),

                          ],
                        ),
                        new Row(
                          // section the gelada ou natural
                          children: <Widget>[

                            Padding(
                              padding: const EdgeInsets.all(0.0),
                              child: new Text("Data da Compra: "),
                            ),

                            Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: new Text(rx.date.split(' ')[0],
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
                              child: new Text(rx.date.split(' ')[1],
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
                              child: new Text(rx.products,
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
                              child: new Text("R\$ ${rx.price_full}",
                                style: TextStyle(color: Colors.deepOrange),),
                            ),

                          ],
                        ),
                        new Row(
                          // section the gelada ou natural
                          children: <Widget>[

                            Padding(
                              padding: const EdgeInsets.all(0.0),
                              child: new Text("Endereço: "),
                            ),

                            Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: new Text(rx.address,
                                style: TextStyle(color: Colors.deepOrange),),
                            ),

                          ],
                        ),
                        new Row(
                          // section the gelada ou natural
                          children: <Widget>[

                            Padding(
                              padding: const EdgeInsets.all(0.0),
                              child: new Text("Email: "),
                            ),

                            Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: new Text(rx.email,
                                style: TextStyle(color: Colors.deepOrange),),
                            ),

                          ],
                        ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    FlatButton(
                      onPressed: () {
                        showDialog(
                            context: context,
                            builder: (context) {

                              return AlertDialog(
                                title: Text("Aviso!"),
                                content: Text(
                                    "Confirmar entrega do pedido de ${rx.client}?"),
                                actions: <Widget>[
                                  FlatButton(
                                    child: Text("SIM"),
                                    onPressed: () {
                                      Navigator.pop(context);
                                      apiService
                                          .deleteRquestX(rx.id)
                                          .then((isSuccess) {
                                        if (isSuccess) {
                                          setState(() {});
                                          Scaffold.of(this.context)
                                              .showSnackBar(SnackBar(
                                              content: Text(
                                                  "Entrega do pedido confirmada")));
                                        } else {
                                          Scaffold.of(this.context)
                                              .showSnackBar(SnackBar(
                                              content: Text(
                                                  "Falha ao Confirmar")));
                                        }
                                      });
                                    },
                                  ),
                                  FlatButton(
                                    child: Text("NÃO"),
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                  )
                                ],
                              );
                            });
                      },
                      child: Text(
                        "CONFIRMAR",
                        style: TextStyle(color: Colors.green),
                      ),
                    ),
                    FlatButton(
                      onPressed: () {

                        Navigator.push(context,
                            CupertinoPageRoute(builder: (context) {
                              return ;
                            }));
                      },
                      child: Text(
                        "VISUALIZAR NO MAPA",
                        style: TextStyle(color: Colors.blue),
                      ),
                    ),

                  ]),
                      ],
                    )),

              ),
            ),
          );
        },

        itemCount: rxs.length,

      ),

    );
  }
}
