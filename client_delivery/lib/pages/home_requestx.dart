import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'package:amigodelivery/api/api_service_rx.dart';
import 'package:amigodelivery/model/requestx.dart';

GlobalKey<ScaffoldState> _scaffoldState = GlobalKey<ScaffoldState>();

class HomeRequestX extends StatefulWidget {
  final email;
  final id_cop;

  HomeRequestX({this.email, this.id_cop});

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
        future: apiService.getRequestXActive(widget.email, widget.id_cop),
        builder:
            (BuildContext context, AsyncSnapshot<List<RequestX>> snapshot) {
          if (snapshot.hasError) {
            print(snapshot.error.toString());
            return Center(
              child: Stack(
                children: <Widget>[
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Center(
                        child: Icon(
                          Icons.broken_image,
                          color: Colors.red,
                          size: 100.0,
                        ),
                      ),
                      Center(
                        child: Text('SEM CONEXÃO COM A INTERNET'),
                      ),
                      Center(
                        child: Text('FECHE O APLICATIVO'),
                      ),
                      Center(
                        child: Text('TENTE NOVAMENTE'),
                      ),
                      Center(
                        child: Text('SE PERSISTIR CONTATE O SUPORTE'),
                      ),
                    ],
                  ),
                ],
              ),
            );
          } else if (snapshot.connectionState == ConnectionState.done) {
//            setState(() {});
            List<RequestX> rx = snapshot.data;

//            print(cat);
            if (rx == null) {
              return Stack(
                children: <Widget>[
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Center(
                        child: Icon(
                          Icons.not_interested,
                          color: Colors.red,
                          size: 100.0,
                        ),
                      ),
                      Center(
                        child: Text('NENHUM PEDIDO REGISTRADO'),
                      ),
                    ],
                  ),
                ],
              );
            } else if (rx.isEmpty) {
              return Stack(
                children: <Widget>[
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Center(
                        child: Icon(
                          Icons.not_interested,
                          color: Colors.red,
                          size: 100.0,
                        ),
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
    return rxs[0].id == 0
        ? Center(
            child: Stack(
            children: <Widget>[
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Center(
                    child: Icon(
                      Icons.broken_image,
                      color: Colors.red,
                      size: 100.0,
                    ),
                  ),
                  Center(
                    child: Text('SEM CONEXÃO COM A INTERNET'),
                  ),
                  Center(
                    child: Text('FECHE O APLICATIVO'),
                  ),
                  Center(
                    child: Text('TENTE NOVAMENTE'),
                  ),
                  Center(
                    child: Text('SE PERSISTIR CONTATE O SUPORTE'),
                  ),
                ],
              ),
            ],
          ))
        : Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
            child: ListView.builder(
              shrinkWrap: true,
              itemBuilder: (context, index) {
                RequestX rx = rxs[index];

                return Padding(
                  padding: const EdgeInsets.only(top: 10.0),
                  child: Card(
                    elevation: 10.0,
                    child: ListTile(
                      leading: Icon(
                        Icons.store,
                        color: Colors.deepOrange,
                      ),
                      subtitle: Align(
                          child: Column(
                        children: <Widget>[
                          new Row(
                            // section the gelada ou natural
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.all(0.0),
                                child: new Text("Status do Pedido: "),
                              ),
                            ],
                          ),
                          Row(
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: rx.active == 1
                                    ? Text(
                                        "Aguardando",
                                        style: TextStyle(color: Colors.blue),
                                      )
                                    : Text(
                                        "Confirmado",
                                        style: TextStyle(color: Colors.green),
                                      ),
                              ),
                            ],
                          ),
                          Divider(),
                          new Row(
                            // section the gelada ou natural
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.all(0.0),
                                child: new Text("Cliente: "),
                              ),
                            ],
                          ),
                          Row(
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: new Text(
                                  rx.client,
                                  style: TextStyle(color: Colors.deepOrange),
                                ),
                              ),
                            ],
                          ),
                          Divider(),
                          new Row(
                            // section the gelada ou natural
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.all(0.0),
                                child: new Text("Data da Compra: "),
                              ),
                            ],
                          ),
                          Row(
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: new Text(
                                  rx.date.split(' ')[0],
                                  style: TextStyle(color: Colors.deepOrange),
                                ),
                              ),
                            ],
                          ),
                          Divider(),
                          new Row(
                            // section the gelada ou natural
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.all(0.0),
                                child: new Text("Hora da Compra: "),
                              ),
                            ],
                          ),
                          Row(
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: new Text(
                                  rx.date.split(' ')[1],
                                  style: TextStyle(color: Colors.deepOrange),
                                ),
                              ),
                            ],
                          ),
                          Divider(),
                          new Row(
                            // section the gelada ou natural
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.all(0.0),
                                child: new Text("Valor: "),
                              ),
                            ],
                          ),
                          Row(
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: new Text(
                                  "R\$ ${rx.price_full}",
                                  style: TextStyle(color: Colors.deepOrange),
                                ),
                              ),
                            ],
                          ),
                          Divider(),
                          new Row(
                            // section the gelada ou natural
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.all(0.0),
                                child: new Text("Endereço: "),
                              ),
                            ],
                          ),
                          Row(
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: new Text(
                                  rx.address,
                                  style: TextStyle(color: Colors.deepOrange),
                                ),
                              ),
                            ],
                          ),
                          Divider(),
                          new Row(
                            // section the gelada ou natural
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.all(0.0),
                                child: new Text("Email: "),
                              ),
                            ],
                          ),
                          Row(
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: new Text(
                                  rx.email,
                                  style: TextStyle(color: Colors.deepOrange),
                                ),
                              ),
                            ],
                          ),
                          Divider(),
                          new Row(
                            // section the gelada ou natural
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.all(0.0),
                                child: new Text("Telefone: "),
                              ),
                            ],
                          ),
                          Row(
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: new Text(
                                  rx.phone.toString(),
                                  style: TextStyle(color: Colors.deepOrange),
                                ),
                              ),
                            ],
                          ),
                          Divider(),
                          new Row(
                            // section the gelada ou natural
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.all(0.0),
                                child: new Text("Forma de Pagamento: "),
                              ),
                            ],
                          ),
                          Row(
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: new Text(
                                  rx.pay,
                                  style: TextStyle(color: Colors.deepOrange),
                                ),
                              ),
                            ],
                          ),
                          Divider(),
                          new Row(
                            // section the gelada ou natural
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.all(0.0),
                                child: new Text("Observação: "),
                              ),
                            ],
                          ),
                          Row(
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: new Text(
                                  rx.obs,
                                  style: TextStyle(color: Colors.deepOrange),
                                ),
                              ),
                            ],
                          ),
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
