import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_crud_api_sample_app/src/api/api_service_cat.dart';
import 'package:flutter_crud_api_sample_app/src/api/api_service_prod.dart';
import 'package:flutter_crud_api_sample_app/src/app_cat.dart';
import 'package:flutter_crud_api_sample_app/src/model/category.dart';
import 'package:flutter_crud_api_sample_app/src/model/product.dart';
import 'package:async/async.dart';
import 'dart:io';
import 'package:dio/dio.dart';
import 'dart:async';
import 'dart:convert';
import 'package:image_picker/image_picker.dart';
import 'package:dbcrypt/dbcrypt.dart';

import '../home/home_category.dart';

final GlobalKey<ScaffoldState> _scaffoldState = GlobalKey<ScaffoldState>();

class FormAddProduct extends StatefulWidget {
  Product prod;

  FormAddProduct({this.prod});

  @override
  _FormAddProductState createState() => _FormAddProductState();
}

class _FormAddProductState extends State<FormAddProduct> {
  bool _isLoading = false;
  ApiServiceProd _apiServiceProd = ApiServiceProd();
  ApiServiceCat _apiServiceCat = ApiServiceCat();

  bool _isFieldNameValid;
  bool _isFieldPriceValid;
  bool _isFieldStateValid;
  bool _isFieldCategoryValid;
  bool _isFieldImageValid;

  TextEditingController _controllerName = TextEditingController();
  TextEditingController _controllerPrice = TextEditingController();
  TextEditingController _controllerState = TextEditingController();
  TextEditingController _controllerCategory = TextEditingController();

  Future<File> file;
  String status = '';
  String base64Image;
  File tmpFile;
  String errMessage = 'Error Uploading Image';
  int _selectedGender = 0;

  List<DropdownMenuItem<int>> genderList = [];

  chooseImage() {
    setState(() {
      file = ImagePicker.pickImage(source: ImageSource.gallery);
    });

  }



  @override
  void initState() {
    if (widget.prod != null) {
      _isFieldNameValid = true;
      _controllerName.text = widget.prod.name;
      _isFieldPriceValid = true;
      _controllerPrice.text = widget.prod.price;
      _isFieldStateValid = true;
      _controllerName.text = widget.prod.state;
      _isFieldCategoryValid = true;
      _controllerName.text = widget.prod.category;

      _isFieldImageValid = true;
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
              setState(() => _isFieldNameValid = isFieldValid);
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
              setState(() => _isFieldPriceValid = isFieldValid);
            }
          },
        ),

        _isLoading
            ? ListView(
                children: <Widget>[
                  Opacity(
                    opacity: 0.3,
                    child: ModalBarrier(
                      dismissible: false,
                      color: Colors.grey,
                    ),
                  ),
                  Center(
                    child: CircularProgressIndicator(),
                  ),
                ],
              )
            : Container(),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      key: _scaffoldState,
      appBar: AppBar(
        backgroundColor: Colors.deepOrange,
        iconTheme: IconThemeData(color: Colors.white),
        title: Text(
          widget.prod == null ? "Adicionar Bebida" : "Atualizar Dados",
          style: TextStyle(color: Colors.white),
        ),
      ),
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
                            base64Image == null ||
                            !_isFieldNameValid ||
                            !_isFieldPriceValid ||
                            !_isFieldStateValid ||
                            !_isFieldCategoryValid ||
                            !_isFieldImageValid) {
                          _scaffoldState.currentState.showSnackBar(
                            SnackBar(
                              content: Text("Please fill all field"),
                            ),
                          );
                          return;
                        }

                        setState(() => _isLoading = true);
                        String name = _controllerName.text.toString();
                        String price = _controllerPrice.text.toString();
                        String state = _controllerState.text.toString();

                        Product prod = Product(
                            name: name, price: price, state: state, image: base64Image);

                        if (widget.prod == null) {
                          _apiServiceProd.createProduct(prod).then((isSuccess) {
                            setState(() => _isLoading = false);

                            if (isSuccess) {
                              Navigator.pop(_scaffoldState.currentState.context);
                            } else {
                              _scaffoldState.currentState.showSnackBar(SnackBar(
                                content: Text("Submit data failed"),
                              ));
                            }
                          });
                        } else {
                          prod.id = widget.prod.id;
                          _apiServiceProd.updateProduct(prod).then((isSuccess) {
                            setState(() => _isLoading = false);
                            if (isSuccess) {
    //                            Navigator.of(context).push(CupertinoPageRoute<void>(
    //                              builder: (BuildContext context) => App(),
    //                            ));
                              Navigator.pop(_scaffoldState.currentState.context);
                            } else {
                              _scaffoldState.currentState.showSnackBar(SnackBar(
                                content: Text("Update data failed"),
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
                  snapshot.data,
                ),
              ),
            ],
          );
        } else if (null != snapshot.error) {
          return const Text(
            'Error Picking Image',
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
                    Image.memory(base64Decode(widget.prod.image)),
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

  Widget _buildTextFieldName() {
    return TextFormField(
      controller: _controllerName,
      keyboardType: TextInputType.text,
      decoration: InputDecoration(
        labelText: "Full name",
        errorText: _isFieldNameValid == null || _isFieldNameValid
            ? null
            : "Full name is required",
      ),
      onChanged: (value) {
        bool isFieldValid = value.trim().isNotEmpty;
        if (isFieldValid != _isFieldNameValid) {
          setState(() => _isFieldNameValid = isFieldValid);
        }
      },
    );
  }

  Widget _buildTextFieldPrice() {
    return TextFormField(
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
          setState(() => _isFieldPriceValid = isFieldValid);
        }
      },
    );
  }

  void loadGenderList() {
    genderList = [];
    genderList.add(new DropdownMenuItem(
      child: new Text('Gelada'),
      value: 0,
    ));
    genderList.add(new DropdownMenuItem(
      child: new Text('Natural'),
      value: 1,
    ));
  }

  Widget _buildTextFieldState() {
    loadGenderList();
    return Form(
        child: new ListView(
      children: getFormWidget(),
    ));
  }

  List<Widget> getFormWidget() {
    List<Widget> formWidget = new List();

    formWidget.add(new DropdownButton(
      hint: new Text('Gelada ou Natural'),
      items: genderList,
      value: _selectedGender,
      onChanged: (value) {
        setState(() {
          _selectedGender = value;
        });
      },
      isExpanded: true,
    ));

    return formWidget;
  }
}
