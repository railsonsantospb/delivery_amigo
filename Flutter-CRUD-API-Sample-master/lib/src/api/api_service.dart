
import 'package:dio/dio.dart';
import 'package:flutter_crud_api_sample_app/src/model/category.dart';
import 'package:http/http.dart' show Client;

class ApiService {
  final String baseUrl = "http://192.168.1.17:5000";
  Client client = Client();

  Future<List<Category>> getCategory() async {

    final response = await client.get("$baseUrl/cat");

    if (response.statusCode == 200) {
      return catFromJson(response.body);
    } else {
      return null;
    }
  }

  Future<bool> createCategory(Category data) async {

    FormData d = FormData.fromMap({
      "image": data.image,
      "name": data.name,
      "id": data.id,
    });

    Dio dio = new Dio();

    dio.post("$baseUrl/cat", data: d)
        .then((response) => () {
          print(response);
        }
    )
        .catchError((error) => print(error));

    if(data != null){
        return true;
    } else {
      return false;
    }


  }

  Future<bool> updateCategory(Category data) async {

    FormData d = FormData.fromMap({
      "image": data.image,
      "name": data.name,
    });

    Dio dio = new Dio();

    dio.put("$baseUrl/cat/${data.id}", data: d)
        .then((response) => () {
      print(response);
    }
    )
        .catchError((error) => print(error));

    if(data != null){

      return true;
    } else {
      return false;
    }


  }

  Future<bool> deleteCategory(String id) async {

    final response = await client.delete(
      "$baseUrl/cat/$id",
    );
    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }
}
