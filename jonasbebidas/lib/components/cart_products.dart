import 'package:flutter/material.dart';

class Cart_products extends StatefulWidget {
  @override
  _Cart_productsState createState() => _Cart_productsState();
}

class _Cart_productsState extends State<Cart_products> {

  var Products_on_the_cart = [
    {
      "name": "Burguesa",
      "picture": "images/products/bear1.jpg",
      "price": "8,00",
      "natural/gelada": "natural",
      "quantidade": "2",
    },
    {
      "name": "Guaraná",
      "picture": "images/products/refri1.jpg",
      "price": "8,00",
      "natural/gelada": "gelada",
      "quantidade": "3",
    },
    {
      "name": "Vinho Tinto",
      "picture": "images/products/wine1.jpg",
      "price": "15,00",
      "natural/gelada": "gelada",
      "quantidade": "5",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return new ListView.builder(
          itemCount: Products_on_the_cart.length,
          itemBuilder: (context, index){
            return Single_cart_product(
              cart_prod_name: Products_on_the_cart[index]["name"],
              cart_prod_picture: Products_on_the_cart[index]["picture"],
              cart_prod_natural_gelada: Products_on_the_cart[index]["natural/gelada"],
              cart_prod_price: Products_on_the_cart[index]["price"],
              cart_prod_quat: Products_on_the_cart[index]["quantidade"],
            );
          });
  }
}

class Single_cart_product extends StatelessWidget {
  final cart_prod_name;
  final cart_prod_picture;
  final cart_prod_price;
  final cart_prod_natural_gelada;
  final cart_prod_quat;

  Single_cart_product({
    this.cart_prod_name,
    this.cart_prod_picture,
    this.cart_prod_price,
    this.cart_prod_natural_gelada,
    this.cart_prod_quat
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(

        // === leading section
        leading: new Image.asset(cart_prod_picture,
          width: 80.0,
          height: 80.0,
        ),

        // === title section
        title: new Text(cart_prod_name),

        // === subtitle section
        subtitle: new Column(
          children: <Widget>[
            // row inside of the column
            new Row(
              // section the gelada ou natural
              children: <Widget>[

                Padding(
                  padding: const EdgeInsets.all(0.0),
                  child: new Text("Natura/Gelada:"),
                ),
                Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: new Text(cart_prod_natural_gelada,
                  style: TextStyle(color: Colors.deepOrange),),
                ),
                ],
              ),

                // ===== section of for the proucts quanty




            // === section is for the product price

            new Container(

              alignment: Alignment.topLeft,
              child: new Text("R\$${cart_prod_price}",
                style: TextStyle(
                    fontSize: 17.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.deepOrange,
                ),),
            ),
            new Row(
              // section the gelada ou natural
              children: <Widget>[
                new IconButton(icon: Icon(Icons.arrow_drop_up, color: Colors.deepOrange), onPressed: null),
                new Text(cart_prod_quat),
                new IconButton(icon: Icon(Icons.arrow_drop_down,color: Colors.deepOrange), onPressed: null),
              ],
            ),
          ],
        ),

        trailing: Wrap(
            spacing: -15, // to apply margin horizontally
            runSpacing: 20, // to apply margin vertically
            children: <Widget>[
              new IconButton(icon: Icon(Icons.delete, color: Colors.deepOrange), onPressed: null),
            ]
        )
        ),
    );
  }


}

