import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:amigodelivery/api/api_service_prod.dart';
import 'package:amigodelivery/model/product.dart';
import 'package:amigodelivery/pages/product_detail.dart';

class SearchList extends StatefulWidget {
  final header;
  final id_cop;
  final cpf;
  final id;
  final email;

  SearchList({Key key, this.header, this.id_cop, this.email, this.cpf, this.id})
      : super(key: key);

  @override
  _SearchListState createState() => _SearchListState();
}

class _SearchListState extends State<SearchList> {
  ApiServiceProd apiService;

  final key = GlobalKey<ScaffoldState>();

  TextEditingController editingController = TextEditingController();

  List<Product> items;
  List<Product> duplicateItems;
  var refreshKey = GlobalKey<RefreshIndicatorState>();

  @override
  void initState() {
    duplicateItems = List<Product>();
    items = List<Product>();
    apiService = ApiServiceProd();
    super.initState();
  }

  Future<Null> refreshList() async {
    refreshKey.currentState?.show(atTop: false);
    setState(() {});
  }

  void filterSearchResults(String query) {
    List<Product> dummySearchList = List<Product>();
    dummySearchList.addAll(duplicateItems);
    if (query.isNotEmpty) {
      List<Product> dummyListData = List<Product>();

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
      appBar: AppBar(
        centerTitle: true,
        elevation: 10.0,
        backgroundColor: Colors.deepOrange,
        title: Text(widget.header, style: TextStyle(color: Colors.white)),
      ),
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
                future: apiService.getProductIdAll(widget.id),
                builder: (BuildContext context,
                    AsyncSnapshot<List<Product>> snapshot) {
                  List<Product> cop = snapshot.data;

                  if (items == null || items.isEmpty) {
                    items = cop;
                    duplicateItems = cop;
                  }

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
                                  child: Text('NENHUM PRODUTO ENCONTRADO'),
                                ),
                              ],
                            ),
                          ],
                        );
                      } else {
                        if (items == null || items.isEmpty) {
                          return Column(
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
                                child: Text('NENHUM PRODUTO ENCONTRADO'),
                              ),
                            ],
                          );
                        } else {
                          return Expanded(
                              child: RefreshIndicator(
                                  onRefresh: refreshList,
                                  key: refreshKey,
                                  child: ListView.builder(
                                    shrinkWrap: true,
                                    itemCount: items.length,
                                    itemBuilder: (context, index) {
                                      return items.length >= 1
                                          ? GestureDetector(
                                              onTap: () {
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (context) =>
                                                          ProductDetails(
                                                        name: items[index].name,
                                                        price:
                                                            items[index].price,
                                                        picture:
                                                            items[index].image,
                                                        mark: items[index].mark,
                                                        info: items[index].info,
                                                        email: widget.email,
                                                        cpf: widget.cpf,
                                                        id: widget.id_cop,
                                                      ),
                                                    ));
                                              },
                                              child: Card(
                                                elevation: 5,
                                                child:
                                                    new SingleChildScrollView(
                                                        child: Container(
                                                  height: 130.0,
                                                  child: Row(
                                                    children: <Widget>[
                                                      Container(
                                                          height: 120.0,
                                                          width: 80.0,
                                                          decoration:
                                                              BoxDecoration(
                                                            borderRadius: BorderRadius.only(
                                                                bottomLeft: Radius
                                                                    .circular(
                                                                        5),
                                                                topLeft: Radius
                                                                    .circular(
                                                                        5)),
                                                            image: DecorationImage(
                                                                fit: BoxFit
                                                                    .cover,
                                                                image: MemoryImage(
                                                                    base64Decode(
                                                                        items[index]
                                                                            .image))),
                                                          )),
                                                      Container(
                                                        height: 150,
                                                        child: Padding(
                                                          padding: EdgeInsets
                                                              .fromLTRB(
                                                                  10, 10, 0, 0),
                                                          child: Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: <Widget>[
                                                              Text(
                                                                items[index]
                                                                    .name,
                                                                style: TextStyle(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold),
                                                              ),
                                                              Divider(),
                                                              Text(
                                                                  "R\$ " +
                                                                      items[index]
                                                                          .price,
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                          .deepOrange)),
                                                              Padding(
                                                                padding:
                                                                    EdgeInsets
                                                                        .fromLTRB(
                                                                            0,
                                                                            5,
                                                                            0,
                                                                            2),
                                                                child:
                                                                    Container(
                                                                  width: 260,
                                                                  child: Text(
                                                                    items[index]
                                                                        .info,
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
                                          : Divider(
                                              color: Colors.white,
                                            );
                                    },
                                  )));
                        }
                      }
                    }
                  } else {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                },
              )
            ],
          )
        ],
      ),
    );
  }
}
