import 'dart:convert';
import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:amigodelivery/api/api_service_company.dart';
import 'package:amigodelivery/components/login_screen_3.dart';
import 'package:amigodelivery/home.dart';
import 'package:amigodelivery/model/company.dart';
import 'package:amigodelivery/api/api_service_rx.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:vibration/vibration.dart';
import 'package:amigodelivery/components/local_notications_helper.dart';

class MyAppC extends StatefulWidget {
  String name;
  String email;

  MyAppC({this.name, this.email, Key key}) : super(key: key);

  @override
  _MyAppCState createState() => _MyAppCState();
}

class _MyAppCState extends State<MyAppC> {
  final notifications = FlutterLocalNotificationsPlugin();
  String aux;
  int acess = 0;
  ApiServiceRX apiServiceR;
  int seconds, minutes, hours;
  static const duration = const Duration(seconds: 1);

  Timer timer;

  Future onSelectNotification(String payload) async =>
      await Navigator.pushAndRemoveUntil(
        context,
        CupertinoPageRoute(
            builder: (context) => MyAppC(
                  email: widget.email,
                  name: widget.name,
                )),
        (Route<dynamic> route) => false,
      );

  @override
  void initState() {
    notifications.cancelAll();

    // getValues();
    final settingsAndroid = AndroidInitializationSettings('app_icon');
    final settingsIOS = IOSInitializationSettings(
        onDidReceiveLocalNotification: (id, title, body, payload) =>
            onSelectNotification(payload));

    notifications.initialize(
        InitializationSettings(settingsAndroid, settingsIOS),
        onSelectNotification: onSelectNotification);
    apiServiceR = ApiServiceRX();
    timer = Timer.periodic(duration, (Timer t) {
      apiTime();
    });

    super.initState();
  }

