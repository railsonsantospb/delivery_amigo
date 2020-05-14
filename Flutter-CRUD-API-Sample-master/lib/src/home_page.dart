import 'package:badges/badges.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_crud_api_sample_app/src/app_cat.dart';
import 'package:flutter_crud_api_sample_app/src/ui/home/home_category.dart';
import 'package:flutter_crud_api_sample_app/src/ui/home/home_requestx.dart';


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
    AppCat(),
    Text("Person"),
    HomeRequestX(),
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
        iconTheme: IconThemeData(color: Colors.white),
        title: Text('Catálogo de Bebidas'),


//        actions: <Widget>[
//          IconButton(icon: Icon(
//
//              Icons.exit_to_app, size: 30.0, color: Colors.white), onPressed: (){
//            Navigator.pushAndRemoveUntil(
//              context,
//              CupertinoPageRoute(builder: (context) => LoginScreen3()),
//                  (Route<dynamic> route) => false,
//            );
//          }),
//        ],
      ),


//      drawer: new Drawer(
//        child: new ListView(
//          children: <Widget>[
////            header
//            new UserAccountsDrawerHeader(
//              accountName: Text(widget.name),
//              accountEmail: Text(widget.email),
//              currentAccountPicture: GestureDetector(
//                child: new CircleAvatar(
//                  backgroundColor: Colors.blue,
//                  child: Icon(Icons.person, color: Colors.white,),
//                ),
//              ),
//              decoration: new BoxDecoration(
//                  color: Colors.deepOrange
//              ),
//            ),
////            body
//
//
//            InkWell(
//              onTap: (){
//                Navigator.push(context, MaterialPageRoute(
//                  builder: (context)=> Pedidos(),
//                ));
//              },
//              child: ListTile(
//                title: Text('Meus Pedidos'),
//                leading: Icon(Icons.shopping_basket, color: Colors.deepOrange,),
//              ),
//            ),
//            InkWell(
//              onTap: (){
//                Navigator.push(context, MaterialPageRoute(
//                  builder: (context)=> Cart(),
//                ));
//              },
//              child: ListTile(
//                title: Text('Meu Carrinho'),
//                leading: Icon(Icons.shopping_cart, color: Colors.deepOrange,),
//              ),
//            ),
//
//            Divider(),
//
//
//            InkWell(
//              onTap: (){
//                Navigator.pushAndRemoveUntil(
//                  context,
//                  CupertinoPageRoute(builder: (context) => LoginScreen3()),
//                      (Route<dynamic> route) => false,
//                );
//              },
//              child: ListTile(
//                title: Text('Sair'),
//                leading: Icon(Icons.close, color: Colors.green,),
//              ),
//            ),
//          ],
//        ),
//      ),


      body: Center(
        child: widgetOptions.elementAt(selectedIndex),
      ),

      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.deepOrange,
        items: <BottomNavigationBarItem>[


          BottomNavigationBarItem(
              icon:  Icon(Icons.local_drink, size: 30.0,),
              title: Text('Bebidas')
          ),
          BottomNavigationBarItem(

              icon: Icon(Icons.menu, size: 30.0,),
              title: Text('Categoria')
          ),
          BottomNavigationBarItem(
              icon:  Icon(Icons.cancel, size: 30.0,),
              title: Text('Pedidos ')
          ),
          BottomNavigationBarItem(
              icon:  Icon(Icons.check_circle, size: 30.0,),
              title: Text('Pedidos')
          ),

        ],
        currentIndex: selectedIndex,
        fixedColor: Colors.white,
        onTap: onItemTapped,
      ),);

  }
}

