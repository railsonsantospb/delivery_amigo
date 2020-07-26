import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:amigodelivery/api/api_service_company.dart';
import 'package:amigodelivery/api/api_service_rx.dart';
import 'package:amigodelivery/home.dart';
import 'package:amigodelivery/model/product_cart.dart';
import 'package:amigodelivery/model/requestx.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';

final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

class MyAppForm extends StatefulWidget {
  final email;
  final name;
  List<ProductCart> cart;
  final prices;
  final id_cop;
  final cpf;

  MyAppForm(
      {this.email, this.name, this.cart, this.prices, this.id_cop, this.cpf});

  @override
  _MyAppFormState createState() => _MyAppFormState();
}

class _MyAppFormState extends State<MyAppForm> {
  final Geolocator geolocator = Geolocator()..forceAndroidLocationManager;

  GlobalKey<FormState> _key = new GlobalKey();
  bool _validate = false;
  String nome, numero, nomeR, email, celular, dc = "";
  var myemail = new TextEditingController();
  var myname = new TextEditingController();
  var mynumber = new MaskedTextController(mask: '(00) 00000-0000');
  var myaddress = new TextEditingController();
  var myobs = new TextEditingController();
  var _valores = ["Cartão", "Em Dinheiro com Troco", "Em Dinheiro sem Troco"];
  var _itemSelecionado = 'Em Dinheiro com Troco';
  var item = true;
  ProgressDialog pr;
  Position _currentPosition;
  double lat, long;
  String locale;
  ApiServiceRX apiService;

  _getCurrentLocation() async {
    try {
      Position position = await Geolocator()
          .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
      List<Placemark> placemark = await Geolocator()
          .placemarkFromCoordinates(position.latitude, position.longitude);

      setState(() {
        _currentPosition = position;
        locale = placemark.first.subLocality.toString();
      });
    } catch (e) {}
  }

