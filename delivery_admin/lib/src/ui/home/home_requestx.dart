import 'package:deliveryadmin/src/model/requesty.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:deliveryadmin/src/api/api_service_rx.dart';
import 'package:deliveryadmin/src/model/requestx.dart';
import 'package:flutter/widgets.dart';
import 'package:deliveryadmin/src/ui/home/maps.dart';
import 'package:deliveryadmin/src/ui/home/view_products.dart';
import 'package:ringtone/ringtone.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vibration/vibration.dart';

class HomeRequestX extends StatefulWidget {
  final id_cop;
  final name;

  HomeRequestX({this.id_cop, this.name});
  @override
  _HomeRequestXState createState() => _HomeRequestXState();
}

class _HomeRequestXState extends State<HomeRequestX> {
  GlobalKey<ScaffoldState> _scaffoldState1 = GlobalKey<ScaffoldState>();
  BuildContext context;
  ApiServiceRX apiService;
  TextEditingController editingController = TextEditingController();

  var items = List<RequestX>();
  var refreshKey = GlobalKey<RefreshIndicatorState>();

  String acess = "0";

  @override
  void initState() {
    Ringtone.stop();
    Vibration.cancel();
    super.initState();
    apiService = ApiServiceRX();
  }

  Future<Null> refreshList() async {
    refreshKey.currentState?.show(atTop: false);
    setState(() {});
  }

  getValues() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //Return String

    if (prefs.getString('acess') != null && this.mounted) {
      setState(() {
        acess = prefs.getString('acess');
      });
    }
  }

  saveToAcess(String acess) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    prefs.setString('acess', acess);
  }

  @override
  Widget build(BuildContext context) {
    this.context = context;

    return SafeArea(
      child: FutureBuilder(
        future: apiService.getRequestXActive(widget.id_cop),
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
              ));
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
                  key: _scaffoldState1,
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
            child: RefreshIndicator(
                onRefresh: refreshList,
                key: refreshKey,
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
                                      "Aguardando",
                                      style: TextStyle(color: Colors.blue),
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
                                      style:
                                          TextStyle(color: Colors.deepOrange),
                                    ),
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
                                    child: new Text(
                                      rx.date.split(' ')[0],
                                      style:
                                          TextStyle(color: Colors.deepOrange),
                                    ),
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
                                    child: new Text(
                                      rx.date.split(' ')[1],
                                      style:
                                          TextStyle(color: Colors.deepOrange),
                                    ),
                                  ),
                                ],
                              ),
                              new Row(
                                // section the gelada ou natural
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.all(0.0),
                                    child: new Text("Valor: "),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(4.0),
                                    child: new Text(
                                      "R\$ ${rx.price_full}",
                                      style:
                                          TextStyle(color: Colors.deepOrange),
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
                              new Row(
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.all(4.0),
                                    child: new Text(
                                      "${rx.pay}",
                                      style:
                                          TextStyle(color: Colors.deepOrange),
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
                                      style:
                                          TextStyle(color: Colors.deepOrange),
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
                                      style:
                                          TextStyle(color: Colors.deepOrange),
                                    ),
                                  ),
                                ],
                              ),
                              Divider(),
                              new Wrap(
                                // section the gelada ou natural
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.all(0.0),
                                    child: new Text(
                                      "Observação: ",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(4.0),
                                    child: new Text(
                                      rx.obs,
                                      style:
                                          TextStyle(color: Colors.deepOrange),
                                    ),
                                  ),
                                ],
                              ),
                              ButtonBar(children: <Widget>[
                                FlatButton(
                                  onPressed: () {
                                    getValues();
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
                                                      .updateRequestX(rx)
                                                      .then((isSuccess) {
                                                    if (isSuccess) {
                                                      saveToAcess(
                                                          (int.parse(acess) - 1)
                                                              .toString());
                                                      _scaffoldState1
                                                          .currentState
                                                          .showSnackBar(
                                                              SnackBar(
                                                        backgroundColor:
                                                            Colors.green,
                                                        content: Text(
                                                            "Pedido Confirmado com Sucesso"),
                                                      ));
                                                      RequestY ry = RequestY(
                                                          client: rx.client,
                                                          email: rx.email,
                                                          copName: widget.name);
                                                      apiService
                                                          .createRequestY(ry)
                                                          .then((value) {
                                                        if (value) {
                                                          print(value);
                                                        }
                                                      });
                                                      setState(() {});
                                                    } else {
                                                      _scaffoldState1
                                                          .currentState
                                                          .showSnackBar(
                                                              SnackBar(
                                                        backgroundColor:
                                                            Colors.red,
                                                        content: Text(
                                                            "Falha na Confirmação ou Verifique sua Conexão"),
                                                      ));
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
                                    style: TextStyle(color: Colors.deepOrange),
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
                )),
          );
  }
}
