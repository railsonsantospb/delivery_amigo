import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:deliveryadmin/src/api/api_service_cat.dart';
import 'package:deliveryadmin/src/api/api_service_company.dart';
import 'package:deliveryadmin/src/model/company.dart';
import 'package:deliveryadmin/src/ui/home/login_home.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:io';
import 'dart:async';
import 'dart:convert';
import 'package:image_picker/image_picker.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class FormAddCompany extends StatefulWidget {
  String cpf;
  String id;

  FormAddCompany({this.cpf});

  @override
  _FormAddCompanyState createState() => _FormAddCompanyState();
}

class _FormAddCompanyState extends State<FormAddCompany> {
  final GlobalKey<ScaffoldState> _scaffoldState3 = GlobalKey<ScaffoldState>();
  bool _isLoading = false;
  int selected = 0;
  ApiServiceCop _apiServiceCop;
  ApiServiceCat _apiServiceCat;
  ProgressDialog pr;
  ProgressDialog pr2;

  bool _isFieldNameValid;
  bool _isFieldPriceValid;
  bool _isFieldStateValid;
  bool _isFieldImageValid;
  bool _isFieldCatIdValid;
  bool _isFieldPhoneValid;
  bool _isFieldActiveValid;
  bool _isFieldOwnerValid;
  bool _isFieldAddressValid;
  bool _isFieldCpf_CnpjValid;
  bool _isFieldPasswordValid;
  bool _isFieldCityValid;
  bool _isFieldHourValid;
  bool _isFieldWeekValid;
  bool _isFieldStatusValid;

  final Geolocator geolocator = Geolocator()..forceAndroidLocationManager;
  Position _currentPosition;
  String locale;
  double lat, long;

  TextEditingController _controllerName = TextEditingController();
  TextEditingController _controllerOwner = TextEditingController();
  TextEditingController _controllerAddress = TextEditingController();
  TextEditingController _controllerCpf_Cnpj =
      new MaskedTextController(mask: '000.000.000-00');
  TextEditingController _controllerPhone =
      new MaskedTextController(mask: '(00) 00000-0000');
  TextEditingController _controllerHour =
      new MaskedTextController(mask: '00h00 até 00h00');
  TextEditingController _controllerWeek =
      new MaskedTextController(mask: 'AAA. a AAA.');
  TextEditingController _controllerPassword = TextEditingController();
  TextEditingController _controllerCity = TextEditingController();
  TextEditingController _controllerStatus = TextEditingController();

  String _mySelection2;
  String _mySelection3;
  String value;
  Future<File> file;
  String status = '';
  String base64Image;
  File tmpFile;
  String errMessage = 'Error Uploading Image';
  Future<List<Company>> _c;

