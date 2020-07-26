import 'dart:convert';

class CategoryR {
  int id;
  String name;
  String image;
  String id_cpf;

  CategoryR({this.id = 0, this.name, this.image, this.id_cpf});

  factory CategoryR.fromJson(Map<String, dynamic> map) {
    return CategoryR(
        id: map["id"],
        name: map["name"],
        image: map["image"],
        id_cpf: map['id_cpf']);
  }

  Map<String, dynamic> toJson() {
    return {"id": id, "name": name, "image": image, "id_cpf": id_cpf};
  }

  @override
  String toString() {
    return 'Category{id: $id, name: $name, image: $image, id_cat: $id_cpf}';
  }
}

List<CategoryR> catFromJson(String jsonData) {
  final data = json.decode(jsonData);
  return List<CategoryR>.from(data.map((item) => CategoryR.fromJson(item)));
}

String catToJson(CategoryR data) {
  final jsonData = data.toJson();
  return json.encode(jsonData);
}
