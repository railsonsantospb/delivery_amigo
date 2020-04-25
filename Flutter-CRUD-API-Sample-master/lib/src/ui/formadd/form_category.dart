import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_crud_api_sample_app/src/api/api_service.dart';
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

final GlobalKey<ScaffoldState> _scaffoldState = GlobalKey<ScaffoldState>();

class FormAddScreen extends StatefulWidget {
  Category cat;

  FormAddScreen({this.cat});

  @override
  _FormAddScreenState createState() => _FormAddScreenState();
}

class _FormAddScreenState extends State<FormAddScreen> {
  bool _isLoading = false;
  ApiService _apiService = ApiService();

  bool _isFieldNameValid;
  bool _isFieldImageValid;

  TextEditingController _controllerName = TextEditingController();

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

  startUpload() {
    setStatus('Uploading Image...');
    if (null == tmpFile) {
      setStatus(errMessage);
      return;
    }
    upload();
  }

  upload() async {
    String fileName = tmpFile.path.split('/').last;
    FormData data = FormData.fromMap({
      "image": await MultipartFile.fromFile(
        tmpFile.path,
        filename: fileName,
      ),
      "email": "qqqqqqqq",
    });

    Dio dio = new Dio();

    dio.post('http://127.0.0.1:5000/user/user', data: data)
        .then((response) => print(response))
        .catchError((error) => print(error));
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
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        title: Text(
          widget.cat == null ? "Form Add" : "Change Data",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Stack(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                _showImage(),

                _buildTextFieldName(),
                Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[

                      OutlineButton(
                        color: Colors.deepOrange,
                        onPressed: chooseImage,
                        child: Text('Choose Image',
                            style: TextStyle(color: Colors.deepOrange),),
                      ),

                      SizedBox(
                        height: 10.0,
                      ),

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
                  padding: const EdgeInsets.only(top: 5.0),
                  child: RaisedButton(
                    child: Text(
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
//                      print(hashedPassword);

                      Category cat =
                          Category(id: hashedPassword.replaceAll('/', ''), name: name, image: base64Image);

                      if (widget.cat == null) {

                        _apiService.createCategory(cat).then((isSuccess) {
                          setState(() => _isLoading = false);
                          if (isSuccess) {

//                            Navigator.of(context).push(CupertinoPageRoute<void>(
//                              builder: (BuildContext context) => App(),
//                            ));
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
                            Navigator.pop(_scaffoldState.currentState.context);
                          } else {
                            _scaffoldState.currentState.showSnackBar(SnackBar(
                              content: Text("Update data failed"),
                            ));
                          }
                        });
                      }
                    },
                    color: Colors.orange[600],
                  ),
                )
              ],
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

            child: Image.file(
               snapshot.data,
              fit: BoxFit.fill,
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



          : Text(

            'No Image Selected',
            textAlign: TextAlign.center,
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
