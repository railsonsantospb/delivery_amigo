import 'dart:convert';

class RequestX {
  int id;
  String client;
  String price_full;
  String products;
  String date;
  String address;
  String lat;
  String lon;
  String email;

  RequestX({this.id = 0, this.client, this.price_full, this.products, this.date,
    this.address, this.lat, this.lon, this.email});

  factory RequestX.fromJson(Map<String, dynamic> map) {
    return RequestX(
        id: map["id"], client: map["client"], price_full: map["price_full"],
        products: map["products"], date: map["date"], address: map['address'],
        lat: map["lat"], lon: map['lon'], email: map['email']);
  }


  Map<String, dynamic> toJson() {
    return {"id": id, "client": client, "price_full": price_full, "products": products,
      "date": date, "address": address, "lat": lat, "lon": lon, "email": email};
  }

  @override
  String toString() {
    return 'Profile{id: $id, client: $client, price_full: $price_full, products: $products, '
        ' date: $date, address: $address, lat: $lat, lon: $lon, email: $email';
  }

}

List<RequestX> rxFromJson(String jsonData) {
  final data = json.decode(jsonData);
  return List<RequestX>.from(data.map((item) => RequestX.fromJson(item)));
}

String rxToJson(RequestX data) {
  final jsonData = data.toJson();
  return json.encode(jsonData);
}
