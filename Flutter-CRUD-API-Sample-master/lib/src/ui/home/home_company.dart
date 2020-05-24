import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_crud_api_sample_app/src/api/api_service_cat.dart';
import 'package:flutter_crud_api_sample_app/src/api/api_service_prod.dart';
import 'package:flutter_crud_api_sample_app/src/model/category.dart';
import 'package:flutter_crud_api_sample_app/src/model/product.dart';
import 'dart:io';
import 'dart:async';
import 'dart:convert';
import 'package:image_picker/image_picker.dart';

final GlobalKey<ScaffoldState> _scaffoldState = GlobalKey<ScaffoldState>();

class FormAddCompany extends StatefulWidget {
  Product prod;
  String id;


  @override
  _FormAddCompanyState createState() => _FormAddCompanyState();
}

class _FormAddCompanyState extends State<FormAddCompany> {
  bool _isLoading = false;
  int selected = 0;
  ApiServiceProd _apiServiceProd = ApiServiceProd();
  ApiServiceCat _apiServiceCat;

  bool _isFieldNameValid;
  bool _isFieldPriceValid;
  bool _isFieldStateValid;
  bool _isFieldImageValid;
  bool _isFieldCatIdValid;
  bool _isFieldMarkValid;
  bool _isFieldActiveValid;

  TextEditingController _controllerName = TextEditingController();
  TextEditingController _controllerPrice = TextEditingController();
  TextEditingController _controllerMark = TextEditingController();

  String _mySelection2;
  String _active;
  String _activeS;
  String value;
  Future<File> file;
  String status = '';
  String base64Image;
  File tmpFile;
  String errMessage = 'Error Uploading Image';

