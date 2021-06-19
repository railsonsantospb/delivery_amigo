import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:amigodelivery/api/api_service_prod.dart';
import 'package:amigodelivery/model/product.dart';
import 'package:amigodelivery/pages/product_detail.dart';

class Products extends StatefulWidget {
  String cpf;
  String email;
  final id;

  Products({this.cpf, this.email, this.id});
  @override
  _ProductsState createState() => _ProductsState();
}

class _ProductsState extends State<Products> {
  ApiServiceProd apiService;

  @override
  void initState() {
    apiService = ApiServiceProd();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: FutureBuilder(
        future: apiService.getProduct(widget.cpf),
        builder: (BuildContext context, AsyncSnapshot<List<Product>> snapshot) {
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
                      Center(
                        child: Text('SE PERSISTIR CONTATE O SUPORTE'),
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
                        Center(
                          child: Text('SE PERSISTIR CONTATE O SUPORTE'),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            } else {
              if (prod.isEmpty) {
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
                if(prod != null && prod.isNotEmpty){
                  prod = prod.reversed.toList();
                }

                return prod == null || prod.isEmpty
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
                            child: Text('NENHUM PRODUTO ENCONTRADO'),
                          ),
                        ],
                      )
                    : GridView.builder(
                        shrinkWrap: true,
                        itemCount: prod.length >= 10 ? 10 : prod.length,
                        gridDelegate:
                            new SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2),
                        itemBuilder: (BuildContext context, int index) {
                          return Card(
                            child: Hero(
                              tag: new Text("hero 1"),
                              child: Material(
                                child: InkWell(
                                  onTap: () => Navigator.of(context)
                                      .push(new MaterialPageRoute(
                                    // here we are passing the values of the products
                                    // to the product details
                                    builder: (context) => new ProductDetails(
                                      name: prod[index].name,
                                      price: prod[index].price,
                                      picture: prod[index].image,
                                      mark: prod[index].mark,
                                      info: prod[index].info,
                                      email: widget.email,
                                      id: widget.id,
                                      cpf: widget.cpf,
                                    ),
                                  )),
                                  child: GridTile(
                                    footer: Container(
                                      padding: const EdgeInsets.all(9.0),
                                      color: Colors.white70,
                                      child: new Row(
                                        children: <Widget>[
                                          Expanded(
                                            child: Text(
                                              prod[index].name,
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 16.0),
                                            ),
                                          ),
                                          new Text(
                                            "R\$${prod[index].price}",
                                            style: TextStyle(
                                                color: Colors.deepOrange,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ],
                                      ),
                                    ),
                                    child: Image.memory(
                                      base64Decode(prod[index].image),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          );
                        });
              }
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
}
