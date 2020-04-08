import 'package:badges/badges.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:carousel_pro/carousel_pro.dart';
import 'package:flutter/services.dart';
import 'package:jonasbebidas/components/corpo.dart';
import 'package:flutter/cupertino.dart';

import 'package:jonasbebidas/components/horizontal_listcategories.dart';
import 'package:jonasbebidas/components/login_screen_3.dart';
import 'package:jonasbebidas/components/pedidos_h.dart';
import 'package:jonasbebidas/components/products.dart';
import 'package:jonasbebidas/pages/cart.dart';

class HomePage1 extends StatefulWidget {
  final name;
  final email;

  HomePage1({this.name, this.email});

  @override
  _HomePage1State createState() => _HomePage1State();
}

class _HomePage1State extends State<HomePage1> {

  int selectedIndex = 0;
  final widgetOptions = [
    Corpo(),
    Cart(),
    Pedidos(),
    Text("Person"),
    Text("Conta"),
  ];

  Color getColor() {
    if (1 == 0) {
      return Colors.red;
    } else {
      return Colors.blueGrey;
    }
  }

  @override
  Widget build(BuildContext context) {


    void onItemTapped(int index) {
      setState(() {
        selectedIndex = index;
      });
    }

    return Scaffold(
      appBar: new AppBar(
        centerTitle: true,
        elevation: 10.0,
        backgroundColor: Colors.deepOrange,
        title: Text('Jonas Bebidas'),

        actions: <Widget>[
          IconButton(icon: Icon(

              Icons.exit_to_app, size: 30.0, color: Colors.white), onPressed: (){
            Navigator.pushAndRemoveUntil(
              context,
              CupertinoPageRoute(builder: (context) => LoginScreen3()),
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
                  child: Icon(Icons.person, color: Colors.white,),
                ),
              ),
              decoration: new BoxDecoration(
                  color: Colors.deepOrange
              ),
            ),
//            body


            InkWell(
              onTap: (){
                Navigator.push(context, MaterialPageRoute(
                  builder: (context)=> Pedidos(),
                ));
              },
              child: ListTile(
                title: Text('Meus Pedidos'),
                leading: Icon(Icons.shopping_basket, color: Colors.deepOrange,),
              ),
            ),
            InkWell(
              onTap: (){
                Navigator.push(context, MaterialPageRoute(
                  builder: (context)=> Cart(),
                ));
              },
              child: ListTile(
                title: Text('Meu Carrinho'),
                leading: Icon(Icons.shopping_cart, color: Colors.deepOrange,),
              ),
            ),

            Divider(),


            InkWell(
              onTap: (){
                Navigator.pushAndRemoveUntil(
                  context,
                  CupertinoPageRoute(builder: (context) => LoginScreen3()),
                      (Route<dynamic> route) => false,
                );
              },
              child: ListTile(
                title: Text('Sair'),
                leading: Icon(Icons.close, color: Colors.green,),
              ),
            ),
          ],
        ),
      ),


      body: Center(
        child: widgetOptions.elementAt(selectedIndex),
      ),

        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.deepOrange,
    items: <BottomNavigationBarItem>[


      BottomNavigationBarItem(

          icon: Icon(Icons.home, size: 30.0,),
          title: Text('início')
      ),


      BottomNavigationBarItem(


        icon: Badge(
          badgeColor: getColor(),
          position: BadgePosition.topRight(top: -10, right: -10),

          badgeContent: Text('3', style: TextStyle(color: Colors.white),),
          child: Icon(
              Icons.shopping_cart, size: 30.0,),

        ),
        title: Text('Carrinho'),
      ),
      BottomNavigationBarItem(
          icon:  Icon(Icons.shopping_basket, size: 30.0,),
          title: Text('Pedidos')
      ),
      BottomNavigationBarItem(
          icon:  Icon(Icons.info, size: 30.0,),
          title: Text('Sobre')
      ),

    ],
    currentIndex: selectedIndex,
    fixedColor: Colors.white,
    onTap: onItemTapped,
    ),);

  }
}

