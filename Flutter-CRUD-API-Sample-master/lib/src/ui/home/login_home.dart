import 'dart:async';
import 'package:flutter/services.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_crud_api_sample_app/src/api/api_service_company.dart';
import 'package:flutter_crud_api_sample_app/src/home_page.dart';
import 'package:flutter_crud_api_sample_app/src/model/company.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:geolocator/geolocator.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:cpfcnpj/cpfcnpj.dart';
import 'dart:io';
import 'dart:convert';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';


class LoginScreen3 extends StatefulWidget {
  @override
  _LoginScreen3State createState() => new _LoginScreen3State();
}

class _LoginScreen3State extends State<LoginScreen3>
    with TickerProviderStateMixin {
  String _contactText;
  Future<File> file1;
  Future<File> file2;
  String base64Image;
  File tmpFile;
  File tmp;

  String _message = 'Log in/out by pressing the buttons below.';

  ProgressDialog pr;

  Future<Null> _login() async {}

  Future<Null> _logOut() async {}

  ApiServiceCop _apiServiceCop = ApiServiceCop();

  bool _isFieldNameValid;
  bool _isFieldStateValid;
  bool _isFieldImageValid;
  bool _isFieldCatIdValid;
  bool _isFieldPhoneValid;
  bool _isFieldOwnerValid;
  bool _isFieldAddressValid;
  bool _isFieldCpf_CnpjValid;
  bool _isFieldCityValid;
  bool _isFieldPasswordValid;
  bool _isFieldPasswordLoginValid;
  bool _isFieldCpfLoginValid;
  bool valid = false;

  final Geolocator geolocator = Geolocator()..forceAndroidLocationManager;
  Position _currentPosition;
  double lat, long;

  TextEditingController _controllerName = TextEditingController();
  TextEditingController _controllerOwner = TextEditingController();
  TextEditingController _controllerAddress = TextEditingController();
  TextEditingController _controllerCpf_Cnpj =
      new MaskedTextController(mask: '000.000.000-00');
  TextEditingController _controllerPhone =
      new MaskedTextController(mask: '(00) 00000-0000');
  TextEditingController _controllerCity = TextEditingController();
  TextEditingController _controllerPassword = TextEditingController();
  TextEditingController _controllerPassword2 = TextEditingController();

  MaskedTextController _controllerCpfLogin =
      new MaskedTextController(mask: '000.000.000-00');
  TextEditingController _controllerPasswordLogin = TextEditingController();

  bool _isLoading = false;
  String _mySelection2;
  String value;
  String status = '';
  String errMessage = 'Error Uploading Image';
  String password1;
  String password2;

  bool check = false;

  chooseImage1() {
    if (this.mounted) {
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              content: Text("Escolha a forma de enviar a foto"),
              actions: <Widget>[
                FlatButton(
                  child: Text("GALERIA"),
                  onPressed: () {
                    setState(() {
                      file1 =
                          ImagePicker.pickImage(source: ImageSource.gallery);
                    });
                    Navigator.pop(context);
                  },
                ),
                FlatButton(
                  child: Text("CAMERA"),
                  onPressed: () {
                    setState(() {
                      file1 = ImagePicker.pickImage(source: ImageSource.camera);
                    });
                    Navigator.pop(context);
                  },
                )
              ],
            );
          });
    }
  }

  chooseImage2() {
    if (this.mounted) {
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              content: Text("Escolha a forma de enviar a foto"),
              actions: <Widget>[
                FlatButton(
                  child: Text("GALERIA"),
                  onPressed: () {
                    setState(() {
                      file2 =
                          ImagePicker.pickImage(source: ImageSource.gallery);
                    });
                    Navigator.pop(context);
                  },
                ),
                FlatButton(
                  child: Text("CAMERA"),
                  onPressed: () {
                    setState(() {
                      file2 = ImagePicker.pickImage(source: ImageSource.camera);
                    });
                    Navigator.pop(context);
                  },
                )
              ],
            );
          });
    }
  }

  saveToLogin(String cpf, String password) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('cpf', cpf);
    prefs.setString('password', password);
  }

  getValues() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //Return String

    _controllerCpfLogin.text = prefs.getString('cpf');
    if (prefs.getString('cpf') != null && this.mounted) {
      setState(() {
        check = true;
      });
    }
    _controllerPasswordLogin.text = prefs.getString('password');
  }

  removeValues() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove("cpf");
    prefs.remove("password");
  }

  List state = [
    {'state': 'Lanches/Restaurantes'},
    {'state': 'Bebidas'},
    {'state': 'SuperMercados'},
    {'state': 'Lojas'},
  ];

  List valueActive = [
    {'active': 'Habilitada'},
    {'active': 'Desabilitada'},
  ];

  _getCurrentLocation() async {
    try {
      Position position = await Geolocator()
          .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);

      setState(() {
        _currentPosition = position;
      });
    } catch (e) {
      Widget okButton = FlatButton(
        child: Text("OK"),
        onPressed: () {
          Navigator.pop(context);
        },
      );
      AlertDialog alerta = AlertDialog(
        title: Text(
          "Atenção",
          style: TextStyle(color: Colors.red),
        ),
        content: Text(
          "POR FAVOR ATIVE SEU GPS PARA CONCLUIR O CADASTRO!",
          style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
        ),
        actions: [
          okButton,
        ],
      );
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return alerta;
        },
      );
    }
  }

  @override
  void initState() {
    getValues();
    super.initState();
  }

  Widget HomePage() {
    pr = new ProgressDialog(context, showLogs: true);
    pr.style(
      message: "Enviando seu Dados...",
      backgroundColor: Colors.deepOrange,
      messageTextStyle: TextStyle(color: Colors.white, fontSize: 18.0),
    );

    return new Scaffold(
        body: Container(
      height: MediaQuery.of(context).size.height,
      decoration: BoxDecoration(
        color: Colors.deepOrange,
        image: DecorationImage(
          colorFilter: new ColorFilter.mode(
              Colors.black.withOpacity(0.1), BlendMode.dstATop),
          image: AssetImage('images/mountains.jpg'),
          fit: BoxFit.cover,
        ),
      ),
      child: new SingleChildScrollView(
          child: Column(
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(top: 250.0),
            child: Center(
              child: Icon(
                Icons.business_center,
                color: Colors.white,
                size: 50.0,
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.only(top: 20.0),
            child: new Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  "Amigo Delivery",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 30.0,
                  ),
                ),
              ],
            ),
          ),
          new Container(
            width: MediaQuery.of(context).size.width,
            margin: const EdgeInsets.only(left: 30.0, right: 30.0, top: 100.0),
            alignment: Alignment.center,
            child: new Row(
              children: <Widget>[
                new Expanded(
                  child: new OutlineButton(
                    shape: new RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(30.0)),
                    color: Colors.deepOrange,
                    highlightedBorderColor: Colors.white,
                    onPressed: () => gotoSignup(),
                    child: new Container(
                      padding: const EdgeInsets.symmetric(
                        vertical: 20.0,
                        horizontal: 20.0,
                      ),
                      child: new Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          new Expanded(
                            child: Text(
                              "CADASTRAR",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          new Container(
            width: MediaQuery.of(context).size.width,
            margin: const EdgeInsets.only(left: 30.0, right: 30.0, top: 30.0),
            alignment: Alignment.center,
            child: new Row(
              children: <Widget>[
                new Expanded(
                  child: new FlatButton(
                    shape: new RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(30.0)),
                    color: Colors.white,
                    onPressed: () => gotoLogin(),
                    child: new Container(
                      padding: const EdgeInsets.symmetric(
                        vertical: 20.0,
                        horizontal: 20.0,
                      ),
                      child: new Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          new Expanded(
                            child: Text(
                              "ENTRAR",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: Colors.deepOrange,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          new Container(
            width: MediaQuery.of(context).size.width,
            margin: const EdgeInsets.only(left: 30.0, right: 30.0, top: 30.0),
            alignment: Alignment.center,
            child: new Row(
              children: <Widget>[
                new Expanded(
                  child: new FlatButton(
                    shape: new RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(30.0)),
                    color: Colors.white,
                    onPressed: () {
                      _logOut();

                      SystemChannels.platform
                          .invokeMethod('SystemNavigator.pop');
                    },
                    child: new Container(
                      padding: const EdgeInsets.symmetric(
                        vertical: 20.0,
                        horizontal: 20.0,
                      ),
                      child: new Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          new Expanded(
                            child: Text(
                              "FECHAR",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: Colors.deepOrange,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      )),
    ));
  }

  Widget LoginPage() {
    return new Scaffold(
          body: Container(
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(
            color: Colors.white,
            image: DecorationImage(
              colorFilter: new ColorFilter.mode(
                  Colors.black.withOpacity(0.05), BlendMode.dstATop),
              image: AssetImage('images/mountains.jpg'),
              fit: BoxFit.cover,
            ),
          ),
          child: new SingleChildScrollView(
              child: Column(
            children: <Widget>[
              Container(
                padding: const EdgeInsets.only(bottom: 10.0, top: 50.0),
                child: Center(
                  child: Icon(
                    Icons.business_center,
                    color: Colors.deepOrange,
                    size: 50.0,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.only(bottom: 40.0),
                child: Center(
                  child: Text(
                    "Amigo Delivery",
                    style: TextStyle(
                        color: Colors.deepOrange,
                        fontWeight: FontWeight.bold,
                        fontSize: 30.0),
                  ),
                ),
              ),
              new Row(
                children: <Widget>[
                  new Expanded(
                    child: new Padding(
                      padding: const EdgeInsets.only(left: 40.0),
                      child: new Text(
                        "CPF",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.redAccent,
                          fontSize: 15.0,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              new Container(
                width: MediaQuery.of(context).size.width,
                margin:
                    const EdgeInsets.only(left: 40.0, right: 40.0, top: 10.0),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                        color: Colors.deepOrange,
                        width: 0.5,
                        style: BorderStyle.solid),
                  ),
                ),
                padding: const EdgeInsets.only(left: 0.0, right: 10.0),
                child: new Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    new Expanded(
                      child: TextField(
                        controller: _controllerCpfLogin,
                        textAlign: TextAlign.left,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Exemplo: 123-451-223.24',
                          hintStyle: TextStyle(color: Colors.grey),
                          errorText: _isFieldCpfLoginValid == null ||
                                  _isFieldCpfLoginValid
                              ? null
                              : "O cpf é obrigatório",
                        ),
                        onChanged: (value) {
                          bool isFieldValid = value.trim().isNotEmpty;
                          if (isFieldValid != _isFieldCpfLoginValid) {
                            if (this.mounted) {
                              setState(
                                  () => _isFieldCpfLoginValid = isFieldValid);
                            }
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ),
              Divider(
                height: 24.0,
              ),
              new Row(
                children: <Widget>[
                  new Expanded(
                    child: new Padding(
                      padding: const EdgeInsets.only(left: 40.0),
                      child: new Text(
                        "SENHA",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.deepOrange,
                          fontSize: 15.0,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              new Container(
                width: MediaQuery.of(context).size.width,
                margin:
                    const EdgeInsets.only(left: 40.0, right: 40.0, top: 10.0),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                        color: Colors.deepOrange,
                        width: 0.5,
                        style: BorderStyle.solid),
                  ),
                ),
                padding: const EdgeInsets.only(left: 0.0, right: 10.0),
                child: new Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    new Expanded(
                      child: TextField(
                        controller: _controllerPasswordLogin,
                        obscureText: true,
                        textAlign: TextAlign.left,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Exemplo (Só Números): 123441',
                          hintStyle: TextStyle(color: Colors.grey),
                          errorText: _isFieldPasswordLoginValid == null ||
                                  _isFieldPasswordLoginValid
                              ? null
                              : "A senha é obrigatória",
                        ),
                        onChanged: (value) {
                          bool isFieldValid = value.trim().isNotEmpty;
                          if (isFieldValid != _isFieldPasswordLoginValid) {
                            if (this.mounted) {
                              setState(() =>
                                  _isFieldPasswordLoginValid = isFieldValid);
                            }
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ),
              Divider(
                height: 24.0,
              ),
              new Container(
                width: MediaQuery.of(context).size.width,
                margin:
                    const EdgeInsets.only(left: 30.0, right: 30.0, top: 20.0),
                alignment: Alignment.center,
                child: new Row(children: <Widget>[
                  new Checkbox(
                      value: check,
                      onChanged: (bool value) {
                        setState(() {
                          check = value;
                        });
                        if (check == true) {
                          saveToLogin(_controllerCpfLogin.text.toString(),
                              _controllerPasswordLogin.text.toString());
                        } else {
                          removeValues();
                        }
                      }),
                  Text("Deseja salvar seus dados?"),
                ]),
              ),
              Divider(
                height: 24.0,
              ),
              new Container(
                width: MediaQuery.of(context).size.width,
                margin:
                    const EdgeInsets.only(left: 30.0, right: 30.0, top: 20.0),
                alignment: Alignment.center,
                child: new Row(
                  children: <Widget>[
                    new Expanded(
                      child: new FlatButton(
                        shape: new RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(30.0),
                        ),
                        color: Colors.deepOrange,
                        onPressed: () {
                          if (check) {
                            _isFieldCpfLoginValid = true;
                            _isFieldPasswordLoginValid = true;
                          }
                          if (_isFieldPasswordLoginValid == null ||
                              _isFieldCpfLoginValid == null ||
                              !_isFieldPasswordLoginValid ||
                              !_isFieldCpfLoginValid) {
                            Scaffold.of(context).showSnackBar(
                              SnackBar(
                                backgroundColor: Colors.blue,
                                content:
                                    Text("Por Favor Preencha Todos os Campos"),
                              ),
                            );
                          } else {
                            String c = _controllerCpfLogin.text.toString();
                            _apiServiceCop.getCopCpf(c).then((cpf) {
                              if (cpf != null) {
                                if (cpf.isNotEmpty) {
                                  if (_controllerPasswordLogin.text
                                          .toString() ==
                                      cpf[0].password) {
                                    if (this.mounted && cpf != null) {
                                      if (CPF.isValid(c)) {
                                        Widget cancelaButton = FlatButton(
                                          child: Text("Cancelar"),
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                        );
                                        Widget continuaButton = FlatButton(
                                          child: Text("Continuar"),
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                            pr.show();
                                            Future.delayed(Duration(seconds: 3))
                                                .then((value) {
                                              pr.hide().whenComplete(() {
                                                if (check) {}
                                                Navigator.pushAndRemoveUntil(
                                                  context,
                                                  CupertinoPageRoute(
                                                      builder: (context) =>
                                                          new HomePage1(
                                                            data: cpf[0],
                                                          )),
                                                  (Route<dynamic> route) =>
                                                      false,
                                                );
                                              });
                                            });
                                          },
                                        );

                                        //configura o AlertDialog
                                        AlertDialog alert = AlertDialog(
                                          content: Text("Deseja continuar?"),
                                          actions: [
                                            cancelaButton,
                                            continuaButton,
                                          ],
                                        );

                                        //exibe o diálogo
                                        showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return alert;
                                          },
                                        );
                                      } else {
                                        Scaffold.of(context).showSnackBar(SnackBar(
                                          backgroundColor: Colors.red,
                                          content: Text("CPF Inválido!"),
                                        ));
                                      }
                                    } else {
                                      Scaffold.of(context).showSnackBar(
                                        SnackBar(
                                          backgroundColor: Colors.blue,
                                          content: Text(
                                              "CPF Inválido ou Já Cadastrado"),
                                        ),
                                      );
                                    }
                                  } else {
                                    Scaffold.of(context).showSnackBar(
                                      SnackBar(
                                        backgroundColor: Colors.blue,
                                        content: Text("Verifique as senhas"),
                                      ),
                                    );
                                  }
                                } else {
                                  Scaffold.of(context).showSnackBar(
                                    SnackBar(
                                      backgroundColor: Colors.blue,
                                      content: Text(
                                          "CPF não Possui Cadastro na Nossa Base de Dados"),
                                    ),
                                  );
                                }
                              } else {
                                Widget cancelaButton = FlatButton(
                                  child: Text("OK"),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                );

                                AlertDialog alert = AlertDialog(
                                  title: Text("Problemas com a Internet!"),
                                  content: Text(
                                      "Verifique sua Conexão ou Contate o Suporte!"),
                                  actions: [
                                    cancelaButton,
                                  ],
                                );

                                //exibe o diálogo
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return alert;
                                  },
                                );
                              }
                            });
                          }
                        },
                        child: new Container(
                          padding: const EdgeInsets.symmetric(
                            vertical: 20.0,
                            horizontal: 20.0,
                          ),
                          child: new Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              new Expanded(
                                child: Text(
                                  "ENTRAR",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          )),
        ));
  }

  Widget SignupPage() {
    return new Scaffold(
      body: Container(
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(
            color: Colors.white,
            image: DecorationImage(
              colorFilter: new ColorFilter.mode(
                  Colors.black.withOpacity(0.05), BlendMode.dstATop),
              image: AssetImage('images/mountains.jpg'),
              fit: BoxFit.cover,
            ),
          ),
          child: new SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Container(
                  padding: const EdgeInsets.only(bottom: 10.0, top: 50.0),
                  child: Center(
                    child: Icon(
                      Icons.business_center,
                      color: Colors.deepOrange,
                      size: 50.0,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.only(bottom: 40.0),
                  child: Center(
                    child: Text(
                      "Amigo Delivery",
                      style: TextStyle(
                          color: Colors.deepOrange,
                          fontWeight: FontWeight.bold,
                          fontSize: 30.0),
                    ),
                  ),
                ),
                valid == false ? _showImage1() : _showImage2(),
                Divider(),
                new Row(
                  children: <Widget>[
                    new Expanded(
                      child: new Padding(
                        padding: const EdgeInsets.only(left: 40.0),
                        child: new Text(
                          "NOME DA EMPRESA",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.deepOrange,
                            fontSize: 15.0,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                new Container(
                  width: MediaQuery.of(context).size.width,
                  margin:
                      const EdgeInsets.only(left: 40.0, right: 40.0, top: 10.0),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                          color: Colors.deepOrange,
                          width: 0.5,
                          style: BorderStyle.solid),
                    ),
                  ),
                  padding: const EdgeInsets.only(left: 0.0, right: 10.0),
                  child: new Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      new Expanded(
                        child: TextField(
                          controller: _controllerName,
                          keyboardType: TextInputType.text,
                          textAlign: TextAlign.left,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: 'Exemplo: Informática Eletrônica',
                            hintStyle: TextStyle(color: Colors.grey),
                            errorText:
                                _isFieldNameValid == null || _isFieldNameValid
                                    ? null
                                    : "Nome da empresa é obrigatório",
                          ),
                          onChanged: (value) {
                            bool isFieldValid = value.trim().isNotEmpty;
                            if (isFieldValid != _isFieldNameValid) {
                              if (this.mounted) {
                                setState(
                                    () => _isFieldNameValid = isFieldValid);
                              }
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                Divider(
                  height: 24.0,
                ),
                new Row(
                  children: <Widget>[
                    new Expanded(
                      child: new Padding(
                        padding: const EdgeInsets.only(left: 40.0),
                        child: new Text(
                          "NOME DO PROPRIETÁRIO",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.deepOrange,
                            fontSize: 15.0,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                new Container(
                  width: MediaQuery.of(context).size.width,
                  margin:
                      const EdgeInsets.only(left: 40.0, right: 40.0, top: 10.0),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                          color: Colors.deepOrange,
                          width: 0.5,
                          style: BorderStyle.solid),
                    ),
                  ),
                  padding: const EdgeInsets.only(left: 0.0, right: 10.0),
                  child: new Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      new Expanded(
                        child: TextField(
                          controller: _controllerOwner,
                          keyboardType: TextInputType.text,
                          textAlign: TextAlign.left,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: 'Exemplo:  Maria Miguel',
                            hintStyle: TextStyle(color: Colors.grey),
                            errorText:
                                _isFieldOwnerValid == null || _isFieldOwnerValid
                                    ? null
                                    : "Nome do proprietário é obrigatório",
                          ),
                          onChanged: (value) {
                            bool isFieldValid = value.trim().isNotEmpty;
                            if (isFieldValid != _isFieldOwnerValid) {
                              if (this.mounted) {
                                setState(
                                    () => _isFieldOwnerValid = isFieldValid);
                              }
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                Divider(
                  height: 24.0,
                ),
                new Row(
                  children: <Widget>[
                    new Expanded(
                      child: new Padding(
                        padding: const EdgeInsets.only(left: 40.0),
                        child: new Text(
                          "CPF",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.deepOrange,
                            fontSize: 15.0,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                new Container(
                  width: MediaQuery.of(context).size.width,
                  margin:
                      const EdgeInsets.only(left: 40.0, right: 40.0, top: 10.0),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                          color: Colors.deepOrange,
                          width: 0.5,
                          style: BorderStyle.solid),
                    ),
                  ),
                  padding: const EdgeInsets.only(left: 0.0, right: 10.0),
                  child: new Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      new Expanded(
                        child: TextField(
                          controller: _controllerCpf_Cnpj,
                          keyboardType: TextInputType.number,
                          textAlign: TextAlign.left,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: 'Exemplo: 123.345.234-12',
                            hintStyle: TextStyle(color: Colors.grey),
                            errorText: _isFieldCpf_CnpjValid == null ||
                                    _isFieldCpf_CnpjValid
                                ? null
                                : "O CPF é obrigatório",
                          ),
                          onChanged: (value) {
                            bool isFieldValid = value.trim().isNotEmpty;
                            if (isFieldValid != _isFieldCpf_CnpjValid) {
                              if (this.mounted) {
                                setState(
                                    () => _isFieldCpf_CnpjValid = isFieldValid);
                              }
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                Divider(
                  height: 24.0,
                ),
                new Row(
                  children: <Widget>[
                    new Expanded(
                      child: new Padding(
                        padding: const EdgeInsets.only(left: 40.0),
                        child: new Text(
                          "TELEFONE DA EMPRESA",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.deepOrange,
                            fontSize: 15.0,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                new Container(
                  width: MediaQuery.of(context).size.width,
                  margin:
                      const EdgeInsets.only(left: 40.0, right: 40.0, top: 10.0),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                          color: Colors.deepOrange,
                          width: 0.5,
                          style: BorderStyle.solid),
                    ),
                  ),
                  padding: const EdgeInsets.only(left: 0.0, right: 10.0),
                  child: new Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      new Expanded(
                        child: TextField(
                          controller: _controllerPhone,
                          keyboardType: TextInputType.number,
                          textAlign: TextAlign.left,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: 'Exemplo: (83) 98124-2390',
                            hintStyle: TextStyle(color: Colors.grey),
                            errorText:
                                _isFieldPhoneValid == null || _isFieldPhoneValid
                                    ? null
                                    : "O telefone é obrigatório",
                          ),
                          onChanged: (value) {
                            bool isFieldValid = value.trim().isNotEmpty;
                            if (isFieldValid != _isFieldPhoneValid) {
                              if (this.mounted) {
                                setState(
                                    () => _isFieldPhoneValid = isFieldValid);
                              }
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                Divider(
                  height: 24.0,
                ),
                new Row(
                  children: <Widget>[
                    new Expanded(
                      child: new Padding(
                        padding: const EdgeInsets.only(left: 40.0),
                        child: new Text(
                          "ENDEREÇO DA EMPRESA",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.deepOrange,
                            fontSize: 15.0,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                new Container(
                  width: MediaQuery.of(context).size.width,
                  margin:
                      const EdgeInsets.only(left: 40.0, right: 40.0, top: 10.0),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                          color: Colors.deepOrange,
                          width: 0.5,
                          style: BorderStyle.solid),
                    ),
                  ),
                  padding: const EdgeInsets.only(left: 0.0, right: 10.0),
                  child: new Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      new Expanded(
                        child: TextField(
                          controller: _controllerAddress,
                          textAlign: TextAlign.left,
                          keyboardType: TextInputType.text,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: 'Exemplo: Rua 26 de Novembro, 234',
                            hintStyle: TextStyle(color: Colors.grey),
                            errorText: _isFieldAddressValid == null ||
                                    _isFieldAddressValid
                                ? null
                                : "O endereço é obrigatório",
                          ),
                          onChanged: (value) {
                            bool isFieldValid = value.trim().isNotEmpty;
                            if (isFieldValid != _isFieldAddressValid) {
                              if (this.mounted) {
                                setState(
                                    () => _isFieldAddressValid = isFieldValid);
                              }
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                Divider(
                  height: 24.0,
                ),
                new Row(
                  children: <Widget>[
                    new Expanded(
                      child: new Padding(
                        padding: const EdgeInsets.only(left: 40.0),
                        child: new Text(
                          "CIDADE",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.deepOrange,
                            fontSize: 15.0,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                new Container(
                  width: MediaQuery.of(context).size.width,
                  margin:
                      const EdgeInsets.only(left: 40.0, right: 40.0, top: 10.0),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                          color: Colors.deepOrange,
                          width: 0.5,
                          style: BorderStyle.solid),
                    ),
                  ),
                  padding: const EdgeInsets.only(left: 0.0, right: 10.0),
                  child: new Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      new Expanded(
                        child: TextField(
                          controller: _controllerCity,
                          textAlign: TextAlign.left,
                          keyboardType: TextInputType.text,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: 'Exemplo: Solânea',
                            hintStyle: TextStyle(color: Colors.grey),
                            errorText:
                                _isFieldCityValid == null || _isFieldCityValid
                                    ? null
                                    : "A cidade é obrigatória",
                          ),
                          onChanged: (value) {
                            bool isFieldValid = value.trim().isNotEmpty;
                            if (isFieldValid != _isFieldCityValid) {
                              if (this.mounted) {
                                setState(
                                    () => _isFieldCityValid = isFieldValid);
                              }
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                Divider(
                  height: 24.0,
                ),
                new Row(
                  children: <Widget>[
                    new Expanded(
                      child: new Padding(
                        padding: const EdgeInsets.only(left: 40.0),
                        child: new Text(
                          "CATEGORIA DA EMPRESA",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.deepOrange,
                            fontSize: 15.0,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                new Container(
                  width: MediaQuery.of(context).size.width,
                  margin:
                      const EdgeInsets.only(left: 40.0, right: 40.0, top: 10.0),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                          color: Colors.deepOrange,
                          width: 0.5,
                          style: BorderStyle.solid),
                    ),
                  ),
                  padding: const EdgeInsets.only(left: 0.0, right: 10.0),
                  child: new Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      new Expanded(
                        child: new DropdownButtonFormField(
                          hint: _mySelection2 == null
                              ? Text(state[0]["state"])
                              : Text(_mySelection2),
                          items: state.map((item) {
                            return new DropdownMenuItem(
                              child: new Text(item['state']),
                              value: item['state'].toString(),
                            );
                          }).toList(),
                          onChanged: (newVal) {
                            if (this.mounted) {
                              setState(() {
                                _mySelection2 = newVal;
                                setState(() => _isFieldStateValid =
                                    _mySelection2.isNotEmpty);
                              });
                            }
                          },
                          value: _mySelection2,
                        ),
                      ),
                    ],
                  ),
                ),
                Divider(
                  height: 24.0,
                ),
                new Row(
                  children: <Widget>[
                    new Expanded(
                      child: new Padding(
                        padding: const EdgeInsets.only(left: 40.0),
                        child: new Text(
                          "SENHA",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.deepOrange,
                            fontSize: 15.0,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                new Container(
                  width: MediaQuery.of(context).size.width,
                  margin:
                      const EdgeInsets.only(left: 40.0, right: 40.0, top: 10.0),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                          color: Colors.deepOrange,
                          width: 0.5,
                          style: BorderStyle.solid),
                    ),
                  ),
                  padding: const EdgeInsets.only(left: 0.0, right: 10.0),
                  child: new Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      new Expanded(
                        child: TextField(
                          controller: _controllerPassword2,
                          obscureText: true,
                          keyboardType: TextInputType.number,
                          textAlign: TextAlign.left,
                          inputFormatters: <TextInputFormatter>[
                            WhitelistingTextInputFormatter.digitsOnly
                          ],
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: 'Exemplo (Só Números): 123441',
                            hintStyle: TextStyle(color: Colors.grey),
                          ),
                          onChanged: (newVal) {
                            if (this.mounted) {
                              setState(() {
                                password1 = newVal;
                                _isFieldPasswordValid = password2 == password1;
                              });
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                Divider(
                  height: 24.0,
                ),
                new Row(
                  children: <Widget>[
                    new Expanded(
                      child: new Padding(
                        padding: const EdgeInsets.only(left: 40.0),
                        child: new Text(
                          "CONFIRMAR SENHA",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.deepOrange,
                            fontSize: 15.0,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                new Container(
                  width: MediaQuery.of(context).size.width,
                  margin:
                      const EdgeInsets.only(left: 40.0, right: 40.0, top: 10.0),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                          color: Colors.deepOrange,
                          width: 0.5,
                          style: BorderStyle.solid),
                    ),
                  ),
                  padding: const EdgeInsets.only(left: 0.0, right: 10.0),
                  child: new Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      new Expanded(
                        child: TextField(
                          autofocus: false,
                          controller: _controllerPassword,
                          keyboardType: TextInputType.number,
                          obscureText: true,
                          textAlign: TextAlign.left,
                          inputFormatters: <TextInputFormatter>[
                            WhitelistingTextInputFormatter.digitsOnly
                          ],
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: 'Exemplo (Só Números): 123441',
                            hintStyle: TextStyle(color: Colors.grey),
                            errorText: _isFieldPasswordValid == null ||
                                    _isFieldPasswordValid
                                ? null
                                : "As senhas estão diferentes",
                          ),
                          onChanged: (value) {
                            bool isFieldValid = password1 == value;
                            password2 = value;
                            if (isFieldValid != _isFieldPasswordValid) {
                              if (this.mounted) {
                                setState(
                                    () => _isFieldPasswordValid = isFieldValid);
                              }
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                Divider(
                  height: 84.0,
                ),
                
              ],
            ),
          )),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.deepOrange,
        child: Icon(Icons.check_circle_outline),
        onPressed: () {
          String cpf_cnpj = _controllerCpf_Cnpj.text.toString();
          _getCurrentLocation();

          if (_isFieldNameValid == null ||
              _isFieldOwnerValid == null ||
              _isFieldCpf_CnpjValid == null ||
              _isFieldAddressValid == null ||
              _isFieldStateValid == null ||
              _isFieldCityValid == null ||
              _isFieldPhoneValid == null ||
              _isFieldPasswordValid == null ||
              base64Image == null ||
              !_isFieldNameValid ||
              !_isFieldStateValid ||
              !_isFieldImageValid ||
              !_isFieldOwnerValid ||
              !_isFieldAddressValid ||
              !_isFieldCpf_CnpjValid ||
              !_isFieldCityValid ||
              !_isFieldPhoneValid) {
            Scaffold.of(context).showSnackBar(
              SnackBar(
                backgroundColor: Colors.blue,
                content: Text("Por Favor Preencha Todos os Campos"),
              ),
            );
          } else {
            _apiServiceCop.getCopCpf(cpf_cnpj).then((cpf) {
              if (cpf.isEmpty || cpf[0].cpf_cnpj != "0") {
                if (password1 == password2) {
                  if (this.mounted && cpf != null && cpf.isEmpty) {
                    if (CPF.isValid(cpf_cnpj)) {
                      Widget cancelaButton = FlatButton(
                        child: Text("Cancelar"),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      );
                      Widget continuaButton = FlatButton(
                        child: Text("Continuar"),
                        onPressed: () {
                          Navigator.of(context).pop();
                          pr.show();
                          Future.delayed(Duration(seconds: 5)).then((value) {
                            pr.hide().whenComplete(() {
                              if (_currentPosition == null) {
                                Widget okButton = FlatButton(
                                  child: Text("OK"),
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                );
                                AlertDialog alerta = AlertDialog(
                                  title: Text(
                                    "Atenção",
                                    style: TextStyle(color: Colors.red),
                                  ),
                                  content: Text(
                                    "POR FAVOR ATIVE SEU GPS PARA CONCLUIR O CADASTRO OU TENTE NOVAMENTE!",
                                    style: TextStyle(
                                        color: Colors.blue,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  actions: [
                                    okButton,
                                  ],
                                );
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return alerta;
                                  },
                                );
                              } else {
                                if (this.mounted) {
                                  setState(() => _isLoading = true);
                                }

                                String name = _controllerName.text.toString();
                                String owner = _controllerOwner.text.toString();
                                String address =
                                    _controllerAddress.text.toString();
                                String phone = _controllerPhone.text.toString();
                                String city = _controllerCity.text.toString();

                                Company cop = Company(
                                    name: name,
                                    image: base64Image,
                                    category: _mySelection2,
                                    cpf_cnpj: cpf_cnpj,
                                    phone: phone,
                                    owner: owner,
                                    address: address,
                                    city: city,
                                    lat: _currentPosition.latitude.toString(),
                                    lon: _currentPosition.longitude.toString(),
                                    password: password2);

                                _apiServiceCop.createCop(cop).then((isSuccess) {
                                  if (this.mounted) {
                                    setState(() => _isLoading = false);
                                  }

                                  if (isSuccess) {
                                    Widget cancelaButton = FlatButton(
                                      child: Text("OK"),
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                    );

                                    AlertDialog alert = AlertDialog(
                                      title: Text(
                                          "Cadastro Realizado com Sucesso"),
                                      content: Text(
                                          "Vamos lá, agora você pode gerenciar os seus produtos!"),
                                      actions: [
                                        cancelaButton,
                                      ],
                                    );

                                    //exibe o diálogo
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return alert;
                                      },
                                    );

                                    _controllerName.clear();
                                    _controllerOwner.clear();
                                    _controllerAddress.clear();
                                    _controllerPhone.clear();
                                    _controllerCity.clear();
                                    _controllerCpf_Cnpj.clear();
                                    _controllerPassword2.clear();
                                    _controllerPassword.clear();
                                    if (valid == false) {
                                      setState(() {
                                        valid = true;
                                        file1 = null;
                                      });
                                    } else {
                                      setState(() {
                                        valid = false;
                                        file2 = null;
                                      });
                                    }

                                    gotoLogin();
                                  } else {
                                    Scaffold.of(context)..showSnackBar(SnackBar(
                                      backgroundColor: Colors.red,
                                      content: Text("Falha ao Enviar os Dados"),
                                    ));
                                  }
                                });
                              }
                            });
                          });
                        },
                      );

                      //configura o AlertDialog
                      AlertDialog alert = AlertDialog(
                        title: Text("Confirmar Cadastro!"),
                        content: Text("Deseja continuar?"),
                        actions: [
                          cancelaButton,
                          continuaButton,
                        ],
                      );

                      //exibe o diálogo
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return alert;
                        },
                      );
                    } else {
                      Scaffold.of(context).showSnackBar(SnackBar(
                        backgroundColor: Colors.red,
                        content: Text("CPF Inválido!"),
                      ));
                    }
                  } else {
                    Scaffold.of(context).showSnackBar(
                      SnackBar(
                        backgroundColor: Colors.blue,
                        content: Text("CPF Inválido ou Já Cadastrado"),
                      ),
                    );
                  }
                } else {
                  Scaffold.of(context).showSnackBar(
                    SnackBar(
                      backgroundColor: Colors.blue,
                      content: Text("Verifique as senhas"),
                    ),
                  );
                }
              } else {
                Widget cancelaButton = FlatButton(
                  child: Text("OK"),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                );

                AlertDialog alert = AlertDialog(
                  title: Text("Problemas com a Internet!"),
                  content: Text("Verifique sua Conexão ou Contate o Suporte!"),
                  actions: [
                    cancelaButton,
                  ],
                );

                //exibe o diálogo
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return alert;
                  },
                );
              }
            });
          }
        },
      ),
    );
  }

  gotoLogin() {
    //controller_0To1.forward(from: 0.0);
    _controller.animateToPage(
      0,
      duration: Duration(milliseconds: 800),
      curve: Curves.bounceOut,
    );
  }

  gotoSignup() {
    //controller_minus1To0.reverse(from: 0.0);
    _controller.animateToPage(
      2,
      duration: Duration(milliseconds: 800),
      curve: Curves.bounceOut,
    );
  }

  PageController _controller =
      new PageController(initialPage: 1, viewportFraction: 1.0);

  @override
  Widget build(BuildContext context) {
    return Container(
        height: MediaQuery.of(context).size.height,
        child: PageView(
          controller: _controller,
          physics: new AlwaysScrollableScrollPhysics(),
          children: <Widget>[LoginPage(), HomePage(), SignupPage()],
          scrollDirection: Axis.horizontal,
        ));
  }

  Widget _showImage1() {
    return FutureBuilder<File>(
      future: file1,
      builder: (BuildContext context, AsyncSnapshot<File> snapshot) {
        if (snapshot.connectionState == ConnectionState.done &&
            null != snapshot.data) {
          tmpFile = snapshot.data;
          base64Image = base64Encode(snapshot.data.readAsBytesSync());
          _isFieldImageValid = true;

          return Wrap(
            children: <Widget>[
              GestureDetector(
                onTap: chooseImage1,
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      ClipRRect(
                        borderRadius: BorderRadius.circular(150),
                        child: Image.file(
                          snapshot.data,
                          cacheHeight: 250,
                          cacheWidth: 250,
                        ),
                      ),
                    ]),
              ),
            ],
          );
        } else if (null != snapshot.error && valid == false) {
          return GestureDetector(
              onTap: chooseImage1,
              child: Column(
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text("IMAGEM DA EMPRESA"),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Icon(
                        Icons.photo_camera,
                        size: 50.0,
                        color: Colors.deepOrange,
                      ),
                    ],
                  ),
                ],
              ));
        } else {
          return GestureDetector(
              onTap: chooseImage1,
              child: Column(
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text("IMAGEM DA EMPRESA"),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Icon(
                        Icons.photo_camera,
                        size: 50.0,
                        color: Colors.deepOrange,
                      ),
                    ],
                  ),
                ],
              ));
        }
      },
    );
  }

  Widget _showImage2() {
    return FutureBuilder<File>(
      future: file2,
      builder: (BuildContext context, AsyncSnapshot<File> snapshot) {
        if (snapshot.connectionState == ConnectionState.done &&
            null != snapshot.data) {
          tmpFile = snapshot.data;
          base64Image = base64Encode(snapshot.data.readAsBytesSync());
          _isFieldImageValid = true;

          return Wrap(
            children: <Widget>[
              GestureDetector(
                onTap: chooseImage2,
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      ClipRRect(
                        borderRadius: BorderRadius.circular(150),
                        child: Image.file(
                          snapshot.data,
                          cacheHeight: 250,
                          cacheWidth: 250,
                        ),
                      ),
                    ]),
              ),
            ],
          );
        } else if (null != snapshot.error && valid == false) {
          return GestureDetector(
              onTap: chooseImage2,
              child: Column(
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text("IMAGEM DA EMPRESA"),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Icon(
                        Icons.photo_camera,
                        size: 50.0,
                        color: Colors.deepOrange,
                      ),
                    ],
                  ),
                ],
              ));
        } else {
          return GestureDetector(
              onTap: chooseImage2,
              child: Column(
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text("IMAGEM DA EMPRESA"),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Icon(
                        Icons.photo_camera,
                        size: 50.0,
                        color: Colors.deepOrange,
                      ),
                    ],
                  ),
                ],
              ));
        }
      },
    );
  }
}
