import 'dart:convert';

class Company {

  int id;
  String name;
  String image;
  String city;
  String category;
  String cpf_cnpj;
  String phone;
  String owner;
  String address;
  String lat;
  String lon;
  String password;
  String rating;

  Company({this.id = 0, this.name, this.image, this.city, this.category, this.cpf_cnpj,
    this.phone, this.owner, this.address, this.lat, this.lon, this.password, this.rating});

  factory Company.fromJson(Map<String, dynamic> map) {
    return Company(
        id: map["id"], name: map["name"], image: map["image"], city: map["city"], category: map["category"],
        cpf_cnpj: map["cpf_cnpj"], phone: map['phone'], owner: map["owner"], address: map["address"],
        lat: map['lat'], lon: map['lon'], password: map['password'], rating: map["rating"]);
  }

  Map<String, dynamic> toJson() {
    return {"id": id, "name": name, "image": image, "city": city, "category": category,
      "cpf_cnpj": cpf_cnpj, "phone": phone, "owner": owner,  "address": address, "lat": lat, "lon": lon, "password": password};
  }

  @override
  String toString() {
    return 'Category{id: $id, name: $name, image: $image, city: $city, category: $category, '
        'cpf_cnpj: $cpf_cnpj, phone: $phone, owner: $owner,  address: $address, lat: $lat, lon: $lon password: $password}';
  }

}

List<Company> compFromJson(String jsonData) {
  final data = json.decode(jsonData);
  return List<Company>.from(data.map((item) => Company.fromJson(item)));
}

String comToJson(Company data) {
  final jsonData = data.toJson();
  return json.encode(jsonData);
}
