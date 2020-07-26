import 'dart:convert';
import 'package:http/http.dart' show Client;
import 'package:amigodelivery/model/product.dart';

class ApiServiceProd {
  final String baseUrl = "https://apibebidas.herokuapp.com";
  // final String baseUrl = "http://192.168.1.32:5000";
  Client client = Client();

  Future<List<Product>> getProductId(int id) async {
    try {
      final response = await client.get(
        "$baseUrl/prod_c/${id}",
        headers: {
          "content-type": "application/json",
          "X-Api-Key": "t1h3m5p7v9711713d15617f19"
        },
      );
      if (response.statusCode == 200) {
        return prodFromJson(response.body);
      } else {
        return null;
      }
    } catch (e) {
      return prodFromJson(
          '[{"id": ${0}, "name": "0", "mark": "0", "active": ${0}, "price": "0", "info": "0",'
          ' "image": ${base64Decode("0")}, "cat_id": ${0}]');
    }
  }

  Future<List<Product>> getProductIdAll(int id) async {
    try {
      final response = await client.get(
        "$baseUrl/prod_a/${id}",
        headers: {
          "content-type": "application/json",
          "X-Api-Key": "t1h3m5p7v9711713d15617f19"
        },
      );
      if (response.statusCode == 200) {
        return prodFromJson(response.body);
      } else {
        return null;
      }
    } catch (e) {
      return prodFromJson(
          '[{"id": ${0}, "name": "0", "mark": "0", "active": ${0}, "price": "0", "info": "0",'
          ' "image": ${base64Decode("0")}, "cat_id": ${0}]');
    }
  }

  Future<List<Product>> getProduct(String cpf) async {
    try {
      final response = await client.get(
        "$baseUrl/prod_all/${cpf}",
        headers: {
          "content-type": "application/json",
          "X-Api-Key": "t1h3m5p7v9711713d15617f19"
        },
      );
      if (response.statusCode == 200) {
        return prodFromJson(response.body);
      } else {
        return null;
      }
    } catch (e) {
      return prodFromJson(
          '[{"id": ${0}, "name": "0", "mark": "0", "active": ${0}, "price": "0", "info": "0",'
          ' "image": ${base64Decode("0")}, "cat_id": ${0}]');
    }
  }

  Future<bool> createProduct(Product data) async {
    try {
      final response = await client.post(
        "$baseUrl/prod",
        headers: {
          "content-type": "application/json",
          "X-Api-Key": "t1h3m5p7v9711713d15617f19"
        },
        body: jsonEncode({
          "name": data.name,
          "mark": data.mark,
          "active": data.active,
          "price": data.price,
          "info": data.info,
          "image": data.image,
          "cat_id": data.cat_id
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

  Future<bool> updateProduct(Product data) async {
    try {
      final response = await client.put(
        "$baseUrl/prod/${data.id}",
        headers: {
          "content-type": "application/json",
          "X-Api-Key": "t1h3m5p7v9711713d15617f19"
        },
        body: jsonEncode({
          "name": data.name,
          "mark": data.mark,
          "active": data.active,
          "price": data.price,
          "info": data.info,
          "image": data.image,
          "cat_id": data.cat_id
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

  Future<bool> deleteProduct(int id) async {
    try {
      final response = await client.delete(
        "$baseUrl/prod/$id",
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
