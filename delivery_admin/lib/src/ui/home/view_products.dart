import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:deliveryadmin/src/model/requestx.dart';
import 'package:flutter/widgets.dart';

GlobalKey<ScaffoldState> _scaffoldState4 = GlobalKey<ScaffoldState>();

class HomeRequestProdX extends StatefulWidget {
  var list_product;
  var value;
  double n = 0.0;
  HomeRequestProdX({this.value, this.list_product});

  @override
  _HomeRequestProXState createState() => _HomeRequestProXState();
}

class _HomeRequestProXState extends State<HomeRequestProdX> {
  BuildContext context;
  TextEditingController editingController = TextEditingController();

  var items = List<RequestX>();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    this.context = context;

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Colors.deepOrange,
        accentColor: Colors.deepOrange,
      ),
      home: Scaffold(
        appBar: new AppBar(
          centerTitle: true,
          elevation: 10.0,
          backgroundColor: Colors.green,
          iconTheme: IconThemeData(color: Colors.white),
          title: Text('Preço Total R\$: ' + widget.value,
              style: TextStyle(height: 0.0)),
        ),
        key: _scaffoldState4,
        body: _buildListView(widget.list_product),
      ),
    );
  }

  Widget _buildListView(String rxs) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: rxs.split('#').length - 1,
        itemBuilder: (context, index) {
          String rx = rxs.split('#')[index];

          return Padding(
            padding: const EdgeInsets.only(top: 0.0),
            child: Card(
              elevation: 10.0,
              child: new SingleChildScrollView(
                child: Container(
                  child: ListTile(
                    title: new Text("Dados do Produto"),
                    subtitle: Align(
                        child: Column(
                      children: <Widget>[
                        new Row(
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.all(0.0),
                              child: new Text("Nome: "),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: new Text(
                                rx.split('=')[0],
                                style: TextStyle(color: Colors.blue),
                              ),
                            ),
                          ],
                        ),
                        new Row(
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.all(0.0),
                              child: new Text("Quantidade: "),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: new Text(
                                rx.split('=')[1],
                                style: TextStyle(color: Colors.blue),
                              ),
                            ),
                          ],
                        ),
                        new Row(
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.all(0.0),
                              child: new Text("Marca: "),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: new Text(
                                rx.split('=')[2],
                                style: TextStyle(color: Colors.blue),
                              ),
                            ),
                          ],
                        ),
                        new Row(
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.all(0.0),
                              child: new Text("Preço: "),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: new Text(
                                rx.split('=')[3],
                                style: TextStyle(color: Colors.blue),
                              ),
                            ),
                          ],
                        ),
                        new Row(
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.all(0.0),
                              child: new Text("Informações: "),
                            ),
                          ],
                        ),
                        Wrap(
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: new Text(
                                rx.split('=')[4],
                                style: TextStyle(color: Colors.blue),
                              ),
                            ),
                          ],
                        ),
                      ],
                    )),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
