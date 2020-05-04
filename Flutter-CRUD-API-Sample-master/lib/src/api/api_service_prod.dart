
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_crud_api_sample_app/src/model/category.dart';
import 'package:http/http.dart' show Client;

import '../model/category.dart';
import '../model/category.dart';
import '../model/category.dart';

class ApiServiceProd {
  final String baseUrl = "http://192.168.1.17:5000";
  Client client = Client();

  Future<List<Category>> getCategory() async {

    final response = await client.get("$baseUrl/prod");


    if (response.statusCode == 200) {
      return catFromJson(response.body);
    } else {
      return null;
    }
  }

  Future<bool> createCategory(Category data) async {

    final response = await client.post(
      "$baseUrl/prod",
      headers: {"content-type": "application/json"},
      body: jsonEncode({"id": data.id, "name": data.name, "image": data.image}),
    );

    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }

  }

  Future<bool> updateCategory(Category data) async {

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

  Future<bool> deleteCategory(String id) async {

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
