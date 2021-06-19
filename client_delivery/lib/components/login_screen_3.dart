import 'dart:async';
import 'package:flutter/services.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:flutter/material.dart';
import 'package:amigodelivery/api/api_service_user.dart';
import 'package:amigodelivery/model/user.dart';
import 'package:amigodelivery/pages/companys.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as JSON;

import 'package:amigodelivery/home.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';

GoogleSignIn _googleSignIn = GoogleSignIn(
  scopes: <String>[
    'email',
    'https://www.googleapis.com/auth/userinfo.profile',
  ],
);

class LoginScreen3 extends StatefulWidget {
  @override
  _LoginScreen3State createState() => new _LoginScreen3State();
}

class _LoginScreen3State extends State<LoginScreen3>
    with TickerProviderStateMixin {
  GoogleSignInAccount _currentUser;
  String _contactText;

  ApiServiceUser _apiServiceUser = ApiServiceUser();

  static final FacebookLogin facebookSignIn = new FacebookLogin();

  String _message = 'Log in/out by pressing the buttons below.';

  ProgressDialog pr;
  TextEditingController _controllerEmailLogin = TextEditingController();
  TextEditingController _controllerPasswordLogin = TextEditingController();

  TextEditingController _controllerNameSignUp = TextEditingController();
  TextEditingController _controllerEmailSignUp = TextEditingController();
  TextEditingController _controllerPasswordSignUp = TextEditingController();
  TextEditingController _controllerPasswordConfirm = TextEditingController();

  bool _isFieldEmailLoginValid;
  bool _isFieldPasswordLoginValid;

  bool _isFieldNameSignUpValid;
  bool _isFieldEmailSignUpValid;
  bool _isFieldPasswordConfirmValid;
  bool _isFieldPasswordSignUpValid;

  String password1;
  String password2;

  bool check = false;

  alertShow(String show) {
    Widget cancelaButton = FlatButton(
      child: Text("OK"),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );

    AlertDialog alert = AlertDialog(
      content: Text(show),
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

  Future<Null> _login() async {
    final FacebookLoginResult result = await facebookSignIn.logIn(['email']);
    var profile;

    switch (result.status) {
      case FacebookLoginStatus.loggedIn:
        final FacebookAccessToken accessToken = result.accessToken;

        final graphResponse = await http.get(
            'https://graph.facebook.com/v2.12/me?fields=name,picture,email&access_token=${accessToken.token}');
        profile = JSON.jsonDecode(graphResponse.body);

        _showMessage('''
         Logged in!
         
         
         
         Token: ${accessToken.token}
         User id: ${accessToken.userId}
         Expires: ${accessToken.expires}
         Permissions: ${accessToken.permissions}
         Declined permissions: ${accessToken.declinedPermissions}
         ''');
        break;
      case FacebookLoginStatus.cancelledByUser:
        _showMessage('Login cancelled by the user.');
        break;
      case FacebookLoginStatus.error:
        _showMessage('Something went wrong with the login process.\n'
            'Here\'s the error Facebook gave us: ${result.errorMessage}');
        break;
    }

    Navigator.pushAndRemoveUntil(
      context,
      CupertinoPageRoute(
          builder: (context) =>
              new MyAppC(name: profile["name"], email: profile["email"])),
      (Route<dynamic> route) => false,
    );
  }

  Future<Null> _logOut() async {
    await facebookSignIn.logOut();
    _showMessage('Logged out.');
  }

  void _showMessage(String message) {
    setState(() {
      _message = message;
    });
  }

  saveToLogin(String email, String password) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    prefs.setString('email', email);
    prefs.setString('password', password);
  }

  getValues() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //Return String

    _controllerEmailLogin.text = prefs.getString('email');
    if (prefs.getString('email') != null && this.mounted) {
      setState(() {
        check = true;
      });
    }

    _controllerPasswordLogin.text = prefs.getString('password');
  }

  removeValues() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _controllerEmailLogin.clear();
    _controllerPasswordLogin.clear();
    prefs.remove("email");
    prefs.remove("password");
  }

  @override
  void initState() {
    getValues();
    super.initState();

    _googleSignIn.onCurrentUserChanged.listen((GoogleSignInAccount account) {
      _currentUser = account;
      if (mounted) {
        setState(() {
          _currentUser = account;
          Navigator.pushAndRemoveUntil(
            context,
            CupertinoPageRoute(
                builder: (context) => new MyAppC(
                    name: account.displayName, email: account.email)),
            (Route<dynamic> route) => false,
          );
        });
      }

      if (_currentUser != null) {
//        _handleGetContact();
      }
    });
    _googleSignIn.signInSilently();
  }

  Future<void> _handleSignIn() async {
    try {
      if (_googleSignIn.currentUser != null) {
        Navigator.pushAndRemoveUntil(
          context,
          CupertinoPageRoute(
              builder: (context) => new MyAppC(
                  name: _googleSignIn.currentUser.displayName,
                  email: _googleSignIn.currentUser.email)),
          (Route<dynamic> route) => false,
        );
      }
      await _googleSignIn.signIn();
    } catch (error) {
      print(error);
    }
  }

  Future<void> _handleSignOut() => _googleSignIn.disconnect();

  Widget HomePage() {
    pr = new ProgressDialog(context, showLogs: true);
    pr.style(
      message: "Concluindo...",
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
              Colors.black.withOpacity(0), BlendMode.dstATop),
          image: AssetImage('images/mountains.jpg'),
          fit: BoxFit.cover,
        ),
      ),
      child: new SingleChildScrollView(
          child: Column(
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(top: 220.0),
            child: Center(
              child: Icon(
                Icons.person_pin,
                color: Colors.white,
                size: 50.0,
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.only(top: 10.0),
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
            margin: const EdgeInsets.only(left: 30.0, right: 30.0, top: 80.0),
            alignment: Alignment.center,
            child: new Row(
              children: <Widget>[
                new Expanded(
                  child: new OutlineButton(
                    shape: new RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(30.0)),
                    color: Colors.deepOrange,
                    highlightedBorderColor: Colors.white,
                    onPressed: () => gotoPrivacity(),
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
                              "POLÍTICAS DE PRIVACIDADE",
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
            margin: const EdgeInsets.only(left: 30.0, right: 30.0, top: 10.0),
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
            margin: const EdgeInsets.only(left: 30.0, right: 30.0, top: 10.0),
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
            margin: const EdgeInsets.only(left: 30.0, right: 30.0, top: 10.0),
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
                      _handleSignOut();
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
              Colors.black.withOpacity(0), BlendMode.dstATop),
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
                Icons.person_pin,
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
                    fontSize: 20),
              ),
            ),
          ),
          new Row(
            children: <Widget>[
              new Expanded(
                child: new Padding(
                  padding: const EdgeInsets.only(left: 40.0),
                  child: new Text(
                    "EMAIL",
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
            margin: const EdgeInsets.only(left: 40.0, right: 40.0, top: 10.0),
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
                    controller: _controllerEmailLogin,
                    textAlign: TextAlign.left,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Exemplo: seuemail@gmail.com',
                      hintStyle: TextStyle(color: Colors.grey),
                      errorText: _isFieldEmailLoginValid == null ||
                              _isFieldEmailLoginValid
                          ? null
                          : "O email é obrigatório",
                    ),
                    onChanged: (value) {
                      bool isFieldValid = value.trim().isNotEmpty;
                      if (isFieldValid != _isFieldEmailLoginValid) {
                        if (this.mounted) {
                          setState(
                              () => _isFieldEmailLoginValid = isFieldValid);
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
            margin: const EdgeInsets.only(left: 40.0, right: 40.0, top: 10.0),
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
                      hintText: '*********',
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
                          setState(
                              () => _isFieldPasswordLoginValid = isFieldValid);
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
            margin: const EdgeInsets.only(left: 30.0, right: 30.0, top: 5.0),
            alignment: Alignment.center,
            child: new Row(children: <Widget>[
              new Checkbox(
                  value: check,
                  onChanged: (bool value) {
                    setState(() {
                      check = value;

                      if (check == true) {
                        saveToLogin(_controllerEmailLogin.text.toString(),
                            _controllerPasswordLogin.text.toString());
                      } else {
                        removeValues();
                      }
                    });
                  }),
              Text("Deseja salvar seus dados?"),
            ]),
          ),
          Divider(
            height: 24.0,
          ),
          new Container(
            width: MediaQuery.of(context).size.width,
            margin: const EdgeInsets.only(left: 30.0, right: 30.0, top: 20.0),
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
                        _isFieldEmailLoginValid = true;
                        _isFieldPasswordLoginValid = true;
                      }
                      if (_isFieldPasswordLoginValid == null ||
                          _isFieldEmailLoginValid == null ||
                          !_isFieldPasswordLoginValid ||
                          !_isFieldEmailLoginValid) {
                        alertShow("Por Favor Preencha Todos os Campos");
                      } else {
                        String email = _controllerEmailLogin.text.toString();

                        if (EmailValidator.validate(email)) {
                          pr.show();
                          Future.delayed(const Duration(seconds: 3), () {
                            _apiServiceUser.getUserEmail(email).then((user) {
                              if (this.mounted && user != null) {
                                if (user.isNotEmpty) {
                                  if (this.mounted && user != null) {
                                    if (_controllerPasswordLogin.text
                                            .toString() ==
                                        user[0].password) {
                                      pr.hide();
                                      Navigator.pushAndRemoveUntil(
                                        context,
                                        CupertinoPageRoute(
                                            builder: (context) => new MyAppC(
                                                name: user[0].name,
                                                email: user[0].email)),
                                        (Route<dynamic> route) => false,
                                      );
                                    } else {
                                      alertShow("Verifique a Senha");
                                    }
                                  } else {
                                    alertShow(
                                        "Verifique sua Conexão ou Contate o Suporte!");
                                  }
                                } else {
                                  alertShow(
                                      "Email não Possui Cadastro na Nossa Base de Dados");
                                }
                              } else {
                                alertShow(
                                    "Verifique sua Conexão ou Contate o Suporte!");
                              }
                            });
                          });
                        } else {
                          alertShow("Email Inválido!");
                        }
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
          new Container(
            width: MediaQuery.of(context).size.width,
            margin: const EdgeInsets.only(left: 30.0, right: 30.0, top: 20.0),
            alignment: Alignment.center,
            child: Row(
              children: <Widget>[
                new Expanded(
                  child: new Container(
                    margin: EdgeInsets.all(8.0),
                    decoration: BoxDecoration(border: Border.all(width: 0.25)),
                  ),
                ),
                Text(
                  "OU CONECTAR COM",
                  style: TextStyle(
                    color: Colors.grey,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                new Expanded(
                  child: new Container(
                    margin: EdgeInsets.all(8.0),
                    decoration: BoxDecoration(border: Border.all(width: 0.25)),
                  ),
                ),
              ],
            ),
          ),
          new Container(
            width: MediaQuery.of(context).size.width,
            margin: const EdgeInsets.only(left: 30.0, right: 30.0, top: 20.0),
            child: new Row(
              children: <Widget>[
                new Expanded(
                  child: new Container(
                    margin: EdgeInsets.only(right: 8.0),
                    alignment: Alignment.center,
                    child: new Row(
                      children: <Widget>[
                        new Expanded(
                          child: new SignInButton(
                            Buttons.Facebook,
                            text: "FACEBOOCK",
                            onPressed: () {
                              pr.show();
                              Future.delayed(Duration(seconds: 4))
                                  .then((value) {
                                pr.hide().whenComplete(() {
                                  _login();
                                });
                              });
                            },
                            shape: new RoundedRectangleBorder(
                              borderRadius: new BorderRadius.circular(30.0),
                            ),
                            padding: EdgeInsets.only(
                              top: 20.0,
                              bottom: 20.0,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                new Expanded(
                  child: new Container(
                    margin: EdgeInsets.only(left: 8.0),
                    alignment: Alignment.center,
                    child: new Row(
                      children: <Widget>[
                        new Expanded(
                          child: new SignInButton(
                            Buttons.Google,
                            text: "GOOGLE",
                            onPressed: () {
                              pr.show();
                              Future.delayed(Duration(seconds: 4))
                                  .then((value) {
                                pr.hide().whenComplete(() {
                                  _handleSignIn();
                                });
                              });
                            },
                            shape: new RoundedRectangleBorder(
                              borderRadius: new BorderRadius.circular(30.0),
                            ),
                            padding: EdgeInsets.only(
                              top: 13.0,
                              bottom: 13.0,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          new Container(
            width: MediaQuery.of(context).size.width,
            margin: const EdgeInsets.only(left: 30.0, right: 30.0, top: 20.0),
            alignment: Alignment.center,
            child: Row(
              children: <Widget>[
                new Expanded(
                  child: new Container(
                    margin: EdgeInsets.all(8.0),
                    decoration: BoxDecoration(border: Border.all(width: 0.25)),
                  ),
                ),
                FlatButton(
                  child: Text("ENTRAR COMO CONVIDADO",
                      style: TextStyle(color: Colors.white)),
                  color: Colors.deepOrange,
                  onPressed: () {
                    Navigator.pushAndRemoveUntil(
                      context,
                      CupertinoPageRoute(
                          builder: (context) => new MyAppC(
                              name: "Convidado",
                              email: "convidado@convidado.com")),
                      (Route<dynamic> route) => false,
                    );
                  },
                ),
                new Expanded(
                  child: new Container(
                    margin: EdgeInsets.all(8.0),
                    decoration: BoxDecoration(border: Border.all(width: 0.25)),
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
                    Colors.black.withOpacity(0), BlendMode.dstATop),
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
                        Icons.person_pin,
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
                            fontSize: 20),
                      ),
                    ),
                  ),
                  new Row(
                    children: <Widget>[
                      new Expanded(
                        child: new Padding(
                          padding: const EdgeInsets.only(left: 40.0),
                          child: new Text(
                            "NOME",
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
                    margin: const EdgeInsets.only(
                        left: 40.0, right: 40.0, top: 10.0),
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
                            controller: _controllerNameSignUp,
                            textAlign: TextAlign.left,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: 'Exemplo: Maria Jose',
                              hintStyle: TextStyle(color: Colors.grey),
                              errorText: _isFieldPasswordSignUpValid == null ||
                                      _isFieldPasswordSignUpValid
                                  ? null
                                  : "O nome é obrigatório",
                            ),
                            onChanged: (value) {
                              bool isFieldValid = value.trim().isNotEmpty;
                              if (isFieldValid != _isFieldNameSignUpValid) {
                                if (this.mounted) {
                                  setState(() =>
                                      _isFieldNameSignUpValid = isFieldValid);
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
                            "EMAIL",
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
                    margin: const EdgeInsets.only(
                        left: 40.0, right: 40.0, top: 10.0),
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
                            controller: _controllerEmailSignUp,
                            textAlign: TextAlign.left,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: 'Exemplo: seuemail@gmail.com',
                              hintStyle: TextStyle(color: Colors.grey),
                            ),
                            onChanged: (value) {
                              bool isFieldValid = value.trim().isNotEmpty;
                              if (isFieldValid != _isFieldEmailSignUpValid) {
                                if (this.mounted) {
                                  setState(() =>
                                      _isFieldEmailSignUpValid = isFieldValid);
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
                    margin: const EdgeInsets.only(
                        left: 40.0, right: 40.0, top: 10.0),
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
                            controller: _controllerPasswordSignUp,
                            obscureText: true,
                            textAlign: TextAlign.left,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: '********',
                              hintStyle: TextStyle(color: Colors.grey),
                            ),
                            onChanged: (newVal) {
                              if (this.mounted) {
                                setState(() {
                                  password1 = newVal;

                                  _isFieldPasswordSignUpValid =
                                      password2 == password1;
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
                    margin: const EdgeInsets.only(
                        left: 40.0, right: 40.0, top: 10.0),
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
                            controller: _controllerPasswordConfirm,
                            obscureText: true,
                            textAlign: TextAlign.left,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: '********',
                              hintStyle: TextStyle(color: Colors.grey),
                              errorText: _isFieldPasswordSignUpValid == null ||
                                      _isFieldPasswordSignUpValid
                                  ? null
                                  : "As senhas estão diferentes",
                            ),
                            onChanged: (value) {
                              bool isFieldValid = password1 == value;
                              password2 = value;
                              if (isFieldValid != _isFieldPasswordSignUpValid) {
                                if (this.mounted) {
                                  setState(() => _isFieldPasswordSignUpValid =
                                      isFieldValid);
                                }
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  new Container(
                    width: MediaQuery.of(context).size.width,
                    margin: const EdgeInsets.only(
                        left: 30.0, right: 30.0, top: 50.0),
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
                              if (_isFieldNameSignUpValid == null ||
                                  _isFieldEmailSignUpValid == null ||
                                  _isFieldPasswordSignUpValid == null ||
                                  !_isFieldPasswordSignUpValid ||
                                  !_isFieldNameSignUpValid ||
                                  !_isFieldEmailSignUpValid) {
                                alertShow("Por Favor Preencha Todos os Campos");
                              } else {
                                String email =
                                    _controllerEmailSignUp.text.toString();
                                if (EmailValidator.validate(email)) {
                                  pr.show();

                                  _apiServiceUser
                                      .getUserEmail(email)
                                      .then((value) {
                                    pr.hide();

                                    if (value != null) {
                                      if (password1 == password2) {
                                        if (this.mounted &&
                                            value != null &&
                                            value.isEmpty) {
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

                                              String name =
                                                  _controllerNameSignUp.text
                                                      .toString();
                                              String email =
                                                  _controllerEmailSignUp.text
                                                      .toString();
                                              String password =
                                                  _controllerPasswordSignUp.text
                                                      .toString();

                                              User user = User(
                                                  name: name,
                                                  email: email,
                                                  password: password);

                                              _apiServiceUser
                                                  .createUser(user)
                                                  .then((isSuccess) {
                                                if (isSuccess) {
                                                  alertShow(
                                                      "Cadastro Realizado Com Sucesso");

                                                  _controllerNameSignUp.clear();
                                                  _controllerPasswordSignUp
                                                      .clear();
                                                  _controllerEmailSignUp
                                                      .clear();

                                                  gotoLogin();
                                                } else {
                                                  alertShow(
                                                      "Falha ao Enviar os Dados");
                                                }
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
                                          alertShow(
                                              "Email Inválido ou Já Cadastrado");
                                        }
                                      } else {
                                        alertShow("Verifique as senhas");
                                      }
                                    } else {
                                      Widget cancelaButton = FlatButton(
                                        child: Text("OK"),
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                      );

                                      AlertDialog alert = AlertDialog(
                                        title:
                                            Text("Problemas com a Internet!"),
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
                                } else {
                                  alertShow("Email Inválido");
                                }
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
                ],
              ),
            )));
  }

  Widget Privacity() {
    return new Scaffold(
        body: Container(
            height: MediaQuery.of(context).size.height,
            decoration: BoxDecoration(
              color: Colors.white,
              image: DecorationImage(
                colorFilter: new ColorFilter.mode(
                    Colors.black.withOpacity(0), BlendMode.dstATop),
                image: AssetImage('images/mountains.jpg'),
                fit: BoxFit.cover,
              ),
            ),
            child: new SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  Container(
                    padding: const EdgeInsets.only(bottom: 10.0, top: 70.0),
                    child: Center(
                      child: Icon(
                        Icons.person_pin,
                        color: Colors.deepOrange,
                        size: 50.0,
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.only(bottom: 40.0),
                    child: Center(
                      child: Text(
                        "Políticas de Privacidade",
                        style: TextStyle(
                            color: Colors.deepOrange,
                            fontWeight: FontWeight.bold,
                            fontSize: 20),
                      ),
                    ),
                  ),
                  new Row(
                    children: <Widget>[
                      new Expanded(
                        child: new Padding(
                          padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                          child: new Text(
                            "Nós, do Amigo Delivery, estamos comprometidos com a proteção da sua privacidade. "
                                "Antes por favor leia atentamente as seguintes informações importantes, "
                                "que dizem respeito à proteção dos seus dados pessoais.",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.deepOrange,
                              fontSize: 15.0,
                            ),textAlign: TextAlign.justify,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Divider(),
                  new Row(
                    children: <Widget>[
                      new Expanded(
                        child: new Padding(
                          padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                          child: new Text(
                            "Processamento de Dados Pessoais e Divulgação",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.deepOrange,
                              fontSize: 15.0,
                            ),textAlign: TextAlign.justify,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Divider(),
                  new Row(
                    children: <Widget>[
                      new Expanded(
                        child: new Padding(
                          padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                          child: new Text(
                            "Vamos realizar e processar todas as informações pessoais que você fornecer "
                                "através do aplicativo para os nossos próprios fins comerciais internos, "
                                "incluindo fins legais. Nós não iremos repassar ou vender informações "
                                "pessoais on-line a terceiros. Por favor, note que, ao enviar suas informações "
                                "pessoais para nós, você consente expressamente com o tratamento"
                                " e a transferência de tais informações desta forma.",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.deepOrange,
                              fontSize: 15.0,
                            ),textAlign: TextAlign.justify,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Divider(),
                  new Row(
                    children: <Widget>[
                      new Expanded(
                        child: new Padding(
                          padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                          child: new Text(
                            "No aplicativo será possível obter seu dados das seguintes plataformas:",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.deepOrange,
                              fontSize: 15.0,
                            ),textAlign: TextAlign.justify,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Divider(),
                  new Row(
                    children: <Widget>[
                      new Expanded(
                        child: new Padding(
                          padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                          child: new Text(
                            "- Facebook;",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.deepOrange,
                              fontSize: 15.0,
                            ),textAlign: TextAlign.justify,
                          ),
                        ),
                      ),
                    ],
                  ),
                  new Row(
                    children: <Widget>[
                      new Expanded(
                        child: new Padding(
                          padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                          child: new Text(
                            "- Gmail;",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.deepOrange,
                              fontSize: 15.0,
                            ),textAlign: TextAlign.justify,
                          ),
                        ),
                      ),
                    ],
                  ),
                  new Row(
                    children: <Widget>[
                      new Expanded(
                        child: new Padding(
                          padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                          child: new Text(
                            "- Localização do Celular.",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.deepOrange,
                              fontSize: 15.0,
                            ),textAlign: TextAlign.justify,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Divider(),
                  new Row(
                    children: <Widget>[
                      new Expanded(
                        child: new Padding(
                          padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                          child: new Text(
                            "Todos os seus dados serão enviado para nossa API "
                                "endereçada em (https://apibebidas.herokuapp.com) "
                                "com total sigilo somente para o uso necessário.",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.deepOrange,
                              fontSize: 15.0,
                            ),textAlign: TextAlign.justify,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Divider(),
                  new Row(
                    children: <Widget>[
                      new Expanded(
                        child: new Padding(
                          padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                          child: new Text(
                            "Os dados presentes no aplicativo assim como sua localização "
                                "serão armazenadas e excluídas a pedido do usuário, "
                                "o mesmo pode revogar para fins jurídicos entrando em contato "
                                "por email (railsonsantospb@gmail.com) ou telefone (083981422402).",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.deepOrange,
                              fontSize: 15.0,
                            ),textAlign: TextAlign.justify,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Divider(),
                  new Row(
                    children: <Widget>[
                      new Expanded(
                        child: new Padding(
                          padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                          child: new Text(
                            "Dada a natureza global do Amigo Delivery, não vamos transferir seus dados. "
                                "Por favor, note que, ao enviar suas informações pessoais para nós, "
                                "você consente explicitamente com a transferência das suas informações "
                                "que são necessárias para o pleno funcionamento do aplicativo."
                                " Caso você não concorde com nossa política por favor entrar em contato"
                                " para indicar uma melhor proteção ou ignorar o uso deste aplicativo.",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.deepOrange,
                              fontSize: 15.0,
                            ),textAlign: TextAlign.justify,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Divider(),
                ],
              ),
            )));
  }

  gotoLogin() {
    //controller_0To1.forward(from: 0.0);
    _controller.animateToPage(
      0,
      duration: Duration(milliseconds: 800),
      curve: Curves.bounceOut,
    );
  }

  gotoPrivacity() {
    //controller_0To1.forward(from: 0.0);
    _controller.animateToPage(
      3,
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
//      child: new GestureDetector(
//        onHorizontalDragStart: _onHorizontalDragStart,
//        onHorizontalDragUpdate: _onHorizontalDragUpdate,
//        onHorizontalDragEnd: _onHorizontalDragEnd,
//        behavior: HitTestBehavior.translucent,
//        child: Stack(
//          children: <Widget>[
//            new FractionalTranslation(
//              translation: Offset(-1 - (scrollPercent / (1 / numCards)), 0.0),
//              child: SignupPage(),
//            ),
//            new FractionalTranslation(
//              translation: Offset(0 - (scrollPercent / (1 / numCards)), 0.0),
//              child: HomePage(),
//            ),
//            new FractionalTranslation(
//              translation: Offset(1 - (scrollPercent / (1 / numCards)), 0.0),
//              child: LoginPage(),
//            ),
//          ],
//        ),
//      ),
        child: PageView(
          controller: _controller,
          physics: new AlwaysScrollableScrollPhysics(),
          children: <Widget>[LoginPage(), HomePage(), SignupPage(), Privacity()],
          scrollDirection: Axis.horizontal,
        ));
  }
}
