import 'dart:async';
import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_crud_api_sample_app/src/model/company.dart';
import 'package:flutter_crud_api_sample_app/src/ui/home/home_category.dart';
import 'package:flutter_crud_api_sample_app/src/ui/home/home_company.dart';
import 'package:flutter_crud_api_sample_app/src/ui/home/home_requestx.dart';
import 'package:flutter_crud_api_sample_app/src/ui/home/home_requesty.dart';
import 'package:flutter_crud_api_sample_app/src/ui/home/home_user.dart';
import 'package:flutter_crud_api_sample_app/src/ui/home/login_home.dart';
import 'api/api_service_rx.dart';

class HomePage1 extends StatefulWidget {
  Company data;

  HomePage1({this.data});

  @override
  _HomePage1State createState() => _HomePage1State();
}

class _HomePage1State extends State<HomePage1> {
  String cpf;
  Timer timer;
  String valor;
  int seconds, minutes, hours;
  static const duration = const Duration(seconds: 1);
  ApiServiceRX apiService;

  int secondsPassed = 0;
  bool isActive = false;

  int selectedIndex = 0;
  List<StatefulWidget> options;

  Color getColor() {
    if (1 == 0) {
      return Colors.red;
    } else {
      return Colors.blueGrey;
    }
  }

  List<StatefulWidget> opt() {

    final widgetOptions = [
      HomeCategory(
        data: widget.data,
      ),
      HomeRequestX(),
      HomeRequestY(),
      HomeUser(),
      FormAddCompany(cop: widget.data,),
    ];

    return widgetOptions;
  }

  @override
  void initState() {
    options = opt();
    if (this.mounted) {
      apiService = ApiServiceRX();
      timer = Timer.periodic(duration, (Timer t) {
        apiTime();
      });
    }
    super.initState();
  }

  apiTime() {
    apiService.countRequestX().then((value) {
      if (this.mounted) {
        setState(() {
          valor = value;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    void onItemTapped(int index) {
      setState(() {
        selectedIndex = index;
      });
    }

    return Scaffold(
      resizeToAvoidBottomPadding: false,
      resizeToAvoidBottomInset: true,
      appBar: new AppBar(
        centerTitle: true,
        elevation: 10.0,
        backgroundColor: Colors.deepOrange,
        iconTheme: IconThemeData(color: Colors.white),
        title: Text('Administrador de Bebidas'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.exit_to_app),
            onPressed: () {
              Navigator.pushAndRemoveUntil(
                context,
                CupertinoPageRoute(builder: (context) => LoginScreen3()),
                (Route<dynamic> route) => false,
              );
            },
          ),
        ],
      ),
      body: Center(
        child: options.elementAt(selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.deepOrange,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
              icon: Icon(
                Icons.business_center,
                size: 40.0,
              ),
              title: Text('Empresa')),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.shopping_basket,
                size: 40.0,
              ),
              title: Text('Produtos')),
          BottomNavigationBarItem(
              icon: valor != "0" && valor != null
                  ? Badge(
                      badgeColor: Colors.green,
                      position: BadgePosition.topRight(top: -10, right: -10),
                      badgeContent: Text(
                        valor,
                        style: TextStyle(color: Colors.white),
                      ),
                      child: Icon(
                        Icons.shopping_cart,
                        size: 40.0,
                      ),
                    )
                  : Icon(
                      Icons.shopping_cart,
                      size: 40.0,
                    ),
              title: Text('Pedidos ')),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.check_circle,
                size: 40.0,
              ),
              title: Text('Pedidos')),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.person,
                size: 40.0,
              ),
              title: Text('Usuários')),
        ],
        currentIndex: selectedIndex,
        fixedColor: Colors.white,
        onTap: onItemTapped,
      ),
    );
  }
}
