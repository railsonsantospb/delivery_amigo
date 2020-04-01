import 'package:flutter/material.dart';
import 'package:jonasbebidas/components/cart_products.dart';
import 'package:jonasbebidas/components/form_compra.dart';

class Cart extends StatefulWidget {
  @override
  _CartState createState() => _CartState();
}



class _CartState extends State<Cart> {

  var listas = [
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

  _onSelected(dynamic val) {

    setState(() => listas.clear());

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        elevation: 0.0,
        backgroundColor: Colors.deepOrange,
        title: Text('Carrinho'),
        actions: <Widget>[
      new PopupMenuButton(
        padding: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
        onSelected: _onSelected,
        icon: Icon(Icons.delete, color: Colors.white,),
        itemBuilder: (context) => [
          PopupMenuItem(
            value: listas,
            child: Text("Apagar Carrinho"),
          ),
        ],
      ),
        ],
      ),

      body: new Cart_products(),

      bottomNavigationBar: new Container(
        color: Colors.white,
        child: Row(
          children: <Widget>[

            Expanded(

              child: ListTile(

                title: new Text("Total: "),
                subtitle: new Text("R\$230"),
              ),
            ),

            Expanded(
              child: new MaterialButton(onPressed: (){
                Navigator.push(context, MaterialPageRoute(
                  builder:  (context)=> new MyAppForm(),
                ));

              },
              child: new Text("Confirmar Compra",
                style: TextStyle(color: Colors.white),),
                color: Colors.deepOrange,
              ),
            ),

          ],
        ),
      ),
    );
  }
}
