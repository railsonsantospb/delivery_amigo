import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:deliveryadmin/src/api/api_service_rx.dart';
import 'package:deliveryadmin/src/model/requestx.dart';
import 'package:flutter/widgets.dart';
import 'package:deliveryadmin/src/ui/home/maps.dart';
import 'package:deliveryadmin/src/ui/home/view_products.dart';

GlobalKey<ScaffoldState> _scaffoldState = GlobalKey<ScaffoldState>();

class HomeRequestY extends StatefulWidget {
  final id_cop;

  HomeRequestY({this.id_cop});
  @override
  _HomeRequestYState createState() => _HomeRequestYState();
}

class _HomeRequestYState extends State<HomeRequestY> {
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
        future: apiService.getRequestXNotActive(widget.id_cop),
        builder:
            (BuildContext context, AsyncSnapshot<List<RequestX>> snapshot) {
          if (snapshot.hasError) {
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

            if (rx == null) {
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
            } else if (rx.isEmpty == true) {
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
                        child: Text('NENHUMA ENTREGA CONFIRMADA'),
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
    return rxs == null
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
                  padding: const EdgeInsets.only(top: 0.0),
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
                                child: new Text("Status do Pedido: "),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: new Text(
                                  "Confirmado",
                                  style: TextStyle(color: Colors.green),
                                ),
                              ),
                            ],
                          ),
                          new Row(
                            // section the gelada ou natural
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.all(0.0),
                                child: new Text("Cliente: "),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: new Text(
                                  rx.client,
                                  style: TextStyle(color: Colors.deepOrange),
                                ),
                              ),
                            ],
                          ),
                          new Row(
                            // section the gelada ou natural
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.all(0.0),
                                child: new Text("Data da Comfirmação: "),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: new Text(
                                  rx.date.split(' ')[0],
                                  style: TextStyle(color: Colors.deepOrange),
                                ),
                              ),
                            ],
                          ),
                          new Row(
                            // section the gelada ou natural
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.all(0.0),
                                child: new Text("Hora da Comfirmação: "),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: new Text(
                                  rx.date.split(' ')[1],
                                  style: TextStyle(color: Colors.deepOrange),
                                ),
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
                                child: new Text(
                                  "R\$ ${rx.price_full}",
                                  style: TextStyle(color: Colors.deepOrange),
                                ),
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
                                child: new Text(
                                  rx.address,
                                  style: TextStyle(color: Colors.deepOrange),
                                ),
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
                                child: new Text(
                                  rx.email,
                                  style: TextStyle(color: Colors.deepOrange),
                                ),
                              ),
                            ],
                          ),
                          ButtonBar(children: <Widget>[
//                            FlatButton(
//                              onPressed: () {
//                                showDialog(
//                                    context: context,
//                                    builder: (context) {
//                                      return AlertDialog(
//                                        title: Text("Aviso!"),
//                                        content: Text(
//                                            "Deseja apagar o pedido de ${rx.client}?"),
//                                        actions: <Widget>[
//                                          FlatButton(
//                                            child: Text("SIM"),
//                                            onPressed: () {
//                                              Navigator.pop(context);
//
//                                              apiService
//                                                  .deleteRequestX(rx.id)
//                                                  .then((isSuccess) {
//                                                if (isSuccess) {
//                                                  setState(() {});
//                                                  Scaffold.of(this.context)
//                                                      .showSnackBar(SnackBar(
//                                                          content: Text(
//                                                              "Pedido Excluído")));
//                                                } else {
//                                                  Scaffold.of(this.context)
//                                                      .showSnackBar(SnackBar(
//                                                          content: Text(
//                                                              "Falha ao Excluir")));
//                                                }
//                                              });
//                                            },
//                                          ),
//                                          FlatButton(
//                                            child: Text("NÃO"),
//                                            onPressed: () {
//                                              Navigator.pop(context);
//                                            },
//                                          )
//                                        ],
//                                      );
//                                    });
//                              },
//                              child: Text(
//                                "EXCLUIR",
//                                style: TextStyle(color: Colors.red),
//                              ),
//                            ),
                            FlatButton(
                              onPressed: () {
                                Navigator.push(context,
                                    CupertinoPageRoute(builder: (context) {
                                  return MyMap(
                                      lat: double.parse(rx.lat),
                                      lon: double.parse(rx.lon),
                                      name: rx.client);
                                }));
                              },
                              child: Text(
                                "VER NO MAPA",
                                style: TextStyle(color: Colors.blue),
                              ),
                            ),
                            FlatButton(
                              onPressed: () {
                                Navigator.push(context,
                                    CupertinoPageRoute(builder: (context) {
                                  return HomeRequestProdX(
                                    value: rx.price_full,
                                    list_product: rx.products,
                                  );
                                }));
                              },
                              child: Text(
                                "DETALHES",
                                style: TextStyle(color: Colors.green),
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
