import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jonasbebidas/home.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:geocoder/geocoder.dart';
import 'package:geolocator/geolocator.dart';

//void main() => runApp(new MyApp());
enum ConfirmAction { CANCEL, ACCEPT }
class MyAppForm extends StatefulWidget {
  @override
  _MyAppFormState createState() => _MyAppFormState();
}

class _MyAppFormState extends State<MyAppForm> {
  final Geolocator geolocator = Geolocator()..forceAndroidLocationManager;
//  Position _currentPosition;
//  String _currentAddress1;
//  String _currentAddress2;
  GlobalKey<FormState> _key = new GlobalKey();
  bool _validate = false;
  String nome, numero, nomeR, email, celular, dc;
  var myemail = new TextEditingController();
  var myname = new TextEditingController();
  var _valores = ["Cartão", "Em Dinheiro"];
  var _itemSelecionado = 'Em Dinheiro';
  var item = true;
  ProgressDialog pr;


//  double lat, long;

  @override
  Widget build(BuildContext context) {
    myemail.value = TextEditingValue(text: "teste@gmail.com");
    myname.value = TextEditingValue(text: "Jonas Bebidas");
    pr = new ProgressDialog(context, showLogs: true);
    pr.style(
        message: "Enviando seu pedido...",
        backgroundColor: Colors.deepOrange,
        messageTextStyle: TextStyle(
            color: Colors.white, fontSize: 18.0),);

    return  Scaffold(
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
                subtitle: new Text("R\$230"),
              ),
            ),

            Expanded(
              flex: 2,
              child: new MaterialButton(onPressed: (){
                  _sendForm();
              },
                child: new Text("Confirmar Pedido",
                  style: TextStyle(color: Colors.white),),
                color: Colors.deepOrange,
              ),
            ),

          ],
        ),
      ),
      );
  }


  void _dropDownItemSelected(String novoItem){
    setState(() {
      this._itemSelecionado = novoItem;
    });
  }



  showAlertDialog2() {

    Widget cancelaButton = FlatButton(
      child: Text("Cancelar"),
      onPressed:  () {
        Navigator.of(context).pop();
      },
    );
    Widget continuaButton = FlatButton(
      child: Text("Continuar"),
      onPressed:  () {
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
          decoration: new InputDecoration(hintText: 'Nome da Rua e o Número da Casa'),
          maxLength: 40,
          validator: _validarNomeRua,
          onSaved: (String val) {
            nomeR = val;
          },
        ),

        new TextFormField(
            decoration: new InputDecoration(hintText: 'Número do Whatsapp'),
            keyboardType: TextInputType.phone,
            maxLength: 10,
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

        Text("Selecione a Forma de Pagamento:",
          style: TextStyle(fontSize: 15.0),
        ),
        DropdownButton<String>(
            items : _valores.map((String dropDownStringItem) {
              return DropdownMenuItem<String>(
                value: dropDownStringItem,
                child: Text(dropDownStringItem),
              );
            }).toList(),
            onChanged: ( String novoItemSelecionado) {
              _dropDownItemSelected(novoItemSelecionado);
              setState(() {
                this._itemSelecionado =  novoItemSelecionado;
                if(_itemSelecionado == "Em Dinheiro"){
                    item = true;
                } else {
                    item = false;
                }
              });
            },
            value: _itemSelecionado
        ),

        Visibility(
          visible: item,
          child: TextFormField(

              decoration: new InputDecoration(hintText: 'Digite o valor do troco'),
              keyboardType: TextInputType.number,
              maxLength: 40,
              validator: _validarValor,
              onSaved: (String val) {
                dc = val;
              }),

        ),

      ],
    );
  }

//  _getCurrentLocation() {
//    geolocator
//        .getCurrentPosition(desiredAccuracy: LocationAccuracy.best)
//        .then((Position position) {
//      setState(() {
//        _currentPosition = position;
//      });
//
//      _getAddressFromLatLng();
//    }).catchError((e) {
//      print(e);
//    });
//  }

//  _getAddressFromLatLng() async {
//    try {
//      Position position = await Geolocator()
//          .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
//      debugPrint('location: ${position.latitude}');
//      final coordinates = new Coordinates(position.latitude, position.longitude);
//      lat = position.latitude;
//      long = position.longitude;
//      var addresses =
//      await Geocoder.local.findAddressesFromCoordinates(coordinates);
//      var first = addresses.first;
//      print("${first.featureName} : ${first.countryName}");
//      address = first.addressLine;
//
//      setState(() {
//        _currentAddress1 = "${first.featureName}";
//        _currentAddress2 = "${first.addressLine}";
//      });
//    } catch (e) {
//      print(e);
//    }
//  }


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
    String patttern = r'(^[0-9]*$)';
    RegExp regExp = new RegExp(patttern);
    if (value.length == 0) {
      return "Informe o número da casa";
    } else if(value.length > 11) {
      return "Digite a quantidade correta de número";
    } else if (!regExp.hasMatch(value)) {
        return "O número da telefone só deve conter dígitos";
    }
      return null;
    }


  String _validarEmail(String value) {
    String pattern = r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regExp = new RegExp(pattern);
    if (value.length == 0) {
      return "Informe o Email";
    } else if(!regExp.hasMatch(value)){
      return "Email inválido";
    }else {
      return null;
    }
  }

  _sendForm() {
    if (_key.currentState.validate()) {
      // Sem erros na validação
      _key.currentState.save();
      print("Nome $nome");
      print("Nome da Rua $nomeR");
      print("Núm $numero");
      print("Ceclular $celular");
      print("Email $email");
      showAlertDialog2();
    } else {
      // erro de validação
      setState(() {
        _validate = true;
      });
    }
  }
}

class SecondScreen extends StatefulWidget {
  @override
  _SecondScreenState createState() => _SecondScreenState();
}

class _SecondScreenState extends State<SecondScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Center(
                child: Text("AGRADECEMOS PELA COMPRA!",
                  style: TextStyle(fontWeight: FontWeight.bold),),

              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Center(
                child: Text("(INÍCIO)",
                  style: TextStyle(fontWeight: FontWeight.bold),),

              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Center(
                child: Icon(Icons.arrow_downward, size: 70,)

              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Center(
                child: IconButton(
                  iconSize: 74.0,
                  icon: Icon(Icons.check_circle, color: Colors.green,),
                  onPressed: (){
                    Navigator.pushAndRemoveUntil(
                      context,
                      CupertinoPageRoute(builder: (context) => HomePage1()),
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
                child: Text("SEU PEDIDO FOI ENVIADO COM SUCESSO!",
                style: TextStyle(fontWeight: FontWeight.bold),),

              ),
            ],
          ),


        ],
      )

    );
  }
}