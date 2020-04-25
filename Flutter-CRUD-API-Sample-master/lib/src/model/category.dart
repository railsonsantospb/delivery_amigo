import 'dart:convert';

class Category {

  String id;
  String name;
  String image;

  Category({this.id, this.name, this.image});

  factory Category.fromJson(Map<String, dynamic> map) {
    return Category(
        id: map["id"], name: map["name"], image: map["image"]);
  }

  Map<String, dynamic> toJson() {
    return {"id": id, "name": name, "image": image};
  }

  @override
  String toString() {
    return 'Category{id: $id, name: $name, image: $image}';
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
