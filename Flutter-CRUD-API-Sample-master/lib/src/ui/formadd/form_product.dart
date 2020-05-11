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

  TextEditingController _controllerName = TextEditingController();
  TextEditingController _controllerPrice = TextEditingController();


  String _mySelection1;
  String _mySelection2;
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

  final String url = "http://192.168.1.17:5000/cat";

  List data;
  List state = [
    {'state': 'Gelada'},
    {'state': 'Natural'},
    {'state': 'Natural/Gelada'}
  ];

  Future<String> getSWData() async {
    var res = await http
        .get(Uri.encodeFull(url), headers: {"Accept": "application/json"});
    var resBody = json.decode(res.body);

    if(this.mounted){
      setState(() {
        data = resBody;
      });
    }


//    print(resBody);

    return "Sucess";
  }

  @override
  void initState() {
    getSWData();

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


        SafeArea(
          child: FutureBuilder(
            future: _apiServiceCat.getCategory(),
            builder:
                (BuildContext context, AsyncSnapshot<List<Category>> snapshot) {
              if (snapshot.hasError) {
                return Center(
                  child: Text(
                      "Alguma coisa está errada: ${snapshot.error.toString()}"),
                );
              } else if (snapshot.connectionState == ConnectionState.done) {
//            setState(() {});
                List<Category> cat = snapshot.data;

//            print(cat);
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
                  return Center(
                    child: new DropdownButtonFormField(
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
        ),



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
                        SnackBar(
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

                    Product prod = Product(
                        name: name,
                        price: price,
                        state: _mySelection2,
                        category: _mySelection1,
                        image: base64Image, cat_id: int.parse(_catId));

                    if (widget.prod == null) {
                      _apiServiceProd.createProduct(prod).then((isSuccess) {
                        if(this.mounted){
                          setState(() => _isLoading = false);
                        }

                        if (isSuccess) {
                          Navigator.pop(_scaffoldState.currentState.context);
                        } else {
                          _scaffoldState.currentState.showSnackBar(SnackBar(
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
                          _scaffoldState.currentState.showSnackBar(SnackBar(
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
