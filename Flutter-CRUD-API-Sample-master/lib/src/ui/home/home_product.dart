import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_crud_api_sample_app/src/api/api_service_prod.dart';
import 'package:flutter_crud_api_sample_app/src/model/product.dart';
import 'dart:convert';
import 'package:flutter/widgets.dart';
import 'package:flutter_crud_api_sample_app/src/ui/formadd/form_product.dart';

GlobalKey<ScaffoldState> _scaffoldState = GlobalKey<ScaffoldState>();

class HomeProduct extends StatefulWidget {
  int id;
  String name;

  HomeProduct({this.id, this.name});

  @override
  _HomeProductState createState() => _HomeProductState();
}

class _HomeProductState extends State<HomeProduct> {
  BuildContext context;
  ApiServiceProd apiService;

  @override
  void initState() {
    super.initState();
    apiService = ApiServiceProd();
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
        key: _scaffoldState,

        body: SafeArea(
          child: FutureBuilder(
            future: apiService.getProductId(widget.id),
            builder: (BuildContext context, AsyncSnapshot<List<Product>> snapshot) {

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

                        ],
                      ),
                    ],
                  ),
                );
              } else if (snapshot.connectionState == ConnectionState.done) {
                List<Product> prod = snapshot.data;

                if (prod.isEmpty == true) {
                  return  Stack(
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
                            child: Text('NENHUM(A) ' +
                                widget.name.toUpperCase() +
                                ' CADASTRADA'),
                          ),
                        ],
                      ),
                    ],
                  );
                } else {
                  return  _buildListView(prod);
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
            onPressed: (){
              Navigator.push(_scaffoldState.currentContext,
                  CupertinoPageRoute(builder: (context) {
                    return FormAddProduct(id: widget.id.toString(), notifyParent: refresh);
                  }));
            }

        ),
      ),
    );
  }


  Widget _buildListView(List<Product> prods) {

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: ListView.builder(
        itemBuilder: (context, index) {
          Product prod = prods[index];

          return prod.id == 0 ? Stack(
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
          ) : Padding(
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

                    Row(mainAxisAlignment: MainAxisAlignment.center,children: <Widget>[
                      ClipRRect(
                        borderRadius: BorderRadius.circular(150),
                        child: Image.memory(
                          base64Decode(prod.image),
                          cacheHeight: 250,
                          cacheWidth: 250,
                        ),
                      ),
                    ]),

//                    Text(cat.image),

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
                                                  .showSnackBar(SnackBar(backgroundColor: Colors.green,
                                                      content: Text(
                                                          "Excluído com Sucesso")));
                                            } else {
                                              Scaffold.of(this.context)
                                                  .showSnackBar(SnackBar(backgroundColor: Colors.red,
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
                              return FormAddProduct(prod: prod, notifyParent: refresh);
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
        itemCount: prods.length,
      ),
    );
  }
}
