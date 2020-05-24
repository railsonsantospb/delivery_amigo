import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_crud_api_sample_app/src/api/api_service_user.dart';
import 'package:flutter_crud_api_sample_app/src/model/requestx.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_crud_api_sample_app/src/model/user.dart';
import 'package:flutter_crud_api_sample_app/src/ui/home/view_products.dart';

GlobalKey<ScaffoldState> _scaffoldState = GlobalKey<ScaffoldState>();

class HomeUser extends StatefulWidget {
  var list_product;
  var value;
  double n = 0.0;
  HomeUser({this.value, this.list_product});

  @override
  _HomeUserState createState() => _HomeUserState();
}

class _HomeUserState extends State<HomeUser> {
  BuildContext context;
  TextEditingController editingController = TextEditingController();
  ApiServiceUser apiService;

  var items = List<RequestX>();

  @override
  void initState() {
    super.initState();
    apiService = ApiServiceUser();
  }

  @override
  Widget build(BuildContext context) {
    this.context = context;

    return SafeArea(
      child: FutureBuilder(
        future: apiService.getUser(),
        builder:
            (BuildContext context, AsyncSnapshot<List<User>> snapshot) {

          if (snapshot.hasError) {
            print(snapshot.error.toString());
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
            List<User> user = snapshot.data;

//            print(cat);
            if (user.isEmpty == true) {
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
                        child: Text('NENHUM USUÁRIO CADASTRADO'),
                      ),
                    ],
                  ),
                ],
              );
            } else {

              return  _buildListView(user);
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

  Widget _buildListView(List<User> users) {

    return users[0].email == "0" ? Center(
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
        )) : Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
      child: ListView.builder(
        shrinkWrap: true,
        itemBuilder: (context, index) {
          User user = users[index];
          return Padding(
            padding: const EdgeInsets.only(top: 0.0),
            child: Card(
              elevation: 10.0,
              child: ListTile(
                title: new Text("Dados dos Usuários"),
                subtitle: Align(
                    child: Column(
                      children: <Widget>[

                        new Row(
                          // section the gelada ou natural
                          children: <Widget>[

                            Padding(
                              padding: const EdgeInsets.all(0.0),
                              child: new Text("Nome: "),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: new Text(user.name,
                                style: TextStyle(color: Colors.blue),
                              ),
                            ),
                          ],
                        ),
                        new Row(
                          // section the gelada ou natural
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.all(0.0),
                              child: new Text("Email: "),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: new Text(user.email,
                                style: TextStyle(color: Colors.blue),
                              ),
                            ),
                          ],
                        ),
                        new Row(
                          // section the gelada ou natural
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.all(0.0),
                              child: new Text("Senha: "),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: new Text("*******",
                                style: TextStyle(color: Colors.blue),
                              ),
                            ),
                          ],
                        ),
                        ButtonBar(

                          children: <Widget>[
                            FlatButton(
                              onPressed: () {
                                showDialog(
                                    context: context,
                                    builder: (context) {
                                      return AlertDialog(
                                        title: Text("Aviso!"),
                                        content: Text(
                                            "Você quer excluir o usuário ${user.name}?"),
                                        actions: <Widget>[
                                          FlatButton(
                                            child: Text("SIM"),
                                            onPressed: () {
                                              Navigator.pop(context);
                                              apiService
                                                  .deleteUser(user.email)
                                                  .then((isSuccess) {
                                                if (isSuccess) {
                                                  setState(() {});
                                                  Scaffold.of(this.context)
                                                      .showSnackBar(SnackBar(backgroundColor: Colors.green,
                                                      content: Text(
                                                          "Excluído com Sucesso")));
                                                } else {
                                                  Scaffold.of(this.context)
                                                      .showSnackBar(SnackBar(backgroundColor: Colors.red,
                                                      content: Text(
                                                          "Falha ao Excluir ou Verifique sua Conexão")));
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
//                                Navigator.push(context,
//                                    CupertinoPageRoute(builder: (context) {
//                                      return FormAddCategory(cat: cat);
//                                    }));
                              },
                              child: Text(
                                "EDITAR",
                                style: TextStyle(color: Colors.blue),
                              ),
                            ),

                          ],
                        ),
                      ],
                    )),
              ),
            ),
          );
        },
        itemCount: users.length,
      ),
    );

  }
}
