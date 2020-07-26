import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:amigodelivery/api/api_service_company.dart';
import 'package:amigodelivery/model/company.dart';

class MyCard extends StatefulWidget {
  final cpf;
  MyCard({Key key, this.cpf}) : super(key: key);

  @override
  _MyCardState createState() => _MyCardState();
}

class _MyCardState extends State<MyCard> {
  ApiServiceCop apiService;

  Future<List<Company>> _cops;

  Future<List<Company>> getCopValues() {
    setState(() {
      _cops = apiService.getCopCpf(widget.cpf);
    });
  }

  @override
  void initState() {
    super.initState();
    apiService = ApiServiceCop();
    _cops = apiService.getCopCpf(widget.cpf);
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      //hit Ctrl+space in intellij to know what are the options you can use in flutter widgets
      body: SafeArea(
        child: FutureBuilder(
          future: _cops,
          builder:
              (BuildContext context, AsyncSnapshot<List<Company>> snapshot) {
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
              List<Company> rx = snapshot.data;

//            print(cat);
              if (rx == null) {
                return Stack(
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
                );
              } else {
                return Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 8.0, horizontal: 8.0),
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      Company rxs = rx[index];

                      return Padding(
                        padding: const EdgeInsets.only(top: 0.0),
                        child: Card(
                          elevation: 10.0,
                          child: ListTile(
                            title: Center(child: new Text("Dados da Empresa")),
                            subtitle: Align(
                                child: Column(
                              children: <Widget>[
                                new Row(
                                  // section the gelada ou natural
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Card(
                                      semanticContainer: true,
                                      clipBehavior: Clip.antiAliasWithSaveLayer,
                                      child: Center(
                                          child: Image.memory(
                                        base64Decode(rxs.image),
                                        cacheHeight: 150,
                                        cacheWidth: 220,
                                      )),
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                      ),
                                      elevation: 5,
                                      margin: EdgeInsets.all(10),
                                    ),
                                  ],
                                ),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Container(
                                      width: 120,
                                      decoration: BoxDecoration(
                                          border:
                                              Border.all(color: Colors.white),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(10))),
                                      child: new FlutterRatingBar(
                                        itemSize: 20,
                                        initialRating: double.parse(rxs.rating),
                                        fillColor: Colors.deepOrange,
                                        borderColor:
                                            Colors.deepOrange.withAlpha(50),
                                        allowHalfRating: true,
                                      ),
                                    ),
                                  ],
                                ),
                                new Row(
                                  // section the gelada ou natural
                                  children: <Widget>[
                                    Padding(
                                      padding: const EdgeInsets.all(0.0),
                                      child: new Text("Nome da Empresa: "),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(4.0),
                                      child: new Text(
                                        rxs.name,
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
                                      child: new Text("Nome do Proprietário: "),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(4.0),
                                      child: new Text(
                                        rxs.owner,
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
                                        rxs.address,
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
                                      child: new Text("Telefone: "),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(4.0),
                                      child: new Text(
                                        rxs.phone,
                                        style:
                                            TextStyle(color: Colors.deepOrange),
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
                    itemCount: rx.length,
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
      ),
    );
  }
}
