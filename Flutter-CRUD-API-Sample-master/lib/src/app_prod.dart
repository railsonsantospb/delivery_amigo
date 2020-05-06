import 'package:flutter/material.dart';
import 'package:flutter_crud_api_sample_app/src/ui/formadd/form_category.dart';
import 'package:flutter_crud_api_sample_app/src/ui/formadd/form_product.dart';
import 'package:flutter_crud_api_sample_app/src/ui/home/home_category.dart';
import 'package:flutter_crud_api_sample_app/src/ui/home/home_product.dart';


GlobalKey<ScaffoldState> _scaffoldState = GlobalKey<ScaffoldState>();

class AppProd extends StatelessWidget {



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

        body: HomeProduct(),


        floatingActionButton: FloatingActionButton(
          child: Icon(
            Icons.add,
            color: Colors.white,
          ),
          onPressed: (){
//            Navigator.push(
//              _scaffoldState.currentContext,
//              MaterialPageRoute(builder: (BuildContext context) {
//                return FormAddProduct();
//              }),
//            );
            Navigator.push(context, MaterialPageRoute(

              builder:  (context)=> FormAddProduct(),
            ));

          }

        ),
      ),
    );
  }
}
