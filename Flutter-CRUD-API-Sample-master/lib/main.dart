import 'package:flutter/material.dart';
import 'package:flutter_crud_api_sample_app/src/app_cat.dart';
import 'package:dbcrypt/dbcrypt.dart';
import 'package:flutter_crud_api_sample_app/src/home_page.dart';

import 'src/api/api_service_cat.dart';

//main() {
//  var plainPassword = "P@55w0rd";
//  var hashedPassword = new DBCrypt().hashpw(plainPassword, new DBCrypt().gensalt());
//  print(hashedPassword);
//}


void main(){


  runApp(
      MaterialApp(
        debugShowCheckedModeBanner: false,
        home: HomePage1(),
      )
  );
}
