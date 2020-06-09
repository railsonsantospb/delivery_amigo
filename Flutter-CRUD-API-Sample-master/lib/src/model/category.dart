import 'dart:convert';

class Category {

  int id;
  String name;
  String image;
  String id_cat;

  Category({this.id = 0, this.name, this.image, this.id_cat});

  factory Category.fromJson(Map<String, dynamic> map) {
    return Category(
        id: map["id"], name: map["name"], image: map["image"], id_cat: map['id_cat']);
  }

  Map<String, dynamic> toJson() {
    return {"id": id, "name": name, "image": image, "id_cat": id_cat};
  }

  @override
  String toString() {
    return 'Category{id: $id, name: $name, image: $image, id_cat: $id_cat}';
  }

}

List<Category> catFromJson(String jsonData) {
  final data = json.decode(jsonData);
  return List<Category>.from(data.map((item) => Category.fromJson(item)));
}

String catToJson(Category data) {
  final jsonData = data.toJson();
  return json.encode(jsonData);
}
