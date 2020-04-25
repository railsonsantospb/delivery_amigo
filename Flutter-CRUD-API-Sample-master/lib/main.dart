import 'package:flutter/material.dart';
import 'package:flutter_crud_api_sample_app/src/app.dart';
import 'package:dbcrypt/dbcrypt.dart';

//main() {
//  var plainPassword = "P@55w0rd";
//  var hashedPassword = new DBCrypt().hashpw(plainPassword, new DBCrypt().gensalt());
//  print(hashedPassword);
//}


void main(){
  runApp(
      MaterialApp(
        debugShowCheckedModeBanner: false,
        home: App(),
      )
  );
}
