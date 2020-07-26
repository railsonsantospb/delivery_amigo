import 'dart:convert';
import 'package:http/http.dart' show Client;
import 'package:amigodelivery/model/requestx.dart';

class ApiServiceRX {
  final String baseUrl = "https://apibebidas.herokuapp.com";
  // final String baseUrl = "http://192.168.1.32:5000";
  Client client = Client();

  Future<List<RequestX>> getRequestXActive(String email, int id) async {
    try {
      final response = await client.get(
        "$baseUrl/rxtc/$email/$id",
        headers: {
          "content-type": "application/json",
          "X-Api-Key": "t1h3m5p7v9711713d15617f19"
        },
      );

      if (response.statusCode == 200) {
        return rxFromJson(response.body);
      } else {
        return null;
      }
    } catch (e) {
      return rxFromJson(
          '[{"id": ${0}, "client": "1", "active": ${2}, "price_full": "1", '
          '"products": "1", "date": "1", "address": "1", "lat": "1", "lon": "1", "email": "1", "phone": "0", "pay": "0", "obs": "0"}]');
    }
  }

  Future<List<RequestX>> getRequestXNotActive() async {
    try {
      final response = await client.get(
        "$baseUrl/rxf",
        headers: {
          "content-type": "application/json",
          "X-Api-Key": "t1h3m5p7v9711713d15617f19"
        },
      );
      if (response.statusCode == 200) {
        return rxFromJson(response.body);
      } else {
        return null;
      }
    } catch (e) {
      return rxFromJson(
          '[{"id": ${0}, "client": "1", "active": ${2}, "price_full": "1", '
          '"products": "1", "date": "1", "address": "1", "lat": "1", "lon": "1", "email": "1", "pay": "0", "obs": "0"}]');
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
          "city": rx.city,
          "active": rx.active,
          "price_full": rx.price_full,
          "products": rx.products,
          "address": rx.address,
          "lat": rx.lat,
          "lon": rx.lon,
          "email": rx.email,
          "phone": rx.phone,
          "id_cop": rx.id_cop,
          "pay": rx.pay,
          "obs": rx.obs
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
          "id": rx.id,
          "client": rx.client,
          "active": 0,
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
