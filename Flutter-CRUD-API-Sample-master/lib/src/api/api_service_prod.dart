
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

  Future<List<Product>> getProduct() async {

    final response = await client.get("$baseUrl/prod");


    if (response.statusCode == 200) {
      return prodFromJson(response.body);
    } else {
      return null;
    }
  }

  Future<List<Product>> getProductId(int id) async {

    final response = await client.get("$baseUrl/prod/${id}");

    if (response.statusCode == 200) {
      return prodFromJson(response.body);
    } else {
      return null;
    }
  }

  Future<bool> createProduct(Product data) async {

    final response = await client.post(
      "$baseUrl/prod",
      headers: {"content-type": "application/json"},
      body: jsonEncode({"name": data.name, "price": data.price,
        "state":data.state, "category": data.category, "image": data.image, "cat_id": data.cat_id}),
    );

    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }

  }

  Future<bool> updateProduct(Product data) async {

    final response = await client.put(
      "$baseUrl/prod/${data.id}",
      headers: {"content-type": "application/json"},
      body: jsonEncode({"name": data.name, "image": data.image}),
    );
    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }

  }

  Future<bool> deleteProduct(int id) async {

    final response = await client.delete(
      "$baseUrl/prod/$id",
    );
    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }
}
