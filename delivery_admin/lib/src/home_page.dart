import 'dart:async';
import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:deliveryadmin/src/model/company.dart';
import 'package:deliveryadmin/src/ui/home/home_category.dart';
import 'package:deliveryadmin/src/ui/home/home_company.dart';
import 'package:deliveryadmin/src/ui/home/home_requestx.dart';
import 'package:deliveryadmin/src/ui/home/home_requesty.dart';
import 'package:deliveryadmin/src/ui/home/login_home.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'api/api_service_rx.dart';
import 'package:deliveryadmin/src/ui/home/local_notications_helper.dart';
import 'package:ringtone/ringtone.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:vibration/vibration.dart';

class HomePage1 extends StatefulWidget {
  final Company data;

  HomePage1({this.data});

  @override
  _HomePage1State createState() => _HomePage1State();
}

class _HomePage1State extends State<HomePage1> {
  final notifications = FlutterLocalNotificationsPlugin();
  String cpf;
  Timer timer;
  String valor;
  String aux;
  String acess;
  int seconds, minutes, hours;
  static const duration = const Duration(seconds: 2);
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
      HomeRequestX(
        name: widget.data.name,
        id_cop: widget.data.id,
      ),
      HomeRequestY(
        id_cop: widget.data.id,
      ),
      FormAddCompany(
        cpf: widget.data.cpf_cnpj,
      ),
    ];

    return widgetOptions;
  }

  saveToAcess(String acess) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    prefs.setString('acess', acess);
  }

  getValues() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //Return String

    if (prefs.getString('acess') != null && this.mounted) {
      setState(() {
        acess = prefs.getString('acess');
      });
    }
  }

  Future onSelectNotification(String payload) async =>
      await Navigator.pushAndRemoveUntil(
        context,
        CupertinoPageRoute(
            builder: (context) => HomePage1(
                  data: widget.data,
                )),
        (Route<dynamic> route) => false,
      );

  @override
  void initState() {
    notifications.cancelAll();
    getValues();
    final settingsAndroid = AndroidInitializationSettings('app_icon');
    final settingsIOS = IOSInitializationSettings(
        onDidReceiveLocalNotification: (id, title, body, payload) =>
            onSelectNotification(payload));

    notifications.initialize(
        InitializationSettings(settingsAndroid, settingsIOS),
        onSelectNotification: onSelectNotification);

    options = opt();
    if (this.mounted) {
      apiService = ApiServiceRX();
      timer = Timer.periodic(duration, (Timer t) {
        getValues();
        apiTime();
      });
    }
    super.initState();
  }

  apiTime() {
    getValues();
    apiService.countRequestX(widget.data.id).then((value) {
      if (this.mounted) {
        if (value != "0" && value != null && acess != value) {
          showOngoingNotification(notifications,
              title: 'Amigo Delivery',
              body: 'Você precisa realizar uma entrega!');
          Ringtone.play();
          Vibration.vibrate();
          Future.delayed(Duration(milliseconds: 10000));
          Vibration.vibrate();
          saveToAcess("1");
        }
        setState(() {
          valor = value;
          if (acess != valor) {
            saveToAcess(value);
          }
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    void onItemTapped(int index) {
      setState(() {
        if (index == 1) {
          Vibration.cancel();
          Ringtone.stop();
          notifications.cancelAll();
        }
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
        title: Text('Administrador'),
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
              title: Text('Catálogos')),
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
              title: Text('Pedidos')),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.check_circle,
                size: 40.0,
              ),
              title: Text('Entregas')),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.person,
                size: 40.0,
              ),
              title: Text('Administrador')),
        ],
        currentIndex: selectedIndex,
        fixedColor: Colors.white,
        onTap: onItemTapped,
      ),
    );
  }
}