  apiTime() {
    apiServiceR.getRequestY(widget.email).then((value) {
      if (value != null) {
        if (value.isNotEmpty) {
          showOngoingNotification(notifications,
              title: value[0].copName,
              body: 'Confirmamos seu pedido, estamos chegando!');

          Vibration.vibrate();
          Future.delayed(Duration(milliseconds: 10000));
          Vibration.vibrate();
          apiServiceR.deleteRequestY(value[0].id).then((valuey) {
            print(valuey);
          });
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: DefaultTabController(
        length: choices.length,
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.deepOrange,
            title: Center(child: Text('Amigo Delivery')),
            actions: <Widget>[
              IconButton(
                  icon:
                      Icon(Icons.exit_to_app, size: 30.0, color: Colors.white),
                  onPressed: () {
                    Navigator.pushAndRemoveUntil(
                      context,
                      CupertinoPageRoute(builder: (context) => LoginScreen3()),
                      (Route<dynamic> route) => false,
                    );
                  }),
            ],
            bottom: TabBar(
              indicatorColor: Colors.white,
              isScrollable: true,
              tabs: choices.map((Choice choice) {
                return Tab(
                  text: choice.title,
                  icon: Icon(choice.icon),
                );
              }).toList(),
            ),
          ),
          body: TabBarView(
            children: choices.map((Choice choice) {
              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: MyHomePage(
                  title: choice.title,
                  email: widget.email,
                  name: widget.name,
                ),
              );
            }).toList(),
          ),
          drawer: new Drawer(
            child: new ListView(
              children: <Widget>[
//            header
                new UserAccountsDrawerHeader(
                  accountName: Text(widget.name),
                  accountEmail: Text(widget.email),
                  currentAccountPicture: GestureDetector(
                    child: new CircleAvatar(
                      backgroundColor: Colors.blue,
                      child: Icon(
                        Icons.person,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  decoration: new BoxDecoration(color: Colors.deepOrange),
                ),
//            body

                // InkWell(
                //   onTap: () {
                //     Navigator.push(
                //         context,
                //         MaterialPageRoute(
                //           builder: (context) => Pedidos(),
                //         ));
                //   },
                //   child: ListTile(
                //     title: Text('Meus Pedidos'),
                //     leading: Icon(
                //       Icons.shopping_basket,
                //       color: Colors.deepOrange,
                //     ),
                //   ),
                // ),
                // InkWell(
                //   onTap: () {
                //     Navigator.push(
                //         context,
                //         MaterialPageRoute(
                //           builder: (context) => Cart_products(),
                //         ));
                //   },
                //   child: ListTile(
                //     title: Text('Meu Carrinho'),
                //     leading: Icon(
                //       Icons.shopping_cart,
                //       color: Colors.deepOrange,
                //     ),
                //   ),
                // ),

                Divider(),

                InkWell(
                  onTap: () {
                    Navigator.pushAndRemoveUntil(
                      context,
                      CupertinoPageRoute(builder: (context) => LoginScreen3()),
                      (Route<dynamic> route) => false,
                    );
                  },
                  child: ListTile(
                    title: Text('Sair'),
                    leading: Icon(
                      Icons.exit_to_app,
                      color: Colors.redAccent,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

const List<Choice> choices = const <Choice>[
  const Choice(title: 'LOJA OU DEPOSITO', icon: Icons.store),
  const Choice(title: 'RESTAURANTE OU LANCHONETE', icon: Icons.restaurant),
];

class Choice {
  const Choice({this.title, this.icon});

  final String title;
  final IconData icon;
}

class MyHomePage extends StatefulWidget {
  final String title;
  final String email;
  final String name;

  MyHomePage({Key key, this.title, this.email, this.name}) : super(key: key);

  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  TextEditingController editingController = TextEditingController();

  ApiServiceCop _apiServiceCop;
  List<Company> items;
  List<Company> duplicateItems;
  var refreshKey = GlobalKey<RefreshIndicatorState>();

  Future<Null> refreshList() async {
    refreshKey.currentState?.show(atTop: false);
    setState(() {});
  }

  @override
  void initState() {
    duplicateItems = List<Company>();
    items = List<Company>();
    _apiServiceCop = ApiServiceCop();
    super.initState();
  }

  void filterSearchResults(String query) {
    List<Company> dummySearchList = List<Company>();
    dummySearchList.addAll(duplicateItems);
    if (query.isNotEmpty) {
      List<Company> dummyListData = List<Company>();

      dummySearchList.forEach((item) {
        if (item.name.toLowerCase().contains(query.toLowerCase()) &&
            query != " ") {
          dummyListData.add(item);
        }
      });
      setState(() {
        items.clear();

        items = dummyListData;
      });
      return;
    } else {
      setState(() {
        items.clear();
        items.addAll(duplicateItems);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: Stack(
        children: <Widget>[
          Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  onChanged: (value) {
                    filterSearchResults(value);
                  },
                  controller: editingController,
                  decoration: InputDecoration(
                      labelText: "Pesquisar",
                      hintText: "Pesquisar",
                      prefixIcon: Icon(Icons.search),
                      border: OutlineInputBorder(
                          borderRadius:
                              BorderRadius.all(Radius.circular(25.0)))),
                ),
              ),
              FutureBuilder(
                future: _apiServiceCop.getCop(),
                builder: (BuildContext context,
                    AsyncSnapshot<List<Company>> snapshot) {
                  List<Company> cop = snapshot.data;

                  if (items == null || items.isEmpty) {
                    items = cop;
                    duplicateItems = cop;
                  }

                  int n = 0;
                  try {
                    for (final cat in items) {
                      if (widget.title.toLowerCase() ==
                          cat.category.toLowerCase()) {
                        n = 1;
                      }
                    }
                  } catch (Ex) {}

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
                    if (items == null) {
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
                    } else {
                      if (items.isEmpty) {
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
                                  child:
                                      Text('NENHUM ESTABELECIMENTO ENCONTRADO'),
                                ),
                              ],
                            ),
                          ],
                        );
                      } else {
                        return items == null || items.isEmpty || n == 0
                            ? Column(
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
                                    child: Text(
                                        'NENHUM ESTABELECIMENTO ENCONTRADO'),
                                  ),
                                ],
                              )
                            : Expanded(
                                child: RefreshIndicator(
                                    onRefresh: refreshList,
                                    key: refreshKey,
                                    child: ListView.builder(
                                      shrinkWrap: true,
                                      itemCount: items.length,
                                      itemBuilder: (context, index) {
                                        return widget.title.toLowerCase() ==
                                                items[index]
                                                    .category
                                                    .toLowerCase()
                                            ? GestureDetector(
                                                onTap: () {
                                                  Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                        builder: (context) =>
                                                            HomePage1(
                                                          cpf: items[index]
                                                              .cpf_cnpj,
                                                          email: widget.email,
                                                          name: widget.name,
                                                          id: items[index].id,
                                                        ),
                                                      ));
                                                },
                                                child: Card(
                                                  elevation: 5,
                                                  child: new Container(
                                                      child: Container(
                                                    height: 140.0,
                                                    child: Row(
                                                      children: <Widget>[
                                                        SingleChildScrollView(
                                                            child: Container(
                                                                height: 120.0,
                                                                width: 120.0,
                                                                decoration:
                                                                    BoxDecoration(
                                                                  borderRadius: BorderRadius.only(
                                                                      bottomLeft:
                                                                          Radius.circular(
                                                                              5),
                                                                      topLeft: Radius
                                                                          .circular(
                                                                              5)),
                                                                  image: DecorationImage(
                                                                      fit: BoxFit
                                                                          .cover,
                                                                      image: MemoryImage(
                                                                          base64Decode(
                                                                              items[index].image))),
                                                                ))),
                                                        Container(
                                                          height: 150,
                                                          child: Padding(
                                                            padding: EdgeInsets
                                                                .fromLTRB(10, 2,
                                                                    0, 0),
                                                            child: Column(
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              children: <
                                                                  Widget>[
                                                                Padding(
                                                                  padding: EdgeInsets
                                                                      .fromLTRB(
                                                                          0,
                                                                          5,
                                                                          0,
                                                                          2),
                                                                  child:
                                                                      Container(
                                                                    width: 200,
                                                                    child: Text(
                                                                      items[index]
                                                                          .name,
                                                                      style: TextStyle(
                                                                          fontSize:
                                                                              15,
                                                                          color: Color.fromARGB(
                                                                              255,
                                                                              48,
                                                                              48,
                                                                              54),
                                                                          fontWeight:
                                                                              FontWeight.bold),
                                                                    ),
                                                                  ),
                                                                ),
                                                                Padding(
                                                                  padding: EdgeInsets
                                                                      .fromLTRB(
                                                                          0,
                                                                          3,
                                                                          0,
                                                                          3),
                                                                  child:
                                                                      Container(
                                                                    width: 120,
                                                                    decoration: BoxDecoration(
                                                                        border: Border.all(
                                                                            color: Colors
                                                                                .white),
                                                                        borderRadius:
                                                                            BorderRadius.all(Radius.circular(10))),
                                                                    child:
                                                                        new FlutterRatingBar(
                                                                      itemSize:
                                                                          20,
                                                                      initialRating:
                                                                          double.parse(
                                                                              items[index].rating),
                                                                      fillColor:
                                                                          Colors
                                                                              .deepOrange,
                                                                      borderColor: Colors
                                                                          .deepOrange
                                                                          .withAlpha(
                                                                              50),
                                                                      allowHalfRating:
                                                                          true,
                                                                    ),
                                                                  ),
                                                                ),
                                                                Padding(
                                                                  padding: EdgeInsets
                                                                      .fromLTRB(
                                                                          0,
                                                                          5,
                                                                          0,
                                                                          2),
                                                                  child:
                                                                      Container(
                                                                    width: 200,
                                                                    child: Text(
                                                                      items[index]
                                                                          .address,
                                                                      style: TextStyle(
                                                                          fontSize:
                                                                              15,
                                                                          color: Color.fromARGB(
                                                                              255,
                                                                              48,
                                                                              48,
                                                                              54)),
                                                                    ),
                                                                  ),
                                                                ),
                                                                Padding(
                                                                  padding: EdgeInsets
                                                                      .fromLTRB(
                                                                          0,
                                                                          5,
                                                                          0,
                                                                          2),
                                                                  child:
                                                                      Container(
                                                                    width: 200,
                                                                    child: Text(
                                                                      'Horários: ' +
                                                                          items[index]
                                                                              .hour,
                                                                      style: TextStyle(
                                                                          fontSize:
                                                                              15,
                                                                          color: Color.fromARGB(
                                                                              255,
                                                                              48,
                                                                              48,
                                                                              54)),
                                                                    ),
                                                                  ),
                                                                ),
                                                                Padding(
                                                                  padding: EdgeInsets
                                                                      .fromLTRB(
                                                                          0,
                                                                          5,
                                                                          0,
                                                                          2),
                                                                  child:
                                                                      Container(
                                                                    width: 200,
                                                                    child: Text(
                                                                      'Dias: ' +
                                                                          items[index]
                                                                              .week,
                                                                      style: TextStyle(
                                                                          fontSize:
                                                                              15,
                                                                          color: Color.fromARGB(
                                                                              255,
                                                                              48,
                                                                              48,
                                                                              54)),
                                                                    ),
                                                                  ),
                                                                )
                                                              ],
                                                            ),
                                                          ),
                                                        )
                                                      ],
                                                    ),
                                                  )),
                                                ),
                                              )
                                            : n == 0
                                                ? Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: <Widget>[
                                                      Center(
                                                        child: Icon(
                                                          Icons.not_interested,
                                                          color: Colors.red,
                                                          size: 100.0,
                                                        ),
                                                      ),
                                                      Center(
                                                        child: Text(
                                                            'NENHUM ESTABELECIMENTO ENCONTRADO'),
                                                      ),
                                                    ],
                                                  )
                                                : Divider(
                                                    color: Colors.white,
                                                  );
                                      },
                                    )));
                      }
                    }
                  } else {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}