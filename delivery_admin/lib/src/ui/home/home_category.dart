import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:deliveryadmin/src/api/api_service_cat.dart';
import 'package:deliveryadmin/src/model/category.dart';
import 'package:deliveryadmin/src/model/company.dart';
import 'package:deliveryadmin/src/ui/formadd/form_category.dart';
import 'dart:convert';
import 'package:flutter/widgets.dart';
import 'package:deliveryadmin/src/ui/home/home_product.dart';

GlobalKey<ScaffoldState> _scaffoldState = GlobalKey<ScaffoldState>();

class HomeCategory extends StatefulWidget {
  Company data;

  HomeCategory({this.data});

  @override
  _HomeCategoryState createState() => _HomeCategoryState();
}

class _HomeCategoryState extends State<HomeCategory> {
  BuildContext context;
  ApiServiceCat apiService;

  @override
  void initState() {
    super.initState();
    apiService = ApiServiceCat();
  }

  refresh() {
    setState(() {});
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
              title: Text('Catálagos',
                  style: TextStyle(height: -200, color: Colors.blue)),
            )),
        key: _scaffoldState,
        body: SafeArea(
          child: FutureBuilder(
            future: apiService.getCategory(widget.data.cpf_cnpj),
            builder:
                (BuildContext context, AsyncSnapshot<List<Category>> snapshot) {
              List<Category> cat = snapshot.data;

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
                if (cat == null) {
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
                  if (cat.isEmpty) {
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
                              child: Text('NENHUM CATÁLOGO CADASTRADO'),
                            ),
                          ],
                        ),
                      ],
                    );
                  } else {
                    return _buildListView(cat);
                  }
                }
              } else {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
            },
          ),
        ),
        floatingActionButton: FloatingActionButton(
            child: Icon(
              Icons.add,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.push(_scaffoldState.currentContext,
                  CupertinoPageRoute(builder: (BuildContext context) {
                return FormAddCategory(
                  notifyParent: refresh,
                  cpf: widget.data.cpf_cnpj,
                );
              }));
            }),
      ),
    );
  }

  Widget _buildListView(List<Category> cats) {
    return cats == null
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
            padding:
                const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
            child: ListView.builder(
              itemBuilder: (context, index) {
                Category cat = cats[index];

                return Padding(
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
                                cat.name.toUpperCase(),
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                          Divider(),
                          Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(150),
                                  child: Image.memory(
                                    base64Decode(cat.image),
                                    cacheHeight: 250,
                                    cacheWidth: 250,
                                  ),
                                ),
                              ]),
                          Divider(),
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
                                              "Você quer excluir a categoria ${cat.name}?"),
                                          actions: <Widget>[
                                            FlatButton(
                                              child: Text("SIM"),
                                              onPressed: () {
                                                Navigator.pop(context);
                                                apiService
                                                    .deleteCategory(cat.id)
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
                                    return FormAddCategory(
                                      cat: cat,
                                      notifyParent: refresh,
                                      cpf: widget.data.cpf_cnpj,
                                    );
                                  }));
                                },
                                child: Text(
                                  "EDITAR",
                                  style: TextStyle(color: Colors.blue),
                                ),
                              ),
                              FlatButton(
                                onPressed: () {
                                  Navigator.push(context,
                                      CupertinoPageRoute(builder: (context) {
                                    return HomeProduct(
                                      cpf: widget.data.cpf_cnpj,
                                      id: cat.id,
                                      name: cat.name,
                                    );
                                  }));
                                },
                                child: Text(
                                  "ESTOQUE",
                                  style: TextStyle(color: Colors.green),
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
              itemCount: cats.length,
            ),
          );
  }
}
