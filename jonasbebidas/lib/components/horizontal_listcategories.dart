import 'package:flutter/material.dart';
import 'package:jonasbebidas/components/page_categories.dart';
import 'package:jonasbebidas/components/search_teste.dart';

class HorizontalList extends StatelessWidget {

  var list_c = [
    {
      "image_location": 'images/cats/bear.jpg',
      "image_caption": 'Cervejas',
    },
    {
      "image_location": 'images/cats/water.jpg',
      "image_caption": 'Águas',
    },
    {
      "image_location": 'images/cats/refri.jpg',
      "image_caption": 'Refrigerantes',
    },
    {
      "image_location": 'images/cats/wine.png',
      "image_caption": 'Vinhos',
    },
  ];
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 110.0,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: list_c.length,
        itemBuilder: (BuildContext contex, index){
          return Category(
            image_location: list_c[index]["image_location"],
            image_caption: list_c[index]["image_caption"],
          );
        }
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
      child: InkWell(onTap: (){
        Navigator.push(context, MaterialPageRoute(
          builder: (context)=> SearchList(header: image_caption,),
        ));
      },
        child: Container(
          width: 110.0,
          child: ListTile(

            title: Image.asset(image_location,
              width: 100.0,
              height: 80.0,),
            subtitle: Container(

              alignment: Alignment.topCenter,
              child: Text(image_caption, style: new TextStyle(fontSize: 15.0,
                  fontWeight: FontWeight.bold),),
            ),
          ),
        ),
      ),
    );
  }
}