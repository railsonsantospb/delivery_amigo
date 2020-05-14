import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_crud_api_sample_app/src/ui/formadd/form_category.dart';
import 'package:flutter_crud_api_sample_app/src/ui/home/home_category.dart';


GlobalKey<ScaffoldState> _scaffoldState = GlobalKey<ScaffoldState>();

class AppCat extends StatelessWidget {



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

        body: HomeCategory(),


        floatingActionButton: FloatingActionButton(
            child: Icon(
              Icons.add,
              color: Colors.white,
            ),
            onPressed: (){
              Navigator.push(_scaffoldState.currentContext,
                  CupertinoPageRoute(builder: (BuildContext context) {
                    return FormAddCategory();
                  }));
            }

        ),
      ),
    );
  }
}
