import 'package:flutter/material.dart';
import 'package:flutter_crud_api_sample_app/src/ui/formadd/form_category.dart';
import 'package:flutter_crud_api_sample_app/src/ui/home/home_screen.dart';

import 'api/api_service.dart';

GlobalKey<ScaffoldState> _scaffoldState = GlobalKey<ScaffoldState>();

class App extends StatefulWidget {
  @override
  _AppState createState() => _AppState();
}


class _AppState extends State<App> {


  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      theme: ThemeData(
        primaryColor: Colors.deepOrange,
        accentColor: Colors.deepOrange,
      ),
      home: Scaffold(
        key: _scaffoldState,
        appBar: AppBar(
          title: Text(
            "Flutter CRUD API",
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        ),
        body: HomeScreen(),

        floatingActionButton: FloatingActionButton(
          child: Icon(
            Icons.add,
            color: Colors.white,
          ),
          onPressed: (){
            Navigator.push(
              _scaffoldState.currentContext,
              MaterialPageRoute(builder: (BuildContext context) {
                return FormAddScreen();
              }),
            );
          }

        ),
      ),
    );
  }
}
