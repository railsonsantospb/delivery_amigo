import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:deliveryadmin/src/api/api_service_prod.dart';
import 'package:deliveryadmin/src/model/product.dart';
import 'dart:convert';
import 'package:flutter/widgets.dart';
import 'package:deliveryadmin/src/ui/formadd/form_product.dart';

GlobalKey<ScaffoldState> _scaffoldState = GlobalKey<ScaffoldState>();

class HomeProduct extends StatefulWidget {
  final cpf;
  final id;
  final name;

  HomeProduct({this.id, this.name, this.cpf});

  @override
  _HomeProductState createState() => _HomeProductState();
}

class _HomeProductState extends State<HomeProduct> {
  BuildContext context;
  ApiServiceProd apiService;

  @override
  void initState() {
    apiService = ApiServiceProd();
    super.initState();
  }

  refresh() {
    if (this.mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    this.context = context;

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Colors.deepOrange,
        accentColor: Colors.deepOrange,
      ),
      home: Scaffold(
        appBar: PreferredSize(
            preferredSize: Size.fromHeight(30.0),
            child: AppBar(
              centerTitle: true,
              elevation: 10.0,
              backgroundColor: Colors.white,
              title: Text(widget.name.toUpperCase(),
                  style: TextStyle(height: -200, color: Colors.blue)),
            )),
        key: _scaffoldState,
        body: SafeArea(
          child: FutureBuilder(
            future: apiService.getProductId(widget.id),
            builder:
                (BuildContext context, AsyncSnapshot<List<Product>> snapshot) {
              List<Product> prod = snapshot.data;

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
                        ],
                      ),
                    ],
                  ),
                );
              } else if (snapshot.connectionState == ConnectionState.done) {
                if (prod == null) {
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
                          ],
                        ),
                      ],
                    ),
                  );
                } else if (prod.isEmpty == true) {
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
                            child: Text('SEM CADASTROS'),
                          ),
                        ],
                      ),
                    ],
                  );
                } else {
                  return _buildListView(prod);
                }
              } else {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
              return Container(
                child: Text(prod[0].cpf),
              );
            },
          ),
        ),
        floatingActionButton: FloatingActionButton(
            child: Icon(
              Icons.add,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.push(context, CupertinoPageRoute(builder: (context) {
                return FormAddProduct(
                    id: widget.id.toString(),
                    notifyParent: refresh,
                    cpf: widget.cpf);
              }));
            }),
      ),
    );
  }

  Widget _buildListView(List<Product> prods) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: ListView.builder(
        itemCount: prods == null ? 0 : prods.length,
        itemBuilder: (context, index) {
          Product prod = prods[index];

          return prod.id == 0
              ? Stack(
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
                      ],
                    ),
                  ],
                )
              : Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.all(2.0),
                            child: Center(
                              child: Text(
                                prod.name.toUpperCase(),
                                style: Theme.of(context).textTheme.title,
                              ),
                            ),
                          ),
                          Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(150),
                                  child: Image.memory(
                                    base64Decode(prod.image),
                                    cacheHeight: 250,
                                    cacheWidth: 250,
                                  ),
                                ),
                              ]),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text("Status: "),
                              prod.active == 1
                                  ? Text(
                                      "Disponível",
                                      style: TextStyle(color: Colors.green),
                                    )
                                  : Text("Indisponível",
                                      style: TextStyle(color: Colors.red)),
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
                                              "Você quer excluir a bebida ${prod.name}?"),
                                          actions: <Widget>[
                                            FlatButton(
                                              child: Text("SIM"),
                                              onPressed: () {
                                                Navigator.pop(context);
                                                apiService
                                                    .deleteProduct(prod.id)
                                                    .then((isSuccess) {
                                                  if (isSuccess) {
                                                    setState(() {});
                                                    Scaffold.of(this.context)
                                                        .showSnackBar(SnackBar(
                                                            backgroundColor:
                                                                Colors.green,
                                                            content: Text(
                                                                "Excluído com Sucesso")));
                                                  } else {
                                                    Scaffold.of(this.context)
                                                        .showSnackBar(SnackBar(
                                                            backgroundColor:
                                                                Colors.red,
                                                            content: Text(
                                                                "Falha ao Excluir ou Verifique sua Conexão")));
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
                                  "EXCLUIR",
                                  style: TextStyle(color: Colors.red),
                                ),
                              ),
                              FlatButton(
                                onPressed: () {
                                  Navigator.push(context,
                                      CupertinoPageRoute(builder: (context) {
                                    return FormAddProduct(
                                        prod: prod, notifyParent: refresh);
                                  }));
                                },
                                child: Text(
                                  "EDITAR",
                                  style: TextStyle(color: Colors.blue),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                );
        },
      ),
    );
  }
}
