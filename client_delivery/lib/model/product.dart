import 'dart:convert';

class Product {
  int id;
  String name;
  String mark;
  int active;
  String price;
  String info;
  String image;
  int cat_id;

  Product({this.id = 0, this.name, this.mark, this.active, this.price, this.info,
    this.image, this.cat_id});

  factory Product.fromJson(Map<String, dynamic> map) {
    return Product(
        id: map["id"], name: map["name"], price: map["price"],
        mark: map["mark"], active: map["active"], info: map["info"],
        image: map["image"], cat_id: map["cat_id"]);
  }

  Map<String, dynamic> toJson() {
    return {"id": id, "name": name, "mark": mark, "active": active, "price": price, "info": info,
      "image": image, "cat_id": cat_id};
  }

  @override
  String toString() {
    return 'Profile{id: $id, name: $name, mark: $mark, active: $active, price: $price, info: $info, '
        'image: $image, cat_id: $cat_id}';
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
