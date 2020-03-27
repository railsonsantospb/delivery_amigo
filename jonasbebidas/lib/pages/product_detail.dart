import 'package:flutter/material.dart';
import 'package:jonasbebidas/home.dart';
import 'package:jonasbebidas/main.dart';

class ProductDetails extends StatefulWidget {
  final produt_detail_name;
  final produt_detail_new_price;
  final produt_detail_old_price;
  final produt_detail_picture;

  ProductDetails({
    this.produt_detail_name,
    this.produt_detail_new_price,
    this.produt_detail_old_price,
    this.produt_detail_picture
  });

  @override
  _ProductDetailsState createState() => _ProductDetailsState();
}

class _ProductDetailsState extends State<ProductDetails> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
      elevation: 0.0,
      backgroundColor: Colors.deepOrange,
      title: InkWell(
          onTap: (){Navigator.push(context, MaterialPageRoute(
            builder: (context)=> HomePage()
          ));},
          child: Text('Jonas Bebidas')),
      actions: <Widget>[
        new IconButton(icon: Icon(
          Icons.search, color: Colors.white,), onPressed: (){}),
        new IconButton(icon: Icon(
          Icons.shopping_cart, color: Colors.white,), onPressed: (){}),
      ],
    ),
      body: new ListView(
        children: <Widget>[
          new Container(
            height: 270.0,
            child: GridTile(
              child: Container(
                color: Colors.white,
                child: Image.asset(
                  widget.produt_detail_picture
                ),
              ),
              footer: new Container(
                color: Colors.white70,
                child: ListTile(


                  title: new Row(
                    children: <Widget>[

                      Expanded(
                        child:
                        new Text("${widget.produt_detail_name}",
                        style: TextStyle(fontWeight: FontWeight.bold,
                        color: Colors.black),),
                      ),
                    ],
                  ),
                  subtitle: new Row(
                    children: <Widget>[

                      Expanded(
                        child:
                        new Text("R\$${widget.produt_detail_new_price}",
                          style: TextStyle(fontWeight: FontWeight.bold,
                              color: Colors.deepOrange),),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // ===== the first buttons

          Row(
            children: <Widget>[


              // ===== the quantidade button


              // ===== the estado button
              Expanded(
                child: MaterialButton(
                  onPressed: (){
                    showDialog(context: context,
                        builder: (context){
                          return new AlertDialog(

                            actions: <Widget>[
                              new MaterialButton(onPressed: (){
                                Navigator.of(context).pop(context);
                              },
                              child: new SimpleDialog(

                                children: <Widget>[
                                  new SimpleDialogOption(child: new Text('Natural',
                                    style: TextStyle(fontSize: 16.0),),
                                    onPressed: (){Navigator.pop(context, "Answers.YES");},),
                                    Divider(),
                                  new SimpleDialogOption(child: new Text('Gelada',
                                      style: TextStyle(fontSize: 16.0)),
                                    onPressed: (){Navigator.pop(context, "Answers.NO");},),
                                ],
                              )
                              ),
                            ],
                          );
                        });
                  },
                  color: Colors.white,
                  textColor: Colors.deepOrange,
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: new Text("Clique e Escolha Natural/Gelada", textAlign: TextAlign.center,),
                      ),

                    ],
                  ),),
              ),
            ],
          ),


          Row(
            children: <Widget>[

              // ===== the send button
              Expanded(
                child: MaterialButton(
                  onPressed: (){},
                  color: Colors.deepOrange,
                  textColor: Colors.white,
                  child: new Text("Comprar Agora"),
                  ),
              ),

              new IconButton(icon: Icon(Icons.add_shopping_cart,
              color: Colors.deepOrange,),
                  onPressed: (){}),

            ],
          ),

          Divider(color: Colors.grey,),

          new ListTile(
            title: new Text("Detalhes da Bebida"),
          ),

          // add product condition
          new Row(
            children: <Widget>[
              Padding(padding: const EdgeInsets.fromLTRB(12.0, 5.0, 5.0, 5.0),
                child: new Text("Condição da Bebida:", style: TextStyle(color: Colors.grey),),),
              Padding(padding: EdgeInsets.all(5.0),
                child: Text("Natural/Gelada"),),
            ],
          ),

          new Row(
            children: <Widget>[
              Padding(padding: const EdgeInsets.fromLTRB(12.0, 5.0, 5.0, 5.0),
                child: new Text("Marca da Bebida:", style: TextStyle(color: Colors.grey),),),

              // remember create product brand
              Padding(padding: EdgeInsets.all(5.0),
                child: Text("Crystall"),),
            ],
          ),

        ],
      ),
    );
  }
}

class Similar_products extends StatefulWidget {

  @override
  _Similar_productsState createState() => _Similar_productsState();
}

class _Similar_productsState extends State<Similar_products> {
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
    }
  ];

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
        itemCount: product_list.length,
        gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2),
        itemBuilder: (BuildContext context, int index){
          return  Similiar_single_prod(
            prod_name: product_list[index]['name'],
            prod_picture: product_list[index]['picture'],
            prod_old_price: product_list[index]['old_price'],
            prod_price: product_list[index]['price'],
          );
        });
  }
}

class Similiar_single_prod extends StatelessWidget {
  final prod_name;
  final prod_picture;
  final prod_old_price;
  final prod_price;

  Similiar_single_prod({
    this.prod_name,
    this.prod_picture,
    this.prod_old_price,
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
                      produt_detail_old_price: prod_old_price,
                      produt_detail_picture: prod_picture,
                    ))),
            child: GridTile(
              footer: Container(
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
