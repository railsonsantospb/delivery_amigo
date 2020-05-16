
import 'dart:convert';
import 'package:flutter_crud_api_sample_app/src/model/category.dart';
import 'package:http/http.dart' show Client;
import '../model/category.dart';


class ApiServiceCat {
  final String baseUrl = "http://192.168.1.17:5000";
  Client client = Client();

  Future<List<Category>> getCategory() async {

    try{
      final response = await client.get("$baseUrl/cat");
      if (response.statusCode == 200) {

        return catFromJson(response.body);
      } else {
        return null;
      }
    } catch(e){
      return catFromJson('[{"id": ${0}, "name": "0", "image": "0"}]');
    }


  }

  Future<bool> createCategory(Category data) async {

    try{
      final response = await client.post(
        "$baseUrl/cat",
        headers: {"content-type": "application/json"},
        body: jsonEncode({"id": data.id, "name": data.name, "image": data.image}),
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

  Future<bool> updateCategory(Category data) async {

    try{
      final response = await client.put(
        "$baseUrl/cat/${data.id}",
        headers: {"content-type": "application/json"},
        body: jsonEncode({"name": data.name, "image": data.image}),
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

  Future<bool> deleteCategory(int id) async {

    try{
      final response = await client.delete(
        "$baseUrl/cat/$id",
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
