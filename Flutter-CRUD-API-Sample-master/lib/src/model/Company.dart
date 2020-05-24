import 'dart:convert';

class Company {

  int id;
  String name;
  String image;
  String category;
  String cpf_cnpj;
  String owner;
  String address;

  Company({this.id = 0, this.name, this.image, this.category, this.cpf_cnpj, this.owner, this.address});

  factory Company.fromJson(Map<String, dynamic> map) {
    return Company(
        id: map["id"], name: map["name"], image: map["image"], category: map["category"],
        cpf_cnpj: map["cpf_cnpj"], owner: map["owner"], address: map["address"]);
  }

  Map<String, dynamic> toJson() {
    return {"id": id, "name": name, "image": image, "category": category,
      "cpf_cnpj": cpf_cnpj, "owner": owner,  "address": address};
  }

  @override
  String toString() {
    return 'Category{id: $id, name: $name, image: $image, category: $category, '
        'cpf_cnpj: $cpf_cnpj, owner: $owner,  address: $address}';
  }

}

List<Company> catFromJson(String jsonData) {
  final data = json.decode(jsonData);
  return List<Company>.from(data.map((item) => Company.fromJson(item)));
}

String catToJson(Company data) {
  final jsonData = data.toJson();
  return json.encode(jsonData);
}
