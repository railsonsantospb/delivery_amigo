import 'package:flutter/material.dart';
import 'package:jonasbebidas/pages/cart.dart';
import 'package:jonasbebidas/components/products.dart';


class PageCategories extends StatefulWidget {
  final header;

  PageCategories({this.header});

  @override
  _PageCategoriesState createState() => _PageCategoriesState();
}

class _PageCategoriesState extends State<PageCategories> {

  @override
  Widget build(BuildContext context) {

    return Scaffold(
        appBar: new AppBar(
        elevation: 0.0,
        backgroundColor: Colors.deepOrange,
        title: Text(widget.header),
        actions: <Widget>[
            new IconButton(icon: Icon(
            Icons.search, color: Colors.white,), onPressed: (){}),
            new IconButton(icon: Icon(
            Icons.shopping_cart, color: Colors.white,), onPressed: (){
            Navigator.push(context, MaterialPageRoute(
            builder:  (context)=> new Cart(),
            ));
        }),
      ],),
      body: new ListView(
        children: <Widget>[
          Container(
            padding: EdgeInsets.all(20.0),
            height: 600.0,
            child: Products(),
          ),
        ],
      ),
    );
  }
}
