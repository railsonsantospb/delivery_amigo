import 'dart:convert';
import 'package:http/http.dart' show Client;
import 'package:amigodelivery/model/company.dart';

class ApiServiceCop {
  final String baseUrl = "https://apibebidas.herokuapp.com";
  // final String baseUrl = "http://192.168.1.32:5000";
  Client client = Client();

  Future<List<Company>> getCop() async {
    try {
      final response = await client.get(
        "$baseUrl/cop",
        headers: {
          "content-type": "application/json",
          "X-Api-Key": "t1h3m5p7v9711713d15617f19"
        },
      );
      if (response.statusCode == 200) {
        return compFromJson(response.body);
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  Future<List<Company>> getCopCpf(String cpf) async {
    try {
      final response = await client.get(
        "$baseUrl/cop/$cpf",
        headers: {
          "content-type": "application/json",
          "X-Api-Key": "t1h3m5p7v9711713d15617f19"
        },
      );
      if (response.statusCode == 200) {
        return compFromJson(response.body);
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  Future<bool> createCop(Company data) async {
    try {
      final response = await client.post(
        "$baseUrl/cop",
        headers: {
          "content-type": "application/json",
          "X-Api-Key": "t1h3m5p7v9711713d15617f19"
        },
        body: jsonEncode({
          "name": data.name,
          "image": data.image,
          "city": data.city,
          "category": data.category,
          "cpf_cnpj": data.cpf_cnpj,
          "phone": data.phone,
          "owner": data.owner,
          "address": data.address,
          "lat": data.lat,
          "lon": data.lon,
          "password": data.password
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

  Future<bool> updateCop(Company data) async {
    try {
      final response = await client.put(
        "$baseUrl/cop/${data.id}",
        headers: {
          "content-type": "application/json",
          "X-Api-Key": "t1h3m5p7v9711713d15617f19"
        },
        body: jsonEncode({
          "name": data.name,
          "image": data.image,
          "city": data.city,
          "category": data.category,
          "phone": data.phone,
          "owner": data.owner,
          "address": data.address,
          "lat": data.lat,
          "lon": data.lon,
          "password": data.password
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

  Future<bool> updateCopRating(int id, String rating) async {
    try {
      final response = await client.put(
        "$baseUrl/cop_r/$id",
        headers: {
          "content-type": "application/json",
          "X-Api-Key": "t1h3m5p7v9711713d15617f19"
        },
        body: jsonEncode({
          "rating": rating,
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

  Future<bool> deleteCop(int id) async {
    try {
      final response = await client.delete(
        "$baseUrl/cop/$id",
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
}