  saveDatas(String address, String number) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    prefs.setString('address', address);
    prefs.setString('number', number);
  }

  getDatas() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //Return String
    if (prefs.getString('address') != null && this.mounted) {
      myaddress.text = prefs.getString('address');
    }

    if (prefs.getString('number') != null && this.mounted) {
      mynumber.text = prefs.getString('number');
    }
  }

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

  @override
  void initState() {
    _getCurrentLocation();
    getDatas();
    apiService = ApiServiceRX();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _getCurrentLocation();
    pr = new ProgressDialog(context, showLogs: true);
    pr.style(
      message: "Enviando seu pedido...",
      backgroundColor: Colors.deepOrange,
      messageTextStyle: TextStyle(color: Colors.white, fontSize: 18.0),
    );
    myemail.value = TextEditingValue(text: widget.email);
    myname.value = TextEditingValue(text: widget.name);

    return Scaffold(
      appBar: new AppBar(
        backgroundColor: Colors.deepOrange,
        title: new Text('Formulário de Validação'),
      ),
      body: new SingleChildScrollView(
        child: new Container(
          margin: new EdgeInsets.all(15.0),
          child: new Form(
            key: _key,
            autovalidate: _validate,
            child: _formUI(),
          ),
        ),
      ),
      bottomNavigationBar: new Container(
        color: Colors.white,
        child: Row(
          children: <Widget>[
            Expanded(
              child: ListTile(
                title: new Text("Total: "),
                subtitle: new Text(
                  "R\$ ${widget.prices}",
                  style: TextStyle(
                      fontSize: 18.0,
                      color: Colors.deepOrange,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: new MaterialButton(
                onPressed: () {
                  if (_key.currentState.validate()) {
                    pr.show();
                    Future.delayed(const Duration(seconds: 4), () {
                      pr.hide().whenComplete(() {
                        if (_currentPosition == null) {
                          showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  title: Text("Aviso!"),
                                  content: Text(
                                      "POR FAVOR ATIVE SEU GPS PARA CONCLUIR O CADASTRO OU TENTE NOVAMENTE!"),
                                  actions: <Widget>[
                                    FlatButton(
                                      child: Text("OK"),
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                    )
                                  ],
                                );
                              });
                        } else {
                          String carts = '';
                          for (final c in widget.cart) {
                            carts += c.name +
                                "=" +
                                c.qtd.toString() +
                                "=" +
                                c.mark +
                                "=" +
                                c.price +
                                "=" +
                                c.info +
                                "#";
                          }

                          RequestX rx = RequestX(
                              client: widget.name,
                              city: locale,
                              address: myaddress.text.toString(),
                              email: myemail.text.toString(),
                              phone: mynumber.text.toString(),
                              active: 1,
                              id_cop: widget.id_cop.toString(),
                              price_full: widget.prices.toString(),
                              lat: _currentPosition.latitude.toString(),
                              lon: _currentPosition.longitude.toString(),
                              products: carts,
                              pay: _itemSelecionado + " (de R\$" + dc + ")",
                              obs: myobs.text.toString());

                          apiService.createRequestX(rx).then((isSuccess) {
                            if (isSuccess) {
                              saveDatas(myaddress.text.toString(),
                                  mynumber.text.toString());
                              Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => SecondScreen(
                                          name: widget.name,
                                          email: widget.email,
                                          cpf: widget.cpf,
                                          id_cop: widget.id_cop,
                                        )),
                                (Route<dynamic> route) => false,
                              );
                            } else {
                              scaffoldKey.currentState.showSnackBar(SnackBar(
                                  backgroundColor: Colors.blue,
                                  content: Text("Falha ao Enviar os Dados")));
                            }
                          });
                        }
                      });
                    });
                  } else {
                    // erro de validação
                    setState(() {
                      _validate = true;
                    });
                  }
                },

                //exibe o diálogo

                child: new Text(
                  "Confirmar Pedido",
                  style: TextStyle(color: Colors.white),
                ),
                color: Colors.deepOrange,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _dropDownItemSelected(String novoItem) {
    setState(() {
      this._itemSelecionado = novoItem;
    });
  }

  showAlertDialog2() {
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
        Future.delayed(Duration(seconds: 3)).then((value) {
          pr.hide().whenComplete(() {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => SecondScreen()),
              (Route<dynamic> route) => false,
            );
          });
        });
      },
    );

    //configura o AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Confirmar pedido!"),
      content: Text("Deseja continuar com a compra?"),
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
  }

  Widget _formUI() {
    return new Column(
      children: <Widget>[
        new TextFormField(
          controller: myname,
          enabled: false,
          decoration: new InputDecoration(hintText: 'Seu Nome'),
          maxLength: 40,
          validator: _validarNome,
          onSaved: (String val) {
            nome = val;
          },
        ),
        new TextFormField(
          controller: myaddress,
          decoration:
              new InputDecoration(hintText: 'Nome da Rua e o Número da Casa'),
          maxLength: 40,
          validator: _validarNomeRua,
          onSaved: (String val) {
            nomeR = val;
          },
        ),
        new TextFormField(
            controller: mynumber,
            decoration: new InputDecoration(hintText: 'Número do Whatsapp'),
            keyboardType: TextInputType.number,
            validator: _validarCelular,
            onSaved: (String val) {
              celular = val;
            }),
        new TextFormField(
            controller: myemail,
            enabled: false,
            decoration: new InputDecoration(hintText: 'Email'),
            keyboardType: TextInputType.emailAddress,
            maxLength: 40,
            validator: _validarEmail,
            onSaved: (String val) {
              email = val;
            }),
        new TextFormField(
            controller: myobs,
            decoration: new InputDecoration(
                hintText:
                    'Deixe Alguma Observação. Ex: Quente ou Frio, Gelado ou Natural'),
            keyboardType: TextInputType.multiline,
            maxLines: 4,
            maxLength: 100,
            validator: _validarObs,
            onSaved: (String val) {
              email = val;
            }),
        Text(
          "Selecione a Forma de Pagamento:",
          style: TextStyle(fontSize: 15.0),
        ),
        DropdownButton<String>(
            items: _valores.map((String dropDownStringItem) {
              return DropdownMenuItem<String>(
                value: dropDownStringItem,
                child: Text(dropDownStringItem),
              );
            }).toList(),
            onChanged: (String novoItemSelecionado) {
              _dropDownItemSelected(novoItemSelecionado);
              this._itemSelecionado = novoItemSelecionado;
              setState(() {
                if (_itemSelecionado == "Em Dinheiro com Troco") {
                  item = true;
                } else if (_itemSelecionado == "Cartão" ||
                    _itemSelecionado == "Em Dinheiro sem Troco") {
                  item = false;
                }
              });
            },
            value: _itemSelecionado),
        Visibility(
          visible: item,
          child: TextFormField(
              decoration:
                  new InputDecoration(hintText: 'Digite o valor do troco'),
              keyboardType: TextInputType.number,
              validator: _validarValor,
              onChanged: (String val) {
                setState(() {
                  dc = val;
                });
              }),
        ),
      ],
    );
  }

  String _validarNome(String value) {
    String patttern = r'(^[a-zA-Z ]*$)';
    RegExp regExp = new RegExp(patttern);
    if (value.length == 0) {
      return "Informe o seu nome";
    } else if (!regExp.hasMatch(value)) {
      return "O nome deve conter caracteres de a-z ou A-Z";
    }
    return null;
  }

  String _validarNomeRua(String value) {
    if (value.length == 0) {
      return "Informe o nome da rua e o número";
    }
    return null;
  }

  String _validarObs(String value) {
    if (value.length == 0) {
      return "Deixe alguma observação";
    }
    return null;
  }

  String _validarValor(String value) {
    String patttern = r'(^[0-9]*$)';
    RegExp regExp = new RegExp(patttern);
    if (value.length == 0) {
      return "Informe o valor do troco";
    } else if (!regExp.hasMatch(value)) {
      return "O valor do troco só deve conter dígitos";
    }
    return null;
  }

  String _validarCelular(String value) {
    String patttern = r'(^[0-9]+[(]+[)]*$)';
    RegExp regExp = new RegExp(patttern);
    if (value.length == 0) {
      return "Informe o número do celular";
    }
    return null;
  }

  String _validarEmail(String value) {
    String pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regExp = new RegExp(pattern);
    if (value.length == 0) {
      return "Informe o Email";
    } else if (!regExp.hasMatch(value)) {
      return "Email inválido";
    } else {
      return null;
    }
  }
}

