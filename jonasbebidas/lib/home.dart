import 'package:flutter/material.dart';
import 'package:carousel_pro/carousel_pro.dart';
import 'package:flutter/services.dart';

import 'package:jonasbebidas/components/horizontal_listcategories.dart';
import 'package:jonasbebidas/components/products.dart';
import 'package:jonasbebidas/pages/cart.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    Widget image_carousel = new Container(
      height: 180.0,
      child: new Carousel(
        boxFit: BoxFit.cover,
        images: [
          AssetImage('images/c1.jpg'),
          AssetImage('images/m1.jpg'),
          AssetImage('images/w1.jpg'),
        ],
        autoplay: true,
        animationCurve: Curves.fastOutSlowIn,
        animationDuration: Duration(milliseconds: 1000),
        dotSize: 0.0,
        indicatorBgPadding: 0.0,
        dotColor: Colors.transparent,
      ),
    );

    return Scaffold(
      appBar: new AppBar(
        elevation: 0.0,
        backgroundColor: Colors.deepOrange,
        title: Text('Jonas Bebidas'),
        actions: <Widget>[
          new IconButton(icon: Icon(
            Icons.search, color: Colors.white,), onPressed: (){}),
          new IconButton(icon: Icon(
            Icons.shopping_cart, color: Colors.white,), onPressed: (){
              Navigator.push(context, MaterialPageRoute(
                  builder:  (context)=> new Cart(),
              ));
          }),
        ],
      ),

      drawer: new Drawer(
        child: new ListView(
          children: <Widget>[
//            header
            new UserAccountsDrawerHeader(
                accountName: Text('Jonas'),
                accountEmail: Text('jonasbebidas@gmail.com'),
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
              onTap: (){},
              child: ListTile(
                title: Text('Início'),
                leading: Icon(Icons.home, color: Colors.deepOrange,),
              ),
            ),
            InkWell(
              onTap: (){},
              child: ListTile(
                title: Text('Minha Conta'),
                leading: Icon(Icons.account_circle, color: Colors.deepOrange,),
              ),
            ),
            InkWell(
              onTap: (){},
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
                SystemChannels.platform.invokeMethod('SystemNavigator.pop');
              },
              child: ListTile(
                title: Text('Sair'),
                leading: Icon(Icons.close, color: Colors.green,),
              ),
            ),
          ],
        ),
      ),
      body: new ListView(
        children: <Widget>[
          // images carousel
          image_carousel,
          // padding widget
          new Padding(padding: const EdgeInsets.all(8.0),
            child: new Text('Categorias', textAlign: TextAlign.center,
              style: TextStyle(fontWeight: FontWeight.bold, color: Colors.deepOrange),),
          ),

          // Horizontal list view categories
          HorizontalList(),

          // padding widget
          new Padding(padding: const EdgeInsets.all(20.0),
            child: new Text('Produtos Recentes', textAlign: TextAlign.center,
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.deepOrange),),
          ),

          //grid view
          Container(
            height: 320.0,
            child: Products(),
          ),

        ],
      ),
    );
  }
}

