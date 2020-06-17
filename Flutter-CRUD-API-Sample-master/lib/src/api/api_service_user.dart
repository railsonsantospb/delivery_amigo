
import 'dart:convert';
import 'package:flutter_crud_api_sample_app/src/model/user.dart';
import 'package:http/http.dart' show Client;

class ApiServiceUser {
  final String baseUrl = "http://192.168.1.32:5000";
  Client client = Client();

  Future<List<User>> getUser() async {

    try{
      final response = await client.get("$baseUrl/user");
      if (response.statusCode == 200) {

        return userFromJson(response.body);
      } else {
        return null;
      }
    } catch(e){
      return userFromJson('[{"email": "0", "name": "0", "password": "0"}]');
    }


  }


  Future<bool> updateUser(User data) async {

    try{
      final response = await client.put(
        "$baseUrl/user/${data.email}",
        headers: {"content-type": "application/json"},
        body: jsonEncode({"name": data.name, "password": data.password}),
      );
      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch(e){
      return false;
    }

  }

  Future<bool> deleteUser(String email) async {

    try{
      final response = await client.delete(
        "$baseUrl/user/$email",
      );
      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch(e){
      return false;
    }
  }
}
