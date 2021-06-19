import 'package:badges/badges.dart';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:amigodelivery/api/api_service_prod_cart.dart';
import 'package:amigodelivery/components/card.dart';
import 'package:amigodelivery/components/cart_products.dart';
import 'package:amigodelivery/components/corpo.dart';
import 'package:flutter/cupertino.dart';
import 'package:amigodelivery/pages/companys.dart';
import 'package:flutter/widgets.dart';
import 'package:amigodelivery/pages/home_requestx.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class HomePage1 extends StatefulWidget {
  final name;
  final email;
  final cpf;
  final id;
 
  HomePage1({this.name, this.email, this.cpf, this.id});

  @override
  _HomePage1State createState() => _HomePage1State();
}

class _HomePage1State extends State<HomePage1> {
  int selectedIndex = 0;
  List<StatefulWidget> options;
  ApiServiceProdCart apiService;

  Timer timer;
  String valor;
  int seconds, minutes, hours;
  static const duration = const Duration(seconds: 1);

  List<StatefulWidget> opt() {
    final widgetOptions = [
      Corpo(
        cpf: widget.cpf,
        email: widget.email,
        id: widget.id,
      ),
      Cart_products(
        name: widget.name,
        email: widget.email,
        id: widget.id,
        cpf: widget.cpf,
      ),
      HomeRequestX(
        email: widget.email,
        id_cop: widget.id,
      ),
      MyCard(
        cpf: widget.cpf,
      ),
    ];
    return widgetOptions;
  }

  Color getColor() {
    if (valor == "0") {
      return Colors.blue;
    } else {
      return Colors.green;
    }
  }

  @override
  void initState() {
    if (this.mounted) {
      apiService = ApiServiceProdCart();
      timer = Timer.periodic(duration, (Timer t) {
        apiTime();
      });
    }
    options = opt();
    super.initState();
  }

  apiTime() {
    apiService.countCart(widget.email, widget.id).then((value) {
      if (this.mounted) {
        setState(() {
          valor = value;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    void onItemTapped(int index) {
      if (this.mounted) {
        setState(() {
          selectedIndex = index;
        });
      }
    }

    return Scaffold(
      appBar: new AppBar(
        centerTitle: true,
        elevation: 10.0,
        backgroundColor: Colors.deepOrange,
        title: Text('Amigo Delivery'),
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.exit_to_app, size: 30.0, color: Colors.white),
              onPressed: () {
                Navigator.pushAndRemoveUntil(
                  context,
                  CupertinoPageRoute(
                      builder: (context) =>
                          MyAppC(email: widget.email, name: widget.name)),
                  (Route<dynamic> route) => false,
                );
              }),
        ],
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
                  CupertinoPageRoute(
                      builder: (context) =>
                          MyAppC(email: widget.email, name: widget.name)),
                  (Route<dynamic> route) => false,
                );
              },
              child: ListTile(
                title: Text('Voltar'),
                leading: Icon(
                  Icons.exit_to_app,
                  color: Colors.redAccent,
                ),
              ),
            ),
          ],
        ),
      ),
      body: Center(
        child: options.elementAt(selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.deepOrange,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
              icon: Icon(
                Icons.home,
                size: 30.0,
              ),
              title: Text('Início')),
          BottomNavigationBarItem(
            icon: Badge(
              badgeColor: getColor(),
              position: BadgePosition.topRight(top: -10, right: -10),
              badgeContent: Text(
                valor == null ? "0" : valor.toString(),
                style: TextStyle(color: Colors.white),
              ),
              child: Icon(
                Icons.shopping_cart,
                size: 30.0,
              ),
            ),
            title: Text('Carrinho'),
          ),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.shopping_basket,
                size: 30.0,
              ),
              title: Text('Pedidos')),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.info,
                size: 30.0,
              ),
              title: Text('Empresa')),
        ],
        currentIndex: selectedIndex,
        fixedColor: Colors.white,
        onTap: onItemTapped,
      ),
    );
  }
}
