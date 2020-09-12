import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:amigodelivery/api/api_service_cat.dart';
import 'package:amigodelivery/components/search_teste.dart';

import 'package:flutter/widgets.dart';
import '../model/category.dart';

class HorizontalList extends StatefulWidget {
  final String cpf;
  final email;
  final id;
  HorizontalList({this.cpf, this.email, this.id, Key key}) : super(key: key);

  @override
  _HorizontalListState createState() => _HorizontalListState();
}

class _HorizontalListState extends State<HorizontalList> {
  BuildContext context;
  ApiServiceCat apiService;

  @override
  void initState() {
    super.initState();
    apiService = ApiServiceCat();
  }

  @override
  Widget build(BuildContext context) {
    this.context = context;

    return FutureBuilder(
      future: apiService.getCategoryCpf(widget.cpf),
      builder: (BuildContext context, AsyncSnapshot<List<CategoryR>> snapshot) {
        List<CategoryR> cat = snapshot.data;

        if (snapshot.hasError) {
          return Center(
            child: Stack(
              children: <Widget>[
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Center(
                      child: Icon(
                        Icons.broken_image,
                        color: Colors.red,
                        size: 100.0,
                      ),
                    ),
                    Center(
                      child: Text('SEM CONEXÃO COM A INTERNET'),
                    ),
                    Center(
                      child: Text('FECHE O APLICATIVO'),
                    ),
                    Center(
                      child: Text('TENTE NOVAMENTE'),
                    ),
                    Center(
                      child: Text('SE PERSISTIR CONTATE O SUPORTE'),
                    ),
                  ],
                ),
              ],
            ),
          );
        } else if (snapshot.connectionState == ConnectionState.done) {
          if (cat == null) {
            return Center(
              child: Stack(
                children: <Widget>[
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Center(
                        child: Icon(
                          Icons.broken_image,
                          color: Colors.red,
                          size: 100.0,
                        ),
                      ),
                      Center(
                        child: Text('SEM CONEXÃO COM A INTERNET'),
                      ),
                      Center(
                        child: Text('FECHE O APLICATIVO'),
                      ),
                      Center(
                        child: Text('TENTE NOVAMENTE'),
                      ),
                      Center(
                        child: Text('SE PERSISTIR CONTATE O SUPORTE'),
                      ),
                    ],
                  ),
                ],
              ),
            );
          } else {
            if (cat.isEmpty) {
              return Stack(
                children: <Widget>[
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Center(
                        child: Icon(
                          Icons.not_interested,
                          color: Colors.red,
                          size: 100.0,
                        ),
                      ),
                      Center(
                        child: Text('NENHUM CATÁLOGO CADASTRADO'),
                      ),
                    ],
                  ),
                ],
              );
            } else {
              return Container(
                height: 150.0,
                child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: cat.length,
                    itemBuilder: (BuildContext contex, index) {
                      return Padding(
                        padding: const EdgeInsets.all(2.0),
                        child: InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => SearchList(
                                    header: cat[index].name.toUpperCase(),
                                    id: cat[index].id,
                                    cpf: widget.cpf,
                                    id_cop: widget.id,
                                    email: widget.email,
                                  ),
                                ));
                          },
                          child: Container(
                            width: 140.0,
                            child: ListTile(
                              title: ClipRRect(
                                borderRadius: BorderRadius.circular(150),
                                child: Image.memory(
                                  base64Decode(cat[index].image),
                                  cacheHeight: 100,
                                  cacheWidth: 100,
                                ),
                              ),
                              subtitle: Container(
                                alignment: Alignment.topCenter,
                                child: Text(
                                  cat[index].name.toUpperCase(),
                                  style: new TextStyle(
                                      fontSize: 12.0,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    }),
              );
            }
          }
        } else {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}
