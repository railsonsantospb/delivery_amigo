import 'dart:convert';
import 'package:deliveryadmin/src/model/requestx.dart';
import 'package:http/http.dart' show Client;

class ApiServiceRX {
  final String baseUrl = "https://apibebidas.herokuapp.com";
//  final String baseUrl = "http://192.168.1.32:5000";
  Client client = Client();

  Future<List<RequestX>> getRequestXActive(int id_cop) async {
    try {
      final response = await client.get(
        "$baseUrl/rxt/$id_cop",
        headers: {
          "content-type": "application/json",
          "X-Api-Key": "t1h3m5p7v9711713d15617f19"
        },
      );

      if (response.statusCode == 200) {
        return rxFromJson(response.body);
      } else {
        return [];
      }
    } catch (e) {
      return null;
    }
  }

  Future<List<RequestX>> getRequestXNotActive(int id_cop) async {
    try {
      final response = await client.get(
        "$baseUrl/rxf/$id_cop",
        headers: {
          "content-type": "application/json",
          "X-Api-Key": "t1h3m5p7v9711713d15617f19"
        },
      );
      if (response.statusCode == 200) {
        return rxFromJson(response.body);
      } else {
        return [];
      }
    } catch (e) {
      return null;
    }
  }

  Future<bool> createRequestX(RequestX rx) async {
    try {
      final response = await client.post(
        "$baseUrl/rx",
        headers: {
          "content-type": "application/json",
          "X-Api-Key": "t1h3m5p7v9711713d15617f19"
        },
        body: jsonEncode({
          "id": rx.id,
          "client": rx.client,
          "active": rx.active,
          "price_full": rx.price_full,
          "products": rx.products,
          "address": rx.address,
          "lat": rx.lat,
          "lon": rx.lon,
          "email": rx.email
        }),
      );

      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  Future<bool> updateRequestX(RequestX rx) async {
    try {
      final response = await client.put(
        "$baseUrl/rxu/${rx.id}",
        headers: {
          "content-type": "application/json",
          "X-Api-Key": "t1h3m5p7v9711713d15617f19"
        },
        body: jsonEncode({
          "active": 0,
        }),
      );
      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  Future<bool> deleteRequestX(int id) async {
    try {
      final response = await client.delete(
        "$baseUrl/rx/$id",
        headers: {
          "content-type": "application/json",
          "X-Api-Key": "t1h3m5p7v9711713d15617f19"
        },
      );
      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  Future<String> countRequestX() async {
    try {
      final response = await client.get(
        "$baseUrl/rxc",
        headers: {
          "content-type": "application/json",
          "X-Api-Key": "t1h3m5p7v9711713d15617f19"
        },
      );

      if (response.statusCode == 200) {
        return response.body;
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }
}
