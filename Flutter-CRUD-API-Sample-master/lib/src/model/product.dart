import 'dart:convert';

class Product {
  int id;
  String name;
  String preco;
  String state;
  String active;
  String category;
  String image;

  Product({this.id = 0, this.name, this.preco, this.state, this.active, this.category,
    this.image});

  factory Product.fromJson(Map<String, dynamic> map) {
    return Product(
        id: map["id"], name: map["name"], preco: map["preco"],
        state: map["state"], active: map["active"], category: map["category"],
        image: map["image"]);
  }

  Map<String, dynamic> toJson() {
    return {"id": id, "name": name, "preco": preco, "state": state,
      "active": active, "category": category, "image": image};
  }

  @override
  String toString() {
    return 'Profile{id: $id, name: $name, preco: $preco, state: $state, '
        ' active: $active, category: $category, image: $image}';
  }

}

List<Product> profileFromJson(String jsonData) {
  final data = json.decode(jsonData);
  return List<Product>.from(data.map((item) => Product.fromJson(item)));
}

String profileToJson(Product data) {
  final jsonData = data.toJson();
  return json.encode(jsonData);
}
