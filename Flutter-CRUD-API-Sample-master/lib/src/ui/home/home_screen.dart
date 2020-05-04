import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_crud_api_sample_app/src/api/api_service_cat.dart';
import 'package:flutter_crud_api_sample_app/src/model/category.dart';
import 'package:flutter_crud_api_sample_app/src/ui/formadd/form_category.dart';
import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/widgets.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mobx/mobx.dart';


class HomeScreen extends StatefulWidget {


  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  BuildContext context;
  ApiService apiService;




  @override
  void initState() {
    super.initState();
    apiService = ApiService();
  }

  @override
  Widget build(BuildContext context) {
    this.context = context;


    return SafeArea(



      child: FutureBuilder(

        future: apiService.getCategory(),
        builder: (BuildContext context, AsyncSnapshot<List<Category>> snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text(
                  "Something wrong with message: ${snapshot.error.toString()}"),
            );
          } else if (snapshot.connectionState == ConnectionState.done) {

//            setState(() {});
            List<Category> cat = snapshot.data;
//            print(cat);
            if(cat.isEmpty == true){
              return Center(
                child: Icon(Icons.not_interested, color: Colors.red, size: 100.0,),
              );
            } else {
              return _buildListView(cat);
            }
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),

    );
  }

  Widget _buildListView(List<Category> cats) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: ListView.builder(
        itemBuilder: (context, index) {
          Category cat = cats[index];

          return Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.all(2.0),
                      child: Center(

                        child: Text(

                          cat.name.toUpperCase(),
                          style: Theme.of(context).textTheme.title,
                        ),
                      ),  
                    ),
                    

                    Center(
                      child: Image.memory(base64Decode(cat.image), cacheHeight: 500, cacheWidth: 500,),
                    ),


//                    Text(cat.image),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        FlatButton(
                          onPressed: () {
                            showDialog(
                                context: context,
                                builder: (context) {

                                  return AlertDialog(
                                    title: Text("Aviso!"),
                                    content: Text(
                                        "Você quer excluir a categoria ${cat.name}?"),
                                    actions: <Widget>[
                                      FlatButton(
                                        child: Text("SIM"),
                                        onPressed: () {
                                          Navigator.pop(context);
                                          apiService
                                              .deleteCategory(cat.id)
                                              .then((isSuccess) {
                                            if (isSuccess) {
                                              setState(() {});
                                              Scaffold.of(this.context)
                                                  .showSnackBar(SnackBar(
                                                      content: Text(
                                                          "Excluído com Sucesso")));
                                            } else {
                                              Scaffold.of(this.context)
                                                  .showSnackBar(SnackBar(
                                                      content: Text(
                                                          "Falha ao Excluir")));
                                            }
                                          });
                                        },
                                      ),
                                      FlatButton(
                                        child: Text("NÃO"),
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                      )
                                    ],
                                  );
                                });
                          },
                          child: Text(
                            "EXCLUIR",
                            style: TextStyle(color: Colors.red),
                          ),
                        ),
                        FlatButton(
                          onPressed: () {
                            Navigator.push(context,
                                CupertinoPageRoute(builder: (context) {
                              return FormAddScreen(cat: cat);
                            }));
                          },
                          child: Text(
                            "EDITAR",
                            style: TextStyle(color: Colors.blue),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        },

        itemCount: cats.length,

      ),

    );
  }
}
