import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_crud_api_sample_app/src/api/api_service_company.dart';
import 'package:flutter_crud_api_sample_app/src/model/company.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:geolocator/geolocator.dart';
import 'package:cpfcnpj/cpfcnpj.dart';
import 'dart:io';
import 'dart:async';
import 'dart:convert';
import 'package:image_picker/image_picker.dart';
import 'package:progress_dialog/progress_dialog.dart';

final GlobalKey<ScaffoldState> _scaffoldState = GlobalKey<ScaffoldState>();

class FormAddCompany extends StatefulWidget {
  Company cop;
  String id;

  FormAddCompany({this.cop});

  @override
  _FormAddCompanyState createState() => _FormAddCompanyState();
}

class _FormAddCompanyState extends State<FormAddCompany> {
  bool _isLoading = false;
  int selected = 0;
  ApiServiceCop _apiServiceCop = ApiServiceCop();
  ProgressDialog pr;

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
  TextEditingController _controllerPassword = TextEditingController();

  String _mySelection2;
  String value;
  Future<File> file;
  String status = '';
  String base64Image;
  File tmpFile;
  String errMessage = 'Error Uploading Image';
  ApiServiceCop apiService;

  chooseImage() {
    if (this.mounted) {
      setState(() {
        file = ImagePicker.pickImage(source: ImageSource.gallery);
      });
    }
  }

  List state = [
    {'state': 'Lanches/Restaurantes'},
    {'state': 'Bebidas'},
    {'state': 'SuperMercado'},
    {'state': 'Lojas'},
    {'state': 'Depósitos'},
  ];

  List valueActive = [
    {'active': 'Habilitada'},
    {'active': 'Desabilitada'},
  ];

  _getCurrentLocation() async {
    Position position = await Geolocator()
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);

    setState(() {
      _currentPosition = position;
    });
  }

  @override
  void initState() {
    apiService = ApiServiceCop();
    if (widget.cop != null) {
      _isFieldNameValid = true;
      _controllerName.text = widget.cop.name;

      _isFieldOwnerValid = true;
      _controllerOwner.text = widget.cop.owner;

      _isFieldAddressValid = true;
      _controllerAddress.text = widget.cop.address;

      _isFieldCpf_CnpjValid = true;
      _controllerCpf_Cnpj.text = widget.cop.cpf_cnpj;

      _isFieldPhoneValid = true;
      _controllerPhone.text = widget.cop.phone;

      _isFieldPasswordValid = true;
      _controllerPassword.text = widget.cop.password;

      _isFieldStateValid = true;

      _isFieldImageValid = true;

      _isFieldCatIdValid = true;
    }
    super.initState();
    setState(() => _isFieldCatIdValid = widget.cop == null ? true : true);
  }

  @override
  Widget build(BuildContext context) {
    pr = new ProgressDialog(context, showLogs: true);
    pr.style(
      message: "Enviando seu pedido...",
      backgroundColor: Colors.deepOrange,
      messageTextStyle: TextStyle(color: Colors.white, fontSize: 18.0),
    );

    return Scaffold(
      key: _scaffoldState,
      resizeToAvoidBottomPadding: false,
      resizeToAvoidBottomInset: false,
      body: SingleChildScrollView(
        padding: EdgeInsets.all(15.0),
        child: Column(
          children: [
            _showImage(),
            new TextField(
              controller: _controllerName,
              decoration: InputDecoration(
                labelText: "Nome da Empresa",
                errorText: _isFieldNameValid == null || _isFieldNameValid
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
                errorText: _isFieldOwnerValid == null || _isFieldOwnerValid
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
              enabled: false,
              controller: _controllerCpf_Cnpj,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: "CPF",
                errorText:
                    _isFieldCpf_CnpjValid == null || _isFieldCpf_CnpjValid
                        ? null
                        : "O CPF é obrigatório",
              ),
              onChanged: (value) {
                bool isFieldValid = value.trim().isNotEmpty;
                if (isFieldValid != _isFieldCpf_CnpjValid) {
                  if (this.mounted) {
                    setState(() => _isFieldCpf_CnpjValid = isFieldValid);
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
                    setState(() => _isFieldPasswordValid = isFieldValid);
                  }
                }
              },
            ),
            new TextField(
              controller: _controllerPhone,
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(
                labelText: "Telefone da Empresa. Ex: (83) 93232-23432",
                errorText: _isFieldPhoneValid == null || _isFieldPhoneValid
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
                errorText: _isFieldAddressValid == null || _isFieldAddressValid
                    ? null
                    : "O endereço é obrigatória",
              ),
              onChanged: (value) {
                bool isFieldValid = value.trim().isNotEmpty;
                if (isFieldValid != _isFieldAddressValid) {
                  if (this.mounted) {
                    setState(() => _isFieldAddressValid = isFieldValid);
                  }
                }
              },
            ),
            Center(
              child: new DropdownButtonFormField(
                hint: widget.cop != null
                    ? Text(widget.cop.category)
                    : Text('Categoria'),
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
                      setState(
                          () => _isFieldStateValid = _mySelection2.isNotEmpty);
                    });
                  }
                },
                value: _mySelection2,
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
                  String cpf_cnpj = _controllerCpf_Cnpj.text.toString();

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
                    _scaffoldState.currentState.showSnackBar(
                      SnackBar(
                        backgroundColor: Colors.blue,
                        content: Text("Por Favor Preencha Todos os Campos"),
                      ),
                    );
                    return;
                  }

                  if (this.mounted) {
                    setState(() => _isLoading = true);
                  }

                  String name = _controllerName.text.toString();
                  String owner = _controllerOwner.text.toString();
                  String address = _controllerAddress.text.toString();
                  String phone = _controllerPhone.text.toString();
                  String password = _controllerPassword.text.toString();

                  Company cop = Company(
                      name: name,
                      image: base64Image,
                      category: _mySelection2,
                      cpf_cnpj: cpf_cnpj,
                      phone: phone,
                      owner: owner,
                      address: address,
                      password: password);

                  cop.id = widget.cop.id;

                  _apiServiceCop.updateCop(cop).then((isSuccess) {
                    if (this.mounted) {
                      setState(() => _isLoading = false);
                    }
                    
                    if (isSuccess) {
                      _scaffoldState.currentState.showSnackBar(SnackBar(
                        backgroundColor: Colors.green,
                        content: Text("Dados Ataulizados com Sucesso"),
                      ));
                    } else {
                      _scaffoldState.currentState.showSnackBar(SnackBar(
                        backgroundColor: Colors.red,
                        content: Text("Falha ao Atualizar os Dados"),
                      ));
                    }
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
                onPressed: () {},
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _showImage() {
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
          return widget.cop != null
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
                                base64Decode(widget.cop.image),
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
          if (widget.cop != null) {
            _isFieldImageValid = true;
            base64Image = widget.cop.image;
          }
          return widget.cop != null
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
                                base64Decode(widget.cop.image),
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
