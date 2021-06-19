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
import 'package:geolocator/geolocator.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'dart:math' as Math;

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
  final Geolocator geolocator = Geolocator()..forceAndroidLocationManager;
  Position _currentPosition;
  ProgressDialog pr;
  String locale;

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

  _getCurrentLocation() async {
    try {
      Position position = await Geolocator()
          .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
      List<Placemark> placemark = await Geolocator()
          .placemarkFromCoordinates(position.latitude, position.longitude);

      _currentPosition = position;
      locale = placemark.first.subLocality.toString();
    } catch (e) {}
  }

  double deg2rad(deg) {
    return deg * (Math.pi / 180);
  }

  double calculateDistance(lat1, lon1, lat2, lon2) {
    var R = 6371; // Radius of the earth in km
    var dLat = deg2rad(lat2 - lat1); // deg2rad below
    var dLon = deg2rad(lon2 - lon1);
    var a = Math.sin(dLat / 2) * Math.sin(dLat / 2) +
        Math.cos(deg2rad(lat1)) *
            Math.cos(deg2rad(lat2)) *
            Math.sin(dLon / 2) *
            Math.sin(dLon / 2);
    var c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1 - a));
    var d = R * c; // Distance in km
    return d;
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
    Future gps = _getCurrentLocation();
    Future<List<Company>> copf = _apiServiceCop.getCop();

    pr = new ProgressDialog(context, showLogs: true);
    pr.style(
      message: "Buscando localização...",
      backgroundColor: Colors.deepOrange,
      messageTextStyle: TextStyle(color: Colors.white, fontSize: 18.0),
    );

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
                future: Future.wait([gps, copf]),
                builder: (BuildContext context,
                    AsyncSnapshot<List<dynamic>> snapshot) {
//                      _getCurrentLocation();
                  List<Company> cop;

                  try {
                    cop = snapshot.data[1];
                  } catch (e) {}

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
                  } else if (snapshot.connectionState == ConnectionState.done &&
                      snapshot.data != null) {
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

                                        _getCurrentLocation();
                                        if (_currentPosition == null &&
                                            index == 0) {
                                          return Column(
                                            children: [
                                              Center(
                                                child: Icon(
                                                  Icons.not_interested,
                                                  color: Colors.red,
                                                  size: 100.0,
                                                ),
                                              ),
                                              Center(
                                                child: Text(
                                                    'POR FAVOR, PERMITA O APP USAR O GPS PARA CONTINUAR COM A BUSCA!'),
                                              ),
                                              Center(
                                                child: FloatingActionButton(
                                                  child: Icon(Icons.update),
                                                  onPressed: () {
                                                    refreshList();
//                                                  setState(() {
//
//                                                  });
                                                  },
                                                ),
                                              )
                                            ],
                                          );
                                        }

                                        double totalDistance =
                                            calculateDistance(
                                                _currentPosition.latitude,
                                                _currentPosition.longitude,
                                                double.parse(items[index].lat),
                                                double.parse(items[index].lon));

                                        return widget.title.toLowerCase() ==
                                                    items[index]
                                                        .category
                                                        .toLowerCase() &&
                                                totalDistance <= 5
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
                                                    height: 170.0,
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
                                                          height: 170,
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
                                                                ),
                                                                Padding(
                                                                  padding: EdgeInsets
                                                                      .fromLTRB(
                                                                      0,
                                                                      5,
                                                                      0,
                                                                      2),
                                                                  child:
                                                                  items[index].status == "Disponível" ? Container(
                                                                    width: 200,
                                                                    child: Text(

                                                                      items[index]
                                                                          .status + " para entregas",
                                                                      style: TextStyle(
                                                                          fontSize:
                                                                          15,
                                                                          color: Colors.green),
                                                                    ),
                                                                  ) : Container(
                                                                    width: 200,
                                                                    child: Text(

                                                                      items[index]
                                                                          .status + " para entregas",
                                                                      style: TextStyle(
                                                                          fontSize:
                                                                          15,
                                                                          color: Colors.red),
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
                    return Column(
                      children: [
                        Container(
                          height: 50,
                        ),
                        Center(
                          child: CircularProgressIndicator(),
                        ),
                        Container(
                          height: 50,
                        ),
                        Center(
                          child: Text(
                            "SE DEMORAR, VERIFIQUE SUA CONEXÃO OU SE SEU GPS ESTAR ATIVO!",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
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
