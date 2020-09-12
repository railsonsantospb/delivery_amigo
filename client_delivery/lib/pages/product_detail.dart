import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:amigodelivery/api/api_service_prod_cart.dart';
import 'package:amigodelivery/components/login_screen_3.dart';
import 'package:amigodelivery/home.dart';
import 'package:amigodelivery/model/product_cart.dart';
import 'package:progress_dialog/progress_dialog.dart';

GlobalKey<ScaffoldState> _scaffoldState = GlobalKey<ScaffoldState>();

class ProductDetails extends StatefulWidget {
  final name;
  final price;
  final picture;
  final mark;
  final info;
  final email;
  final id;
  final cpf;

  ProductDetails(
      {this.name,
      this.price,
      this.picture,
      this.mark,
      this.info,
      this.email,
      this.id,
      this.cpf});

  @override
  _ProductDetailsState createState() => _ProductDetailsState();
}

class _ProductDetailsState extends State<ProductDetails> {
  ApiServiceProdCart apiService;
  ProgressDialog pr1;
  BuildContext context;
  String carts = "";

  @override
  void initState() {
    apiService = ApiServiceProdCart();
    super.initState();
  }

  alertShow(String show) {
    Widget cancelaButton = FlatButton(
      child: Text("OK"),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );

    AlertDialog alert = AlertDialog(
      content: Text(show),
      actions: [
        cancelaButton,
      ],
    );

    //exibe o diálogo
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    this.context = context;
    pr1 = new ProgressDialog(context, showLogs: true);
    pr1.style(
      message: "Salvando...",
      backgroundColor: Colors.deepOrange,
      messageTextStyle: TextStyle(color: Colors.white, fontSize: 18.0),
    );
    return Scaffold(
      key: _scaffoldState,
      appBar: new AppBar(
        elevation: 0.0,
        backgroundColor: Colors.deepOrange,
        title: InkWell(
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => HomePage1()));
            },
            child: Center(child: Text('Amigo Delivery'))),
      ),
      body: new ListView(
        children: <Widget>[
          new Container(
            height: 270.0,
            child: GridTile(
              child: Container(
                color: Colors.white,
                child: Image.memory(
                  base64Decode(widget.picture),
                ),
              ),
              footer: new Container(
                color: Colors.white70,
                child: ListTile(
                  title: new Row(
                    children: <Widget>[
                      Expanded(
                        child: new Text(
                          "${widget.name}",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, color: Colors.black),
                        ),
                      ),
                    ],
                  ),
                  subtitle: new Row(
                    children: <Widget>[
                      Expanded(
                        child: new Text(
                          "R\$ ${widget.price}",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.deepOrange),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // ===== the first buttons

          Row(
            children: <Widget>[
              // ===== the send button
              Expanded(
                child: MaterialButton(
                  onPressed: () {
                    if (widget.email == "convidado@convidado.com") {
                      Navigator.pushAndRemoveUntil(
                        context,
                        CupertinoPageRoute(
                            builder: (context) => LoginScreen3()),
                        (Route<dynamic> route) => false,
                      );
                    } else {
                      pr1.show();
                      ProductCart cart = ProductCart(
                          email: widget.email,
                          image: widget.picture,
                          mark: widget.mark,
                          info: widget.info,
                          name: widget.name,
                          price: widget.price,
                          id: widget.id);


                      Future.delayed(const Duration(seconds: 2), () {

                        apiService.createProduct(cart).then((isSuccess) {

                          if (isSuccess) {
                            _scaffoldState.currentState.showSnackBar(SnackBar(
                                backgroundColor: Colors.green,
                                content: Text(
                                    "O Produto foi Adicionado no Carrinho!")));
                            pr1.hide();
                          } else {
                            _scaffoldState.currentState.showSnackBar(SnackBar(
                                backgroundColor: Colors.red,
                                content: Text(
                                    "Falha ao Adicionar no Carrinho ou Verifique sua Conexão!")));
                            pr1.hide();
                          }
                        });

                      });
                    }
                  },
                  color: Colors.deepOrange,
                  textColor: Colors.white,
                  child: new Text("ADICIONAR NO CARRINHO"),
                ),
              ),

              new IconButton(
                iconSize: 50,
                icon: Icon(
                  Icons.add_shopping_cart,
                  color: Colors.deepOrange,
                ),
              ),
            ],
          ),

          Divider(
            color: Colors.grey,
          ),

          new ListTile(
            title: new Text(
              "Detalhes do Produto",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Divider(),
          // add product condition
          new Wrap(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.fromLTRB(12.0, 5.0, 5.0, 5.0),
                child: new Text(
                  "Informações do Produto:",
                  style: TextStyle(color: Colors.grey, fontSize: 18.0),
                ),
              ),
            ],
          ),

          new Wrap(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.fromLTRB(12.0, 5.0, 5.0, 5.0),
                child: Text(
                  widget.info,
                  style: TextStyle(fontSize: 18.0),
                ),
              ),
            ],
          ),
          Divider(),
          new Wrap(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.fromLTRB(12.0, 5.0, 5.0, 5.0),
                child: new Text(
                  "Marca do Produto:",
                  style: TextStyle(color: Colors.grey, fontSize: 18.0),
                ),
              ),

              // remember create product brand
            ],
          ),
          new Wrap(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.fromLTRB(12.0, 5.0, 5.0, 5.0),
                child: Text(widget.mark, style: TextStyle(fontSize: 18.0)),
              ),
            ],
          )
        ],
      ),
    );
  }
}
