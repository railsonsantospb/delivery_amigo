
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_crud_api_sample_app/src/model/category.dart';
import 'package:flutter_crud_api_sample_app/src/model/product.dart';
import 'package:http/http.dart' show Client;

import '../model/category.dart';
import '../model/category.dart';
import '../model/category.dart';

class ApiServiceProd {
  final String baseUrl = "http://192.168.1.17:5000";
  Client client = Client();


  Future<List<Product>> getProductId(int id) async {

    try{
      final response = await client.get("$baseUrl/prod/${id}");
      if (response.statusCode == 200) {
        return prodFromJson(response.body);
      } else {
        return null;
      }
    } catch(e){

      return prodFromJson('[{"id": ${0}, "name": "0", "mark": "0", "active": ${0}, "price": "0", "state": "0",'
          ' "category": "0", "image": ${base64Decode("0")}, "cat_id": ${0}]');
    }

  }

  Future<bool> createProduct(Product data) async {

    try{
      final response = await client.post(
        "$baseUrl/prod",
        headers: {"content-type": "application/json"},
        body: jsonEncode({"name": data.name, "mark": data.mark, "active": data.active, "price": data.price,
          "state":data.state, "category": data.category, "image": data.image, "cat_id": data.cat_id}),
      );

      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    }catch (e){
      return false;
    }

  }

  Future<bool> updateProduct(Product data) async {

    try{
      final response = await client.put(
        "$baseUrl/prod/${data.id}",
        headers: {"content-type": "application/json"},
        body: jsonEncode({"name": data.name, "mark": data.mark, "active": data.active, "price": data.price,
          "state":data.state, "category": data.category, "image": data.image, "cat_id": data.cat_id}),
      );
      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (e){
       return false;
    }

  }

  Future<bool> deleteProduct(int id) async {

    try{
      final response = await client.delete(
        "$baseUrl/prod/$id",
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