  chooseImage() {
    if(this.mounted){
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



  @override
  void initState() {


    _apiServiceCat = ApiServiceCat();
    if (widget.prod != null) {
      _isFieldNameValid = true;
      _controllerName.text = widget.prod.name;
      _isFieldPriceValid = true;
      _controllerPrice.text = widget.prod.price;
      _isFieldStateValid = true;

      _isFieldMarkValid = true;
      _controllerMark.text = widget.prod.mark;

      _isFieldImageValid = true;

      _isFieldCatIdValid = true;

    }
    super.initState();
    setState(() => _isFieldCatIdValid = widget.prod == null ?  true : true);
  }

  Widget _formUI() {
    return new Column(
      children: <Widget>[
        _showImage(),
        new TextFormField(
          controller: _controllerName,
          decoration: InputDecoration(
            labelText: "Nome da Empresa",
            errorText: _isFieldNameValid == null || _isFieldNameValid
                ? null
                : "Insira o Nome",
          ),
          onChanged: (value) {
            bool isFieldValid = value.trim().isNotEmpty;
            if (isFieldValid != _isFieldNameValid) {
              if(this.mounted){
                setState(() => _isFieldNameValid = isFieldValid);
              }
            }
          },
        ),
        new TextFormField(
          controller: _controllerPrice,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            labelText: "Nome do Proprietário",
            errorText: _isFieldPriceValid == null || _isFieldPriceValid
                ? null
                : "O preço é obtrigatório",
          ),
          onChanged: (value) {
            bool isFieldValid = value.trim().isNotEmpty;
            if (isFieldValid != _isFieldPriceValid) {
              if(this.mounted){
                setState(() => _isFieldPriceValid = isFieldValid);
              }
            }
          },
        ),
        new TextFormField(
          controller: _controllerMark,
          keyboardType: TextInputType.text,
          decoration: InputDecoration(
            labelText: "CPF/CNPJ",
            errorText: _isFieldMarkValid == null || _isFieldMarkValid
                ? null
                : "A marca é obtrigatória",
          ),
          onChanged: (value) {
            bool isFieldValid = value.trim().isNotEmpty;
            if (isFieldValid != _isFieldMarkValid) {
              if(this.mounted){
                setState(() => _isFieldMarkValid = isFieldValid);
              }
            }
          },
        ),
        new TextFormField(
          controller: _controllerMark,
          keyboardType: TextInputType.text,
          decoration: InputDecoration(
            labelText: "Endereço da Empresa",
            errorText: _isFieldMarkValid == null || _isFieldMarkValid
                ? null
                : "A marca é obtrigatória",
          ),
          onChanged: (value) {
            bool isFieldValid = value.trim().isNotEmpty;
            if (isFieldValid != _isFieldMarkValid) {
              if(this.mounted){
                setState(() => _isFieldMarkValid = isFieldValid);
              }
            }
          },
        ),

        Center(
          child: new DropdownButtonFormField(
            hint: widget.prod != null ? Text(widget.prod.state) : Text('Categoria'),
            items: state.map((item) {
              return new DropdownMenuItem(
                child: new Text(item['state']),
                value: item['state'].toString(),
              );
            }).toList(),
            onChanged: (newVal) {
              if(this.mounted){
                setState(() {
                  _mySelection2 = newVal;
                  setState(() => _isFieldStateValid = _mySelection2.isNotEmpty);
                });
              }
            },
            value: _mySelection2,
          ),
        ),

      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
        primaryColor: Colors.deepOrange,
        accentColor: Colors.deepOrange,
    ),
    home: Scaffold(
      resizeToAvoidBottomInset: false,
      key: _scaffoldState,
      body: SingleChildScrollView(
        child: new Container(
          margin: new EdgeInsets.all(15.0),
          child: new Form(
            child: _formUI(),
          ),
        ),
      ),

      floatingActionButton: FloatingActionButton(
        child: Icon(
          Icons.send,
          color: Colors.white,
        ),
        onPressed: () {

          if (_isFieldNameValid == null ||
              _isFieldPriceValid == null ||
              _isFieldStateValid == null ||
              _isFieldCatIdValid == null ||
              base64Image == null ||
              !_isFieldNameValid ||
              !_isFieldPriceValid ||
              !_isFieldStateValid ||
              !_isFieldImageValid ||
              !_isFieldCatIdValid) {
            print(_isFieldCatIdValid);
            _scaffoldState.currentState.showSnackBar(
              SnackBar(backgroundColor: Colors.blue,
                content: Text("Por Favor Preencha Todos os Campos"),
              ),
            );

            return;
          }

          if(this.mounted){
            setState(() => _isLoading = true);
          }

          String name = _controllerName.text.toString();
          String price = _controllerPrice.text.toString();
          String mark = _controllerMark.text.toString();
          String idx = widget.id != null ? widget.id : widget.prod.cat_id.toString();
          String activex = _active != null ? _active : widget.prod.active.toString();

          Product prod = Product(
              name: name,
              mark: mark,
              active: int.parse(activex),
              price: price,
              state: _mySelection2 != null ? _mySelection2 : widget.prod.state,
              image: base64Image, cat_id: int.parse(idx));

          if (widget.prod == null) {
            _apiServiceProd.createProduct(prod).then((isSuccess) {

              if(this.mounted){
                setState(() => _isLoading = false);
              }

              if (isSuccess) {

                Navigator.pop(_scaffoldState.currentState.context);
              } else {
                _scaffoldState.currentState.showSnackBar(SnackBar(backgroundColor: Colors.red,
                  content: Text("Falha ao Enviar os Dados"),
                ));
              }
            });
          } else {
            prod.id = widget.prod.id;
            _apiServiceProd.updateProduct(prod).then((isSuccess) {
              if(this.mounted){
                setState(() => _isLoading = false);
              }
              if (isSuccess) {

                Navigator.pop(_scaffoldState.currentState.context);
              } else {
                _scaffoldState.currentState.showSnackBar(SnackBar(backgroundColor: Colors.red,
                  content: Text("Falha ao Atualizar os Dados"),
                ));
              }
            });
          }
        },
      )
    ));
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
          return const Text(
            'Erro ao Inserir Imagem',
            textAlign: TextAlign.center,
          );
        } else {
          if (widget.prod != null) {
            _isFieldImageValid = true;
            base64Image = widget.prod.image;
          }
          return widget.prod != null
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
                          base64Decode(widget.prod.image),
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
                    Text("IMGEM DA EMPRESA"),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Icon(
                      Icons.photo_camera,
                      size: 100.0,
                      color: Colors.deepOrange,
                    ),
                  ],
                ),
              ],
            )
          );
        }
      },
    );
  }
}
