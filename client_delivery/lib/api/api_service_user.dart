import 'dart:convert';

import 'package:http/http.dart' show Client;
import 'package:amigodelivery/model/user.dart';

class ApiServiceUser {
  final String baseUrl = "https://apibebidas.herokuapp.com";
  // final String baseUrl = "http://192.168.1.32:5000";
  Client client = Client();

  Future<List<User>> getUserEmail(String email) async {
    try {
      final response = await client.get(
        "$baseUrl/user/${email}",
        headers: {
          "content-type": "application/json",
          "X-Api-Key": "t1h3m5p7v9711713d15617f19"
        },
      );

      if (response.statusCode == 200) {
        return userFromJson(response.body);
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  Future<bool> createUser(User data) async {
    try {
      final response = await client.post(
        "$baseUrl/user",
        headers: {
          "content-type": "application/json",
          "X-Api-Key": "t1h3m5p7v9711713d15617f19"
        },
        body: jsonEncode({
          "email": data.email,
          "name": data.name,
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

  Future<bool> updateUser(User data) async {
    try {
      final response = await client.put(
        "$baseUrl/user/${data.email}",
        headers: {
          "content-type": "application/json",
          "X-Api-Key": "t1h3m5p7v9711713d15617f19"
        },
        body: jsonEncode({
          "email": data.email,
          "name": data.name,
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

  Future<bool> deleteUser(String email) async {
    try {
      final response = await client.delete(
        "$baseUrl/user/$email",
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
