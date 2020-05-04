import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_crud_api_sample_app/src/api/api_service_prod.dart';
import 'package:flutter_crud_api_sample_app/src/app.dart';
import 'package:flutter_crud_api_sample_app/src/model/category.dart';
import 'package:flutter_crud_api_sample_app/src/model/product.dart';
import 'package:async/async.dart';
import 'dart:io';
import 'package:dio/dio.dart';
import 'dart:async';
import 'dart:convert';
import 'package:image_picker/image_picker.dart';
import 'package:dbcrypt/dbcrypt.dart';

import '../home/home_screen.dart';

final GlobalKey<ScaffoldState> _scaffoldState = GlobalKey<ScaffoldState>();

class FormAddScreen extends StatefulWidget {
  Product prod;

  FormAddScreen({this.prod});

  @override
  _FormAddScreenState createState() => _FormAddScreenState();
}

class _FormAddScreenState extends State<FormAddScreen> {
  bool _isLoading = false;
  ApiServiceProd _apiService = ApiServiceProd();

  bool _isFieldNameValid;
  bool _isFieldPriceValid;
  bool _isFieldStateValid;
  bool _isFieldActiveValid;
  bool _isFieldCategoryValid;
  bool _isFieldImageValid;

  TextEditingController _controllerName = TextEditingController();
  TextEditingController _controllerPrice = TextEditingController();
  TextEditingController _controllerState = TextEditingController();
  TextEditingController _controllerActive = TextEditingController();
  TextEditingController _controllerCategory = TextEditingController();

  Future<File> file;
  String status = '';
  String base64Image;
  File tmpFile;
  String errMessage = 'Error Uploading Image';

  chooseImage() {
    setState(() {
      file = ImagePicker.pickImage(source: ImageSource.gallery);
    });
    setStatus('');
  }

  setStatus(String message) {
    setState(() {
      status = message;
    });
  }



  @override
  void initState() {
    if (widget.prod != null) {
      _isFieldNameValid = true;
      _controllerName.text = widget.prod.name;
      _isFieldPriceValid = true;
      _controllerPrice.text = widget.prod.price;
      _isFieldNameValid = true;
      _controllerName.text = widget.prod.state;
      _isFieldNameValid = true;
      _controllerName.text = widget.prod.active;
      _isFieldNameValid = true;
      _controllerName.text = widget.prod.category;
      _isFieldImageValid = true;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldState,
//      appBar: AppBar(
//        iconTheme: IconThemeData(color: Colors.white),
//        title: Text(
//          widget.cat == null ? "Form Add" : "Change Data",
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

//                      OutlineButton(
//                        color: Colors.deepOrange,
//                        onPressed: chooseImage,
//                        child: Text('Choose Image',
//                            style: TextStyle(color: Colors.deepOrange),),
//                      ),

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
                          ? "Submit".toUpperCase()
                          : "Update Data".toUpperCase(),
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
                            content: Text("Please fill all field"),
                          ),
                        );
                        return;
                      }
                        var plainPassword = "ola";
                        var hashedPassword = new DBCrypt().hashpw(plainPassword, new DBCrypt().gensalt());
                      setState(() => _isLoading = true);
                      String name = _controllerName.text.toString();
                      Category cat =
                          Category(id: hashedPassword.replaceAll('/', ''), name: name, image: base64Image);

                      if (widget.cat == null) {

                        _apiService.createCategory(cat).then((isSuccess) {
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
                        cat.id = widget.cat.id;
                        _apiService.updateCategory(cat).then((isSuccess) {

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
                    color: Colors.orange[600],
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
                snapshot.data,

              ),
              ),
            );

          } else if (null != snapshot.error) {
            return const Text(
              'Error Picking Image',
              textAlign: TextAlign.center,
            );
          }  else {
            if(widget.cat != null) {
              _isFieldImageValid = true;
              base64Image = widget.cat.image;
            }
            return widget.cat != null ?
            Flexible(

              child: Image.memory(base64Decode(widget.cat.image)),

            )



                : GestureDetector(
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
}