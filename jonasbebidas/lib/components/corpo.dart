import 'package:carousel_pro/carousel_pro.dart';
import 'package:flutter/material.dart';
import 'package:jonasbebidas/components/products.dart';

import 'horizontal_listcategories.dart';

class Corpo extends StatefulWidget {
  @override
  _CorpoState createState() => _CorpoState();
}

class _CorpoState extends State<Corpo> {



  @override
  Widget build(BuildContext context) {

    return SingleChildScrollView (

      child: Column(
        children: <Widget>[
          // images carousel
//          image_carousel,
          // padding widget
          new Padding(padding: const EdgeInsets.all(8.0),
            child: new Text('Categorias', textAlign: TextAlign.center,
              style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold, color: Colors.deepOrange),),
          ),

          // Horizontal list view categories
          HorizontalList(),

          // padding widget
          new Padding(padding: const EdgeInsets.all(20.0),
            child: new Text('Bebidas Recentes', textAlign: TextAlign.center,
              style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold, color: Colors.deepOrange),),
          ),

          //grid view
          SingleChildScrollView(

            child: Container(
              height: 310,
              child: Products(),
            ),
          ),

        ],
      ),
    );
  }
}
