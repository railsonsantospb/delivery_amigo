import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_crud_api_sample_app/src/api/api_service_cat.dart';
import 'package:flutter_crud_api_sample_app/src/model/category.dart';
import 'package:flutter_crud_api_sample_app/src/ui/home/home_category.dart';
import 'dart:io';
import 'dart:async';
import 'dart:convert';
import 'package:image_picker/image_picker.dart';


final GlobalKey<ScaffoldState> _scaffoldState = GlobalKey<ScaffoldState>();

class FormAddCategory extends StatefulWidget {
  Category cat;


  FormAddCategory({this.cat});

  @override
  _FormAddCategoryState createState() => _FormAddCategoryState();
}

class _FormAddCategoryState extends State<FormAddCategory> {
  bool _isLoading = false;
  ApiServiceCat _apiService = ApiServiceCat();
  HomeCategory home = HomeCategory();

  bool _isFieldNameValid;
  bool _isFieldImageValid;

  TextEditingController _controllerName = TextEditingController();

  Future<File> file;
  String status = '';
  String base64Image;
  File tmpFile;
  String errMessage = 'Erro ao Enviar Imagem';

  chooseImage() {
    if(this.mounted){
      setState(() {
        file = ImagePicker.pickImage(source: ImageSource.gallery);
      });
    }

    setStatus('');
  }

  setStatus(String message) {
    if(this.mounted){
      setState(() {
        status = message;
      });
    }

  }



  @override
  void initState() {
    if (widget.cat != null) {
      _isFieldNameValid = true;
      _controllerName.text = widget.cat.name;
      _isFieldImageValid = true;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldState,
//      appBar: AppBar(
//        backgroundColor: Colors.deepOrange,
//        iconTheme: IconThemeData(color: Colors.white),
//        title: Text(
//          widget.cat == null ? "Adicionar Categoria" : "Atualizar Dados",
//          style: TextStyle(color: Colors.white),
//        ),
//      ),
      body:  Stack(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(12.0),

            child: Container(
              child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[

                _showImage(),

                _buildTextFieldName(),
                Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[


                      Text(
                        status,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.green,
                          fontWeight: FontWeight.w500,
                          fontSize: 20.0,
                        ),
                      ),

                    ],
                  ),
                ),


                Padding(
                  padding: const EdgeInsets.only(top: 0.0),
                  child: RaisedButton(

                    child:  Text(
                      widget.cat == null
                          ? "Cadastrar".toUpperCase()
                          : "Atualizar".toUpperCase(),
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),

                    onPressed: () {
                      if (_isFieldNameValid == null ||
                          base64Image == null ||
                          !_isFieldNameValid ||
                          ! _isFieldImageValid) {
                        _scaffoldState.currentState.showSnackBar(
                          SnackBar(
                            content: Text("Por Favor Preencha os Campos"),
                          ),
                        );
                        return;
                      }
                        if(this.mounted){
                          setState(() => _isLoading = true);
                        }

                      String name = _controllerName.text.toString();
                      Category cat =
                          Category(name: name, image: base64Image);

                      if (widget.cat == null) {

                        _apiService.createCategory(cat).then((isSuccess) {

                          if(this.mounted){
                            setState(() => _isLoading = false);
                          }

                          if (isSuccess) {

                            Scaffold.of(_scaffoldState.currentState.context)
                                .showSnackBar(SnackBar(backgroundColor: Colors.green,
                                content: Text(
                                    "Cadastrado com Sucesso")));
                            Navigator.pop(_scaffoldState.currentState.context);
                          } else {
                            _scaffoldState.currentState.showSnackBar(SnackBar(backgroundColor: Colors.red,
                              content: Text("Erro ao Enviar"),
                            ));
                          }
                        });
                      } else {
                        cat.id = widget.cat.id;
                        _apiService.updateCategory(cat).then((isSuccess) {

                          if(this.mounted){
                            setState(() => _isLoading = false);
                          }
                          if (isSuccess) {
//                            Navigator.of(context).push(CupertinoPageRoute<void>(
//                              builder: (BuildContext context) => App(),
//                            ));
                            Navigator.pop(_scaffoldState.currentState.context);
                          } else {
                            _scaffoldState.currentState.showSnackBar(SnackBar(backgroundColor: Colors.red,
                              content: Text("Falha na Atualização"),
                            ));
                          }
                        });
                      }
                    },
//                    backgroundColor: ,
                    color: Colors.deepOrange,
                  ),
                ),
              ],
            ),
            ),
          ),
          _isLoading
              ? Stack(
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



            return Flexible(
              child: GestureDetector(
                onTap: chooseImage,
              child: Image.file(
                snapshot.data, cacheHeight: 500, cacheWidth: 500,

              ),
              ),
            );

          } else if (null != snapshot.error) {
            return const Text(
              'Error ao Inserir Imagem',
              textAlign: TextAlign.center,
            );
          }  else {
            if(widget.cat != null) {
              _isFieldImageValid = true;
              base64Image = widget.cat.image;
            }
            return widget.cat != null ?
            Wrap(
              children: <Widget>[
                Image.memory(base64Decode(widget.cat.image), cacheHeight: 500, cacheWidth: 500,),
              ],
            ) : GestureDetector(
                  onTap: chooseImage,
                child: Icon(Icons.photo_camera, size: 100.0, color: Colors.deepOrange,),
            );

          }
        },

    );

  }

  Widget _buildTextFieldName() {
    return TextField(
      controller: _controllerName,
      keyboardType: TextInputType.text,
      decoration: InputDecoration(
        labelText: "Nome",
        errorText: _isFieldNameValid == null || _isFieldNameValid
            ? null
            : "Insira o Nome da Categoria",
      ),
      onChanged: (value) {
        bool isFieldValid = value.trim().isNotEmpty;
        if (isFieldValid != _isFieldNameValid) {
          if(this.mounted){
            setState(() => _isFieldNameValid = isFieldValid);
          }

        }
      },
    );
  }
}
