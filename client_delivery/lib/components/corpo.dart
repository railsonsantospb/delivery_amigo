import 'package:flutter/material.dart';
import 'package:amigodelivery/components/products.dart';

import 'horizontal_listcategories.dart';

class Corpo extends StatefulWidget {
  final String cpf;
  final email;
  final id;

  Corpo({this.cpf, this.email, this.id});

  @override
  _CorpoState createState() => _CorpoState();
}

class _CorpoState extends State<Corpo> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          // images carousel
//          image_carousel,
          // padding widget
          new Padding(
            padding: const EdgeInsets.all(8.0),
            child: new Text(
              'Catálogos',
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.deepOrange),
            ),
          ),

          // Horizontal list view categories
          HorizontalList(
            cpf: widget.cpf,
          ),

          // padding widget
          new Padding(
            padding: const EdgeInsets.all(30.0),
            child: new Text(
              'Produtos Recentes',
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.deepOrange),
            ),
          ),

          //grid view
          SingleChildScrollView(
            child: Container(
              height: 310,
              child: Products(
                cpf: widget.cpf,
                email: widget.email,
                id: widget.id,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
