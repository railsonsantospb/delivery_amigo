import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:amigodelivery/api/api_service_prod_cart.dart';
import 'package:amigodelivery/components/form_compra.dart';
import 'package:amigodelivery/controller/mobx_cart.dart';
import 'package:amigodelivery/model/product_cart.dart';
import 'package:amigodelivery/pages/product_detail.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

class Cart_products extends StatefulWidget {
  final email;
  final id;
  final name;
  final cpf;

  Cart_products({this.email, this.id, this.name, this.cpf});

  @override
  _Cart_productsState createState() => _Cart_productsState();
}

class _Cart_productsState extends State<Cart_products> {
  String teamName = '';
  ApiServiceProdCart apiService;
  String val;
  Future<List<ProductCart>> _c;
  List<ProductCart> carts;
  double prices = 0;

  Future<List<ProductCart>> retornarP() async {
    setState(() {
      _c = apiService.getProductId(widget.email, widget.id);
    });
  }

  removeValues() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    await prefs.clear();
  }

  @override
  void initState() {
    apiService = ApiServiceProdCart();
    super.initState();
    _c = apiService.getProductId(widget.email, widget.id);
  }

  @override
  Widget build(BuildContext context) {
    final value = Controller();

    return new Scaffold(
      body: FutureBuilder(
        future: _c,
        builder:
            (BuildContext context, AsyncSnapshot<List<ProductCart>> snapshot) {
          List<ProductCart> cart = snapshot.data;

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
            if (cart == null) {
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
              if (cart.isEmpty) {
                return Stack(
                  children: <Widget>[
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Center(
                          child: Icon(
                            Icons.add_shopping_cart,
                            color: Colors.red,
                            size: 100.0,
                          ),
                        ),
                        Center(
                          child: Text('ADICIONE PRODUTOS NO CARRINHO'),
                        ),
                      ],
                    ),
                  ],
                );
              } else {
                Future.delayed(const Duration(milliseconds: 0), () {
                  carts = cart;
                });

                for (final i in cart) {
                  prices += double.parse(i.price);
                }

                return ListView.builder(
                    itemCount: cart.length,
                    itemBuilder: (context, index) {
                      Future.delayed(const Duration(milliseconds: 0), () {
                        value.increment(
                            double.parse(cart[index].price) * cart[index].qtd);
                      });

                      return ListTile(
                        title: Card(
                          child: ListTile(
                            leading: GestureDetector(
                              onTap: () => Navigator.of(context)
                                  .push(new MaterialPageRoute(
                                // here we are passing the values of the products
                                // to the product details
                                builder: (context) => new ProductDetails(
                                  name: cart[index].name,
                                  price: cart[index].price,
                                  picture: cart[index].image,
                                  mark: cart[index].mark,
                                  info: cart[index].info,
                                  email: widget.email,
                                  id: widget.id,
                                ),
                              )),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(5),
                                child: Image.memory(
                                  base64Decode(cart[index].image),
                                  cacheHeight: 150,
                                  cacheWidth: 120,
                                ),
                              ),
                            ),
                            title: new Text(cart[index].name),
                            subtitle: new Column(
                              children: <Widget>[
                                // row inside of the column
                                new Row(
                                  // section the gelada ou natural
                                  children: <Widget>[
                                    Padding(
                                      padding: const EdgeInsets.all(0.0),
                                      child: new Text("Marca:"),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(4.0),
                                      child: new Text(
                                        cart[index].mark,
                                        style:
                                            TextStyle(color: Colors.deepOrange),
                                      ),
                                    ),
                                  ],
                                ),

                                new Container(
                                  alignment: Alignment.topLeft,
                                  child: new Text(
                                    "R\$ ${cart[index].price}",
                                    style: TextStyle(
                                      fontSize: 17.0,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.deepOrange,
                                    ),
                                  ),
                                ),
                                new Row(
                                  // section the gelada ou natural
                                  children: <Widget>[
                                    new IconButton(
                                        icon: Icon(
                                          Icons.add,
                                          color: Colors.deepOrange,
                                          size: 30.0,
                                        ),
                                        onPressed: () {
                                          apiService
                                              .updateCart(cart[index].id,
                                                  cart[index].qtd + 1)
                                              .then((isSuccess) {
                                            if (isSuccess) {
                                              setState(() {
                                                retornarP();
                                              });
                                            } else {
                                              Scaffold.of(this.context)
                                                  .showSnackBar(SnackBar(
                                                      backgroundColor:
                                                          Colors.red,
                                                      content: Text(
                                                          "Falha ao Adicionar ou Verifique sua Conexão")));
                                            }
                                          });
                                        }),
                                    new InkWell(
                                        customBorder: CircleBorder(),
                                        onTap: () {
                                          showDialog(
                                              context: context,
                                              builder: (context) {
                                                return AlertDialog(
                                                  title: Text(
                                                      'Digite a quantidade'),
                                                  content: new Row(
                                                    children: <Widget>[
                                                      new Expanded(
                                                          child: new TextField(
                                                        autofocus: true,
                                                        decoration:
                                                            new InputDecoration(
                                                                labelText:
                                                                    cart[index]
                                                                        .name,
                                                                hintText:
                                                                    'Quantidade do produto'),
                                                        onChanged: (value) {
                                                          teamName = value;
                                                        },
                                                      ))
                                                    ],
                                                  ),
                                                  actions: <Widget>[
                                                    FlatButton(
                                                      child: Text('Ok'),
                                                      onPressed: () {
                                                        final alphanumeric =
                                                            RegExp(r'^[0-9]+$');
                                                        if (alphanumeric
                                                            .hasMatch(
                                                                teamName)) {
                                                          apiService
                                                              .updateCart(
                                                                  cart[index]
                                                                      .id,
                                                                  int.parse(
                                                                      teamName))
                                                              .then(
                                                                  (isSuccess) {
                                                            if (isSuccess) {
                                                              setState(() {
                                                                retornarP();
                                                              });
                                                            } else {
                                                              Scaffold.of(this
                                                                      .context)
                                                                  .showSnackBar(SnackBar(
                                                                      backgroundColor:
                                                                          Colors
                                                                              .red,
                                                                      content: Text(
                                                                          "Falha ao Adicionar ou Verifique sua Conexão")));
                                                            }
                                                          });
                                                        }

                                                        Navigator.pop(context);
                                                      },
                                                    ),
                                                  ],
                                                );
                                              });
                                        },
                                        child: Padding(
                                          padding: EdgeInsets.fromLTRB(
                                              14.0, 5.0, 14.0, 5.0),
                                          child: Text(
                                            "${cart[index].qtd}",
                                            style: TextStyle(
                                                fontSize: 18.0,
                                                color: Colors.deepOrange,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        )),
                                    new IconButton(
                                        icon: Icon(
                                          Icons.remove,
                                          color: Colors.deepOrange,
                                          size: 40.0,
                                        ),
                                        onPressed: () {
                                          if (cart[index].qtd > 1) {
                                            apiService
                                                .updateCart(cart[index].id,
                                                    cart[index].qtd - 1)
                                                .then((isSuccess) {
                                              if (isSuccess) {
                                                setState(() {
                                                  retornarP();
                                                });
                                              } else {
                                                Scaffold.of(this.context)
                                                    .showSnackBar(SnackBar(
                                                        backgroundColor:
                                                            Colors.red,
                                                        content: Text(
                                                            "Falha ao Adicionar ou Verifique sua Conexão")));
                                              }
                                            });
                                          }
                                        }),
                                  ],
                                ),
                              ],
                            ),
                            trailing: new IconButton(
                                icon: Icon(
                                  Icons.delete,
                                  color: Colors.deepOrange,
                                  size: 40.0,
                                ),
                                onPressed: () {
                                  showDialog(
                                      context: context,
                                      builder: (context) {
                                        return AlertDialog(
                                          title: Text("Aviso!"),
                                          content: Text(
                                              "Você quer excluir o produto ${cart[index].name}?"),
                                          actions: <Widget>[
                                            FlatButton(
                                              child: Text("SIM"),
                                              onPressed: () {
                                                Navigator.pop(context);
                                                apiService
                                                    .deleteProduct(
                                                        cart[index].id)
                                                    .then((isSuccess) {
                                                  if (isSuccess) {
                                                    retornarP();
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
                                }),
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
      bottomNavigationBar: new Container(
        color: Colors.white,
        child: Row(
          children: <Widget>[
            Expanded(
              child: ListTile(
                title: new Text("Total: "),
                subtitle: Observer(
                  builder: (_) => Text(
                    "R\$ ${value.value.toStringAsFixed(2)}",
                    style: TextStyle(
                        fontSize: 18.0,
                        color: Colors.deepOrange,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: new MaterialButton(
                onPressed: () {
                  if (carts == null) {
                    Scaffold.of(this.context).showSnackBar(SnackBar(
                        backgroundColor: Colors.blue,
                        content:
                            Text("Por Favor, Adicione Produtos no Carrinho")));
                  } else {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => new MyAppForm(
                              email: widget.email,
                              name: widget.name,
                              cart: carts,
                              prices: value.value,
                              id_cop: widget.id,
                              cpf: widget.cpf),
                        ));
                  }
                },
                child: new Text(
                  "COMFIRMAR",
                  style: TextStyle(color: Colors.white),
                ),
                color: Colors.deepOrange,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
