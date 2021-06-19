import 'dart:convert';

class ProductCart {
  int id;
  String name;
  String mark;
  String price;
  String info;
  String image;
  String email;
  String id_cop;
  int qtd;

  ProductCart(
      {this.id = 0,
      this.name,
      this.mark,
      this.price,
      this.info,
      this.image,
      this.email,
      this.id_cop,
      this.qtd});

  factory ProductCart.fromJson(Map<String, dynamic> map) {
    return ProductCart(
        id: map["id"],
        name: map["name"],
        price: map["price"],
        mark: map["mark"],
        info: map["info"],
        image: map["image"],
        email: map["email"],
        id_cop: map["id_cop"],
        qtd: map["qtd"]);
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "name": name,
      "mark": mark,
      "price": price,
      "info": info,
      "image": image,
      "email": email,
      "id_cop": id_cop,
      "qtd": qtd
    };
  }

  @override
  String toString() {
    return 'ProductCart{id: $id, name: $name, mark: $mark, price: $price, info: $info, '
        'image: $image, email: $email, id_cop: $id_cop, qtd: $qtd}';
  }
}

List<ProductCart> prodFromJsonCart(String jsonData) {
  final data = json.decode(jsonData);
  return List<ProductCart>.from(data.map((item) => ProductCart.fromJson(item)));
}

String prodToJsonCart(ProductCart data) {
  final jsonData = data.toJson();
  return json.encode(jsonData);
}
