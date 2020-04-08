import 'package:flutter/material.dart';
import 'package:jonasbebidas/pages/product_detail.dart';

class Products extends StatefulWidget {
  @override
  _ProductsState createState() => _ProductsState();
}

class _ProductsState extends State<Products> {
  var product_list = [
    {
      "name": "Burguesa",
      "picture": "images/products/bear1.jpg",
      "old_price": "12,00",
      "price": "8,00"
    },
    {
      "name": "Guaraná",
      "picture": "images/products/refri1.jpg",
      "old_price": "8,00",
      "price": "6,00"
    },
    {
      "name": "Crystal",
      "picture": "images/products/water1.jpg",
      "old_price": "2,00",
      "price": "1,50"
    },
    {
      "name": "Vinho Tinto",
      "picture": "images/products/wine1.jpg",
      "old_price": "17,00",
      "price": "15,00"
    },
    {
      "name": "Heineken",
      "picture": "images/products/bear2.jpg",
      "old_price": "8,00",
      "price": "5,00"
    },{
      "name": "CocaCola",
      "picture": "images/products/refri2.jpg",
      "old_price": "8,00",
      "price": "6,00"
    },
    {
      "name": "Crystal",
      "picture": "images/products/water2.jpg",
      "old_price": "3,00",
      "price": "2,00"
    },
    {
      "name": "Cristalle",
      "picture": "images/products/wine2.png",
      "old_price": "18,00",
      "price": "16,00"
    }
  ];

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
        shrinkWrap: true,
        itemCount: product_list.length,
        gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2),
          itemBuilder: (BuildContext context, int index){
            return  Single_prod(
              prod_name: product_list[index]['name'],
              prod_picture: product_list[index]['picture'],
              prod_price: product_list[index]['price'],
            );
          });
  }
}

class Single_prod extends StatelessWidget {
  final prod_name;
  final prod_picture;
  final prod_price;

  Single_prod({
    this.prod_name,
    this.prod_picture,
    this.prod_price
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Hero(

          tag: new Text("hero 1"),
          child: Material(
            child: InkWell(
              onTap: ()=>
                  Navigator
                      .of(context)
                      .push(new MaterialPageRoute(
                    // here we are passing the values of the products
                    // to the product details
                      builder: (context)=> new ProductDetails(
                        produt_detail_name: prod_name,
                        produt_detail_new_price: prod_price,
                        produt_detail_picture: prod_picture,
                      ))),
            child: GridTile(
              footer: Container(
                padding: const EdgeInsets.all(9.0),
                color: Colors.white70,
                child: new Row(

                  children: <Widget>[
                    Expanded(
                      child: Text(prod_name,
                      style: TextStyle(fontWeight: FontWeight.bold,
                      fontSize: 16.0),),
                    ),
                    new Text("R\$${prod_price}",
                      style: TextStyle(color: Colors.deepOrange,
                      fontWeight: FontWeight.bold),),
                  ],
                ),
              ),
              child: Image.asset(prod_picture,
              fit: BoxFit.cover,),
            ),
            ),
          ),
      ),
    );
  }
}
