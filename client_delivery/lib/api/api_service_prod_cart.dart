import 'dart:convert';
import 'package:http/http.dart' show Client;
import 'package:amigodelivery/model/product_cart.dart';

class ApiServiceProdCart {
  final String baseUrl = "https://apibebidas.herokuapp.com";
  // final String baseUrl = "http://192.168.1.32:5000";
  Client client = Client();

  Future<List<ProductCart>> getProductId(String email, int id) async {
    try {
      final response = await client.get(
        "$baseUrl/prod_cart/${email}/${id}",
        headers: {
          "content-type": "application/json",
          "X-Api-Key": "t1h3m5p7v9711713d15617f19"
        },
      );
      if (response.statusCode == 200) {
        return prodFromJsonCart(response.body);
      } else {
        return null;
      }
    } catch (e) {
      return prodFromJsonCart(
          '[{"id": ${0}, "name": "0", "mark": "0", "price": "0", "info": "0",'
          ' "image": ${base64Decode("0")}, "email": "0", "company": "0", "id_cop": "0", "qtd": "0"]');
    }
  }

  Future<bool> createProduct(ProductCart data) async {
    try {
      final response = await client.post(
        "$baseUrl/prod_cart",
        headers: {
          "content-type": "application/json",
          "X-Api-Key": "t1h3m5p7v9711713d15617f19"
        },
        body: jsonEncode({
          "name": data.name,
          "mark": data.mark,
          "price": data.price,
          "info": data.info,
          "image": data.image,
          "email": data.email,
          "company": data.id
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

  Future<bool> updateCart(int id, int qtd) async {
    try {
      final response = await client.put(
        "$baseUrl/prod_cart/$id",
        headers: {
          "content-type": "application/json",
          "X-Api-Key": "t1h3m5p7v9711713d15617f19"
        },
        body: jsonEncode({"qtd": qtd}),
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
        "$baseUrl/prod_cart/$id",
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

  Future<String> countCart(String email, int id) async {
    try {
      final response = await client.get(
        "$baseUrl/prod_cart_c/$email/$id",
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