  chooseImage() {
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
                    file = ImagePicker.pickImage(source: ImageSource.gallery);
                  });
                  Navigator.pop(context);
                },
              ),
              FlatButton(
                child: Text("CAMERA"),
                onPressed: () {
                  setState(() {
                    file = ImagePicker.pickImage(source: ImageSource.camera);
                  });
                  Navigator.pop(context);
                },
              )
            ],
          );
        });
  }

  List state = [
    {'state': 'Restaurante ou Lanchonete'},
    // {'state': 'SuperMercado'},
    {'state': 'Loja ou Deposito'},
  ];

  List valueActive = [
    {'active': 'Habilitada'},
    {'active': 'Desabilitada'},
  ];

  List valueStatus = [
    {'status': 'Disponível'},
    {'status': 'Indisponível'},
  ];

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

  Future<List<Company>> retornarP() async {
    setState(() {
      _c = _apiServiceCop.getCopCpf(widget.cpf);
    });
  }

  @override
  void initState() {
    _apiServiceCop = ApiServiceCop();
    _apiServiceCat = ApiServiceCat();
    _c = _apiServiceCop.getCopCpf(widget.cpf);

    super.initState();
    setState(() => _isFieldCatIdValid = widget.cpf == null ? true : true);
  }

  @override
  Widget build(BuildContext context) {
    pr = new ProgressDialog(context, showLogs: true);
    pr.style(
      message: "Atualizando...",
      backgroundColor: Colors.deepOrange,
      messageTextStyle: TextStyle(color: Colors.white, fontSize: 18.0),
    );

    return Scaffold(
      key: _scaffoldState3,
      resizeToAvoidBottomPadding: false,
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: FutureBuilder(
          future: _c,
          builder:
              (BuildContext context, AsyncSnapshot<List<Company>> snapshot) {
            List<Company> cops = snapshot.data;

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
              if (cops == null) {
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
              } else if (cops.isNotEmpty) {
                if (widget.cpf != null) {
                  _isFieldNameValid = true;
                  _controllerName.text = cops[0].name;

                  _isFieldOwnerValid = true;
                  _controllerOwner.text = cops[0].owner;

                  _isFieldAddressValid = true;
                  _controllerAddress.text = cops[0].address;

                  _isFieldCpf_CnpjValid = true;
                  _controllerCpf_Cnpj.text = cops[0].cpf_cnpj;

                  _isFieldHourValid = true;
                  _controllerHour.text = cops[0].hour;

                  _isFieldWeekValid = true;
                  _controllerWeek.text = cops[0].week;

                  _isFieldPhoneValid = true;
                  _controllerPhone.text = cops[0].phone;

                  _isFieldPasswordValid = true;
                  _controllerPassword.text = cops[0].password;

                  _isFieldCityValid = true;
                  _controllerCity.text = cops[0].city;

                  _isFieldStatusValid = true;
                  _controllerStatus.text = cops[0].status;

                  _isFieldStateValid = true;

                  _isFieldImageValid = true;

                  _isFieldCatIdValid = true;
                }

                return SingleChildScrollView(
                  padding: EdgeInsets.all(15.0),
                  child: Column(
                    children: [
                      _showImage(cops[0]),
                      FlutterRatingBar(
                        initialRating: double.parse(cops[0].rating),
                        fillColor: Colors.amber,
                        borderColor: Colors.amber.withAlpha(50),
                        allowHalfRating: true,
                      ),
                      new TextField(
                        controller: _controllerName,
                        decoration: InputDecoration(
                          labelText: "Nome da Empresa",
                          errorText:
                              _isFieldNameValid == null || _isFieldNameValid
                                  ? null
                                  : "Nome da empresa é obrigatório",
                        ),
                        onChanged: (value) {
                          bool isFieldValid = value.trim().isNotEmpty;
                          if (isFieldValid != _isFieldNameValid) {
                            if (this.mounted) {
                              setState(() => _isFieldNameValid = isFieldValid);
                            }
                          }
                        },
                      ),
                      new TextField(
                        controller: _controllerOwner,
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                          labelText: "Nome do Proprietário",
                          errorText:
                              _isFieldOwnerValid == null || _isFieldOwnerValid
                                  ? null
                                  : "Nome do proprietário é obrigatório",
                        ),
                        onChanged: (value) {
                          bool isFieldValid = value.trim().isNotEmpty;
                          if (isFieldValid != _isFieldOwnerValid) {
                            if (this.mounted) {
                              setState(() => _isFieldOwnerValid = isFieldValid);
                            }
                          }
                        },
                      ),
                      new TextField(
                        controller: _controllerHour,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          labelText: "Horários Disponíveis",
                          errorText:
                              _isFieldHourValid == null || _isFieldHourValid
                                  ? null
                                  : "Os horários são obrigatórios",
                        ),
                        onChanged: (value) {
                          bool isFieldValid = value.trim().isNotEmpty;
                          if (isFieldValid != _isFieldHourValid) {
                            if (this.mounted) {
                              setState(() => _isFieldHourValid = isFieldValid);
                            }
                          }
                        },
                      ),
                      new TextField(
                        controller: _controllerWeek,
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                          labelText: "Dias Disponíveis",
                          errorText:
                              _isFieldWeekValid == null || _isFieldWeekValid
                                  ? null
                                  : "Os dias são obrigatórios",
                        ),
                        onChanged: (value) {
                          bool isFieldValid = value.trim().isNotEmpty;
                          if (isFieldValid != _isFieldWeekValid) {
                            if (this.mounted) {
                              setState(() => _isFieldWeekValid = isFieldValid);
                            }
                          }
                        },
                      ),
                      new TextField(
                        enabled: false,
                        controller: _controllerCpf_Cnpj,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          labelText: "CPF",
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
                      new TextField(
                        enabled: false,
                        controller: _controllerCity,
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                          labelText: "Cidade",
                          errorText:
                              _isFieldCityValid == null || _isFieldCityValid
                                  ? null
                                  : "O Cidade é obrigatória",
                        ),
                        onChanged: (value) {
                          bool isFieldValid = value.trim().isNotEmpty;
                          if (isFieldValid != _isFieldCityValid) {
                            if (this.mounted) {
                              setState(() => _isFieldCityValid = isFieldValid);
                            }
                          }
                        },
                      ),
                      new TextField(
                        obscureText: true,
                        controller: _controllerPassword,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          labelText: "Senha",
                        ),
                        onChanged: (value) {
                          bool isFieldValid = value.trim().isNotEmpty;
                          if (isFieldValid != _isFieldPasswordValid) {
                            if (this.mounted) {
                              setState(
                                  () => _isFieldPasswordValid = isFieldValid);
                            }
                          }
                        },
                      ),
                      new TextField(
                        controller: _controllerPhone,
                        keyboardType: TextInputType.phone,
                        decoration: InputDecoration(
                          labelText:
                              "Telefone da Empresa. Ex: (83) 93232-23432",
                          errorText:
                              _isFieldPhoneValid == null || _isFieldPhoneValid
                                  ? null
                                  : "O telefone é obrigatória",
                        ),
                        onChanged: (value) {
                          bool isFieldValid = value.trim().isNotEmpty;
                          if (isFieldValid != _isFieldPhoneValid) {
                            if (this.mounted) {
                              setState(() => _isFieldPhoneValid = isFieldValid);
                            }
                          }
                        },
                      ),
                      new TextField(
                        controller: _controllerAddress,
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                          labelText: "Endereço da Empresa: Rua e Número",
                          errorText: _isFieldAddressValid == null ||
                                  _isFieldAddressValid
                              ? null
                              : "O endereço é obrigatória",
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

                      Center(
                        child: new DropdownButtonFormField(
                          hint: cops != null
                              ? Text(cops[0].status)
                              : Text('Status'),
                          items: valueStatus.map((item) {
                            return new DropdownMenuItem(
                              child: new Text(item['status']),
                              value: item['status'].toString(),
                            );
                          }).toList(),
                          onChanged: (newVal) {
                            if (this.mounted) {
                              setState(() {
                                 print(newVal);
                                _mySelection3 = newVal;
                                setState(() => _isFieldStatusValid =
                                    _mySelection3.isNotEmpty);
                              });
                            }
                          },
                          value: _mySelection3,
                        ),
                      ),
                      Divider(),

                      SizedBox(
                        width: double.infinity, // match_parent
                        child: RaisedButton(
                          color: Colors.deepOrange,
                          child: Text(
                            "Atualizar Dados".toUpperCase(),
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                          onPressed: () {
                            String cpf_cnpj =
                                _controllerCpf_Cnpj.text.toString();

                            if (_isFieldNameValid == null ||
                                _isFieldStateValid == null ||
                                _isFieldCatIdValid == null ||
                                _isFieldOwnerValid == null ||
                                _isFieldAddressValid == null ||
                                _isFieldPasswordValid == null ||
                                base64Image == null ||
                                !_isFieldNameValid ||
                                !_isFieldStateValid ||
                                !_isFieldImageValid ||
                                !_isFieldCatIdValid ||
                                !_isFieldPasswordValid ||
                                !_isFieldOwnerValid ||
                                !_isFieldAddressValid) {
                              _scaffoldState3.currentState.showSnackBar(
                                SnackBar(
                                  backgroundColor: Colors.blue,
                                  content: Text(
                                      "Por Favor Preencha Todos os Campos"),
                                ),
                              );
                              return;
                            }
                            print(_mySelection3);
                            String name = _controllerName.text.toString();
                            String owner = _controllerOwner.text.toString();
                            String address = _controllerAddress.text.toString();
                            String phone = _controllerPhone.text.toString();
                            String password =
                                _controllerPassword.text.toString();
                            String city = _controllerCity.text.toString();
                            String week = _controllerWeek.text.toString();
                            String hour = _controllerHour.text.toString();

                            Company cop = Company(
                                id: cops[0].id,
                                name: name,
                                city: city,
                                image: base64Image,
                                category: _mySelection2 == null
                                    ? cops[0].category
                                    : _mySelection2,
                                cpf_cnpj: cpf_cnpj,
                                phone: phone,
                                owner: owner,
                                address: address,
                                password: password,
                                lat: cops[0].lat,
                                lon: cops[0].lon,
                                hour: hour,
                                week: week,
                            status: _mySelection3 == null
                                ? cops[0].status
                                : _mySelection3,);

                            pr.show();

                            Future.delayed(const Duration(seconds: 2), () {
                              pr.hide().whenComplete(() {
                                _apiServiceCop.updateCop(cop).then((isSuccess) {
                                  if (isSuccess) {
                                    setState(() {
                                      retornarP();
                                    });

                                    _scaffoldState3.currentState
                                        .showSnackBar(SnackBar(
                                      backgroundColor: Colors.green,
                                      content:
                                          Text("Dados Ataulizados com Sucesso"),
                                    ));
                                  } else {
                                    _scaffoldState3.currentState
                                        .showSnackBar(SnackBar(
                                      backgroundColor: Colors.red,
                                      content:
                                          Text("Falha ao Atualizar os Dados"),
                                    ));
                                  }
                                });
                              });
                            });
                          },
                        ),
                      ),
                      Divider(),
                      SizedBox(
                        width: double.infinity, // match_parent
                        child: RaisedButton(
                          color: Colors.deepOrange,
                          child: Text(
                            "Excluir Dados".toUpperCase(),
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                          onPressed: () {
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
                                    String cpf = cops[0].cpf_cnpj;
                                    _apiServiceCop
                                        .deleteCop(cops[0].id)
                                        .then((isSuccess) {
                                      if (isSuccess) {
                                        _apiServiceCat
                                            .deleteCategoryCpf(cpf)
                                            .then((isSuccess) {
                                          if (isSuccess) {
                                            Navigator.pushAndRemoveUntil(
                                              context,
                                              CupertinoPageRoute(
                                                  builder: (context) =>
                                                      LoginScreen3()),
                                              (Route<dynamic> route) => false,
                                            );
                                          } else {
                                            Scaffold.of(this.context)
                                                .showSnackBar(SnackBar(
                                                    backgroundColor: Colors.red,
                                                    content: Text(
                                                        "Falha ao Excluir ou Verifique sua Conexão")));
                                          }
                                        });
                                      } else {
                                        Scaffold.of(this.context).showSnackBar(
                                            SnackBar(
                                                backgroundColor: Colors.red,
                                                content: Text(
                                                    "Falha ao Excluir ou Verifique sua Conexão")));
                                      }
                                    });
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
                          },
                        ),
                      ),
                      Divider(),
//                      SizedBox(
//                        width: double.infinity, // match_parent
//                        child: RaisedButton(
//                          color: Colors.deepOrange,
//                          child: Text(
//                            "Atualizar Localização".toUpperCase(),
//                            style: TextStyle(
//                              color: Colors.white,
//                            ),
//                          ),
//                          onPressed: () {
//                            _getCurrentLocation();
//                            pr.show();
//                            Future.delayed(Duration(seconds: 4)).then((value) {
//                              pr.hide().whenComplete(() {
//                                if (_currentPosition == null) {
//                                  Widget okButton = FlatButton(
//                                    child: Text("OK"),
//                                    onPressed: () {
//                                      Navigator.pop(context);
//                                    },
//                                  );
//                                  AlertDialog alerta = AlertDialog(
//                                    title: Text(
//                                      "Atenção",
//                                      style: TextStyle(color: Colors.red),
//                                    ),
//                                    content: Text(
//                                      "POR FAVOR ATIVE SEU GPS PARA CONCLUIR!",
//                                      style: TextStyle(
//                                          color: Colors.blue,
//                                          fontWeight: FontWeight.bold),
//                                    ),
//                                    actions: [
//                                      okButton,
//                                    ],
//                                  );
//                                  showDialog(
//                                    context: context,
//                                    builder: (BuildContext context) {
//                                      return alerta;
//                                    },
//                                  );
//                                } else {
//                                  if (this.mounted) {
//                                    setState(() {
//                                      cops[0].lat =
//                                          _currentPosition.latitude.toString();
//                                      cops[0].lon =
//                                          _currentPosition.longitude.toString();
//                                      _controllerCity.text = locale;
//                                      print(locale);
//                                    });
//                                  }
//
//                                  Widget okButton = FlatButton(
//                                    child: Text("OK"),
//                                    onPressed: () {
//                                      Navigator.pop(context);
//                                    },
//                                  );
//                                  AlertDialog alerta = AlertDialog(
//                                    title: Text(
//                                      "Atenção",
//                                      style: TextStyle(color: Colors.red),
//                                    ),
//                                    content: Text(
//                                      "SUA LOCALIZAÇÃO FOI ATUALIZADA COM SUCESSO!",
//                                      style: TextStyle(
//                                          color: Colors.blue,
//                                          fontWeight: FontWeight.bold),
//                                    ),
//                                    actions: [
//                                      okButton,
//                                    ],
//                                  );
//                                  showDialog(
//                                    context: context,
//                                    builder: (BuildContext context) {
//                                      return alerta;
//                                    },
//                                  );
//                                }
//                              });
//                            });
//                          },
//                        ),
//                      ),
                    ],
                  ),
                );
              } else {
                return Column(
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
                );
              }
            } else {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
          },
        ),
      ),
    );
  }

  Widget _showImage(Company cops) {
    return FutureBuilder<File>(
      future: file,
      builder: (BuildContext context, AsyncSnapshot<File> snapshot) {
        if (snapshot.connectionState == ConnectionState.done &&
            null != snapshot.data) {
          tmpFile = snapshot.data;
          base64Image = base64Encode(snapshot.data.readAsBytesSync());
          _isFieldImageValid = true;

          return Wrap(
            children: <Widget>[
              GestureDetector(
                onTap: chooseImage,
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
        } else if (null != snapshot.error) {
          return cops != null
              ? Wrap(
                  children: <Widget>[
                    GestureDetector(
                      onTap: chooseImage,
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            ClipRRect(
                              borderRadius: BorderRadius.circular(150),
                              child: Image.memory(
                                base64Decode(cops.image),
                                cacheHeight: 250,
                                cacheWidth: 250,
                              ),
                            ),
                          ]),
                    ),
                  ],
                )
              : GestureDetector(
                  onTap: chooseImage,
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
          if (cops != null) {
            _isFieldImageValid = true;
            base64Image = cops.image;
          }
          return cops != null
              ? Wrap(
                  children: <Widget>[
                    GestureDetector(
                      onTap: chooseImage,
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            ClipRRect(
                              borderRadius: BorderRadius.circular(150),
                              child: Image.memory(
                                base64Decode(cops.image),
                                cacheHeight: 250,
                                cacheWidth: 250,
                              ),
                            ),
                          ]),
                    ),
                  ],
                )
              : GestureDetector(
                  onTap: chooseImage,
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
