import 'package:flutter/material.dart';
import 'package:jonasbebidas/home.dart';
import 'package:jonasbebidas/main.dart';

import 'cart.dart';

class ProductDetails extends StatefulWidget {
  final produt_detail_name;
  final produt_detail_new_price;
  final produt_detail_picture;

  ProductDetails({
    this.produt_detail_name,
    this.produt_detail_new_price,
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
          Icons.shopping_cart, color: Colors.white,), onPressed: (){
          Navigator.push(context, MaterialPageRoute(
            builder: (context)=> Cart(),
          ));
        }),
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
                  onPressed: (){

                  },
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






