import 'dart:convert';

class Product {
  int id;
  String name;
  String price;
  String state;
  String category;
  String image;

  Product({this.id = 0, this.name, this.price, this.state, this.category,
    this.image});

  factory Product.fromJson(Map<String, dynamic> map) {
    return Product(
        id: map["id"], name: map["name"], price: map["preco"],
        state: map["state"], category: map["category"],
        image: map["image"]);
  }

  Map<String, dynamic> toJson() {
    return {"id": id, "name": name, "preco": price, "state": state,
      "category": category, "image": image};
  }

  @override
  String toString() {
    return 'Profile{id: $id, name: $name, preco: $price, state: $state, '
        ' category: $category, image: $image}';
  }

}

List<Product> prodFromJson(String jsonData) {
  final data = json.decode(jsonData);
  return List<Product>.from(data.map((item) => Product.fromJson(item)));
}

String prodToJson(Product data) {
  final jsonData = data.toJson();
  return json.encode(jsonData);
}
