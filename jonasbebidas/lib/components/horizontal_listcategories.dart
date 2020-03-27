import 'package:flutter/material.dart';

class HorizontalList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 110.0,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: <Widget>[
          Category(
            image_location: 'images/cats/bear.jpg',
            image_caption: 'Cervejas',
          ),
          Category(
            image_location: 'images/cats/water.jpg',
            image_caption: 'Águas',
          ),
          Category(
            image_location: 'images/cats/refri.jpg',
            image_caption: 'Refris',
          ),
          Category(
            image_location: 'images/cats/wine.png',
            image_caption: 'Vinhos',
          ),

        ],
      ),
    );
  }
}

class Category extends StatelessWidget {
  final String image_location;
  final String image_caption;

  Category({this.image_location, this.image_caption});

  @override
  Widget build(BuildContext context) {
    return Padding(padding: const EdgeInsets.all(2.0),
    child: InkWell(onTap: (){},
      child: Container(
        width: 100.0,
        child: ListTile(
          title: Image.asset(image_location,
          width: 100.0,
          height: 80.0,),
          subtitle: Container(
            alignment: Alignment.topCenter,
            child: Text(image_caption, style: new TextStyle(fontSize: 12.0),),
          ),
        ),
      ),
    ),
    );
  }
}
