
import 'dart:convert';
import 'package:flutter_crud_api_sample_app/src/model/requestx.dart';
import 'package:http/http.dart' show Client;


class ApiServiceRX {
  final String baseUrl = "http://192.168.1.32:5000";
  Client client = Client();

  Future<List<RequestX>> getRequestXActive() async {



    try{
      final response = await client.get("$baseUrl/rxt");
      if (response.statusCode == 200) {
        return rxFromJson(response.body);
      } else {
        return null;
      }
    } catch(e){
        return rxFromJson('[{"id": ${0}, "client": "1", "active": ${2}, "price_full": "1", '
            '"products": "1", "date": "1", "address": "1", "lat": "1", "lon": "1", "email": "1"}]');
    }


  }

  Future<List<RequestX>> getRequestXNotActive() async {

    try{
      final response = await client.get("$baseUrl/rxf");
      if (response.statusCode == 200) {
        return rxFromJson(response.body);
      } else {
        return null;
      }
    } catch(e){
      return rxFromJson('[{"id": ${0}, "client": "1", "active": ${2}, "price_full": "1", '
          '"products": "1", "date": "1", "address": "1", "lat": "1", "lon": "1", "email": "1"}]');
    }
  }

  Future<bool> createRequestX(RequestX rx) async {

    try{
      final response = await client.post(
        "$baseUrl/rx",
        headers: {"content-type": "application/json"},
        body: jsonEncode({"id": rx.id, "client": rx.client, "active": rx.active, "price_full": rx.price_full, "products": rx.products,
          "address": rx.address, "lat": rx.lat, "lon": rx.lon, "email": rx.email}),
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

  Future<bool> updateRequestX(RequestX rx) async {

    try{
      final response = await client.put(
        "$baseUrl/rxu/${rx.id}",
        headers: {"content-type": "application/json"},
        body: jsonEncode({"id": rx.id, "client": rx.client, "active": 0, "price_full": rx.price_full, "products": rx.products,
          "address": rx.address, "lat": rx.lat, "lon": rx.lon, "email": rx.email}),
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

  Future<bool> deleteRequestX(int id) async {

    try{
      final response = await client.delete(
        "$baseUrl/rx/$id",
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

  Future<String> countRequestX() async {

    try{
      final response = await client.get(
        "$baseUrl/rxc",
      );

      if (response.statusCode == 200) {

        return response.body;
      } else {

        return null;
      }
    } catch(e){
      return null;
    }

  }
}