class SecondScreen extends StatefulWidget {
  final email;
  final name;
  final id_cop;
  final cpf;

  SecondScreen({
    this.email,
    this.name,
    this.id_cop,
    this.cpf,
  });

  @override
  _SecondScreenState createState() => _SecondScreenState();
}

class _SecondScreenState extends State<SecondScreen> {
  ApiServiceCop apiServiceCop;
  String rat = "0";

  String locale;

  @override
  void initState() {
    apiServiceCop = ApiServiceCop();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: scaffoldKey,
        backgroundColor: Colors.white,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Center(
                  child: Text(
                    "AGRADECEMOS PELA COMPRA!",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Center(
                  child: Text(
                    "(INÍCIO)",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Center(
                    child: Icon(
                  Icons.arrow_downward,
                  size: 70,
                )),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Center(
                  child: IconButton(
                    iconSize: 74.0,
                    icon: Icon(
                      Icons.check_circle,
                      color: Colors.green,
                    ),
                    onPressed: () {
                      Navigator.pushAndRemoveUntil(
                        context,
                        CupertinoPageRoute(
                            builder: (context) => HomePage1(
                                  cpf: widget.cpf,
                                  email: widget.email,
                                  id: widget.id_cop,
                                  name: widget.name,
                                )),
                        (Route<dynamic> route) => false,
                      );
                    },
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Center(
                  child: Text(
                    "SEU PEDIDO FOI ENVIADO COM SUCESSO!",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: new Text(
                    "AVALIE NOSSA EMPRESA",
                    style: TextStyle(color: Colors.deepOrange),
                  ),
                ),
              ],
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                FlutterRatingBar(
                  itemSize: 30,
                  fillColor: Colors.deepOrange,
                  borderColor: Colors.deepOrange.withAlpha(50),
                  allowHalfRating: true,
                  onRatingUpdate: (rating) {
                    setState(() {
                      rat = rating.toString();
                    });
                  },
                ),
              ],
            ),
            Divider(),
            Row(children: <Widget>[
              // ===== the send button
              Expanded(
                child: MaterialButton(
                  onPressed: () {
                    if (double.parse(rat) > 0.0) {
                      apiServiceCop
                          .updateCopRating(widget.id_cop, rat)
                          .then((value) {
                        if (value) {
                          showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  title: Text("Muito bem!"),
                                  content: Text("Obrigado pela sua Avaliação!"),
                                  actions: <Widget>[
                                    FlatButton(
                                      child: Text("OK"),
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                    )
                                  ],
                                );
                              });
                          Navigator.pushAndRemoveUntil(
                            context,
                            CupertinoPageRoute(
                                builder: (context) => HomePage1(
                                      cpf: widget.cpf,
                                      email: widget.email,
                                      id: widget.id_cop,
                                      name: widget.name,
                                    )),
                            (Route<dynamic> route) => false,
                          );
                        } else {
                          scaffoldKey.currentState.showSnackBar(SnackBar(
                              backgroundColor: Colors.red,
                              content: Text("Falha ao Atualizar Avaliação")));
                        }
                      });
                    } else {
                      showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: Text("Atenção!"),
                              content: Text(
                                  "Arraste os dedos sobre as estrelas para avaliar!"),
                              actions: <Widget>[
                                FlatButton(
                                  child: Text("OK"),
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                )
                              ],
                            );
                          });
                    }
                  },
                  color: Colors.deepOrange,
                  textColor: Colors.white,
                  child: new Text("AVALIAR"),
                ),
              ),
            ]),
          ],
        ));
  }
}
