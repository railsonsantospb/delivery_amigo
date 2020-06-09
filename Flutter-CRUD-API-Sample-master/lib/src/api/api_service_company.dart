
import 'dart:convert';
import 'package:flutter_crud_api_sample_app/src/model/company.dart';
import 'package:http/http.dart' show Client;


class ApiServiceCop {
  final String baseUrl = "http://192.168.1.17:5000";
  Client client = Client();


  Future<List<Company>> getCop() async {

    try{
      final response = await client.get("$baseUrl/cop",
        headers: {"content-type": "application/json", "X-Api-Key": "t1h3m5p7v9711713d15617f19"},);
      if (response.statusCode == 200) {
        return compFromJson(response.body);
      } else {
        return null;
      }
    } catch(e){

      return compFromJson('[{"id": ${0}, "name": "0", "image": ${base64Decode("0")}, "city": "0", "category": "0", "cpf_cnpj": "0", "owner": "0",'
          ' "address": "0", "lat": "0", "lon": "0", "password": "0"}]');
    }

  }


  Future<List<Company>> getCopCpf(String cpf) async {

    try{
      final response = await client.get("$baseUrl/cop/${cpf}",
        headers: {"content-type": "application/json", "X-Api-Key": "t1h3m5p7v9711713d15617f19"},);
      if (response.statusCode == 200) {
        return compFromJson(response.body);
      } else {
        return null;
      }
    } catch(e){

      return compFromJson('[{"id": ${0}, "name": "0", "image": "0", "city": "0", "category": "0", "cpf_cnpj": "0", "owner": "0",'
          ' "address": "0", "lat": "0", "lon": "0", "password": "0"}]');
    }

  }

  Future<bool> createCop(Company data) async {

    try{
      final response = await client.post(
        "$baseUrl/cop",
        headers: {"content-type": "application/json", "X-Api-Key": "t1h3m5p7v9711713d15617f19"},
        body: jsonEncode({"name": data.name, "image": data.image, "city": data.city,
          "category": data.category, "cpf_cnpj": data.cpf_cnpj, "phone": data.phone,
          "owner": data.owner, "address": data.address, "lat": data.lat, "lon": data.lon, "password": data.password}),
      );

      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    }catch (e){
      return false;
    }

  }

  Future<bool> updateCop(Company data) async {

    try{
      final response = await client.put(
        "$baseUrl/prod/${data.id}",
        headers: {"content-type": "application/json", "X-Api-Key": "t1h3m5p7v9711713d15617f19"},
        body: jsonEncode({"name": data.name, "image": data.image, "city": data.city,
          "category": data.category, "cpf_cnpj": data.cpf_cnpj,
          "owner": data.owner, "address": data.address, "lat": data.lat, "lon": data.lon, "password": data.password}),
      );
      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (e){
      return false;
    }

  }

  Future<bool> deleteCop(int id) async {

    try{
      final response = await client.delete(
        "$baseUrl/cop/$id", headers: {"content-type": "application/json", "X-Api-Key": "t1h3m5p7v9711713d15617f19"},
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
}
