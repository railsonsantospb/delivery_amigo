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
import 'package:http/http.dart' as http;

final GlobalKey<ScaffoldState> _scaffoldState = GlobalKey<ScaffoldState>();

class FormAddProduct extends StatefulWidget {
  Product prod;

  FormAddProduct({this.prod});

  @override
  _FormAddProductState createState() => _FormAddProductState();
}

class _FormAddProductState extends State<FormAddProduct> {
  bool _isLoading = false;
  int selected = 0;
  ApiServiceProd _apiServiceProd = ApiServiceProd();
  ApiServiceCat _apiServiceCat;

  bool _isFieldNameValid;
  bool _isFieldPriceValid;
  bool _isFieldStateValid;
  bool _isFieldCategoryValid;
  bool _isFieldImageValid;
  bool _isFieldCatIdValid;
  bool _isFieldMarkValid;
  bool _isFieldActiveValid;

  TextEditingController _controllerName = TextEditingController();
  TextEditingController _controllerPrice = TextEditingController();
  TextEditingController _controllerMark = TextEditingController();


  String _mySelection1;
  String _mySelection2;
  String _active;
  String _activeS;
  String value;
  String _catId;
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
    {'state': 'Gelada'},
    {'state': 'Natural'},
    {'state': 'Natural/Gelada'}
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
      _controllerName.text = widget.prod.state;
      _isFieldCategoryValid = true;
      _controllerName.text = widget.prod.category;

      _isFieldMarkValid = true;
      _controllerMark.text = widget.prod.mark;

      _isFieldImageValid = true;

      _isFieldCatIdValid = true;

    }
    super.initState();
  }

  Widget _formUI() {
    return new Column(
      children: <Widget>[
        _showImage(),
        new TextFormField(
          controller: _controllerName,
          decoration: InputDecoration(
            labelText: "Nome",
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
            labelText: "Preço",
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
            labelText: "Marca",
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


        Visibility(
          visible: widget.prod != null ? false : true,
          child: SafeArea(
          child: FutureBuilder(
            future: _apiServiceCat.getCategory(),
            builder:
                (BuildContext context, AsyncSnapshot<List<Category>> snapshot) {
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

                        ],
                      ),
                    ],
                  ),
                );
              } else if (snapshot.connectionState == ConnectionState.done) {

                List<Category> cat = snapshot.data;

                if (cat.isEmpty == true) {
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
                            child: Text('NENHUMA CATEGORIA CADASTRADA'),
                          ),
                        ],
                      ),
                    ],
                  );
                } else {
                  List<Category> cats = cat;
                  return Center(
                    child: cats[0].id == 0 ? Text('SEM CONEXÃO COM A INTERNET') : new DropdownButtonFormField(
                      value: value,
                      hint: widget.prod != null ? Text(widget.prod.category) : Text('Selecione a Categoria'),
                      onChanged: widget.prod != null ? null : (newVal) {

                        if(this.mounted){
                          setState(() {
                            for(var f in cat){
                              if(f.id.toString() == newVal){
                                _mySelection1 = f.name;
                              }
                            }
                            value = newVal;
                            _catId = newVal;
                            setState(() => _isFieldCategoryValid = _mySelection1.isNotEmpty);
                            setState(() => _isFieldCatIdValid = _catId.isNotEmpty);
                          });
                        }
                      },

                      items: cat.map((item) {

                        return new DropdownMenuItem(
                          child: new Text(item.name),
                          value: item.id.toString(),
                        );
                      }).toList(),

                    ),
                  );
                }
              } else {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
            },
          ),
        )),



        Center(
          child: new DropdownButtonFormField(
            hint: widget.prod != null ? Text(widget.prod.state) : Text('Bebida Natural ou Gelada?'),
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
        Center(
          child: new DropdownButtonFormField(
            hint: widget.prod != null ? Text(widget.prod.active == 0 ? "Habilitada" : "Desabilitada")
                : Text('Habilitar ou Desabilitar Bebida?'),
            items: valueActive.map((item) {
              return new DropdownMenuItem<String>(
                child: new Text(item['active']),
                value: item['active'].toString(),
              );
            }).toList(),
            onChanged: (newVal) {
              if(this.mounted){
                setState(() {
                  _activeS = newVal;
                  if(newVal == "Habilitada") {
                    _active = "0";
                  } else {
                    _active = "1";
                  }
                  print(_active);
                  setState(() => _isFieldActiveValid = _active.isNotEmpty);
                });

              }
            },
            value: _activeS,
          ),
        ),

      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      key: _scaffoldState,
//      appBar: AppBar(
//        backgroundColor: Colors.deepOrange,
//        iconTheme: IconThemeData(color: Colors.white),
//        title: Text(
//          widget.prod == null ? "Adicionar Bebida" : "Atualizar Dados",
//          style: TextStyle(color: Colors.white),
//        ),
//      ),
      body: SingleChildScrollView(
        child: new Container(
          margin: new EdgeInsets.all(15.0),
          child: new Form(
            child: _formUI(),
          ),
        ),
      ),
      bottomNavigationBar: new Container(
        child: Row(
          children: <Widget>[
            Expanded(
              child: Padding(
                padding: EdgeInsets.all(12.0),
                child: new MaterialButton(
                  child: Text(
                    widget.prod == null
                        ? "Cadastrar".toUpperCase()
                        : "Atualizar".toUpperCase(),
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),

                  onPressed: () {

                    if (_isFieldNameValid == null ||
                        _isFieldPriceValid == null ||
                        _isFieldStateValid == null ||
                        _isFieldCategoryValid == null ||
                        _isFieldCatIdValid == null ||
                        base64Image == null ||
                        !_isFieldNameValid ||
                        !_isFieldPriceValid ||
                        !_isFieldStateValid ||
                        !_isFieldCategoryValid ||
                        !_isFieldImageValid ||
                        !_isFieldCatIdValid) {
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
                    String idx = _catId != null ? _catId : widget.prod.cat_id.toString();
                    String activex = _active != null ? _active : widget.prod.active.toString();

                    Product prod = Product(
                        name: name,
                        mark: mark,
                        active: int.parse(activex),
                        price: price,
                        state: _mySelection2 != null ? _mySelection2 : widget.prod.state,
                        category: _mySelection1 != null ? _mySelection1 : widget.prod.category,
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
//                    backgroundColor: ,
                  color: Colors.deepOrange,
                ),
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
                child: Image.file(
                  snapshot.data, cacheHeight: 500, cacheWidth: 500,
                ),
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
                    Image.memory(base64Decode(widget.prod.image), cacheHeight: 500, cacheWidth: 500,),
                  ],
                )
              : GestureDetector(
                  onTap: chooseImage,
                  child: Icon(
                    Icons.photo_camera,
                    size: 100.0,
                    color: Colors.deepOrange,
                  ),
                );
        }
      },
    );
  }
}
