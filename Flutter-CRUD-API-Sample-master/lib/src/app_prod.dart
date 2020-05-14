import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_crud_api_sample_app/src/home_page.dart';
import 'package:flutter_crud_api_sample_app/src/ui/formadd/form_category.dart';
import 'package:flutter_crud_api_sample_app/src/ui/formadd/form_product.dart';
import 'package:flutter_crud_api_sample_app/src/ui/home/home_category.dart';
import 'package:flutter_crud_api_sample_app/src/ui/home/home_product.dart';


GlobalKey<ScaffoldState> _scaffoldState = GlobalKey<ScaffoldState>();


class AppProd extends StatefulWidget {
  int id;
  String name;

  AppProd({this.id, this.name});

  @override
  _AppProdState createState() => _AppProdState();
}

class _AppProdState extends State<AppProd> {



  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Colors.deepOrange,
        accentColor: Colors.deepOrange,
      ),
      home: Scaffold(
        key: _scaffoldState,

        body: HomeProduct(id: widget.id,name: widget.name,),


        floatingActionButton: FloatingActionButton(
            child: Icon(
              Icons.add,
              color: Colors.white,
            ),
            onPressed: (){
              Navigator.push(_scaffoldState.currentContext,
                  CupertinoPageRoute(builder: (context) {
                    return FormAddProduct();
                  }));
            }

        ),
      ),
    );
  }
}
