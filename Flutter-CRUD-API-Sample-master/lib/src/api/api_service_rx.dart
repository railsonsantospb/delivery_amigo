
import 'dart:convert';
import 'package:flutter_crud_api_sample_app/src/model/requestx.dart';
import 'package:http/http.dart' show Client;


class ApiServiceRX {
  final String baseUrl = "http://192.168.1.17:5000";
  Client client = Client();

  Future<List<RequestX>> getRequestX() async {

    final response = await client.get("$baseUrl/rx");


    if (response.statusCode == 200) {
      return rxFromJson(response.body);
    } else {
      return null;
    }
  }


  Future<bool> createRequestX(RequestX rx) async {

    final response = await client.post(
      "$baseUrl/rx",
      headers: {"content-type": "application/json"},
      body: jsonEncode({"id": rx.id, "client": rx.client, "price_full": rx.price_full, "products": rx.products,
        "address": rx.address, "lat": rx.lat, "lon": rx.lon, "email": rx.email}),
    );

    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }

  }

  Future<bool> deleteRquestX(int id) async {

    final response = await client.delete(
      "$baseUrl/rx/$id",
    );
    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }
}
