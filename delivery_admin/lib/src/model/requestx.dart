import 'dart:convert';

class RequestX {
  int id;
  String client;
  int active;
  String price_full;
  String products;
  String date;
  String address;
  String lat;
  String lon;
  String email;
  String phone;
  String pay;
  String obs;

  RequestX(
      {this.id = 0,
      this.client,
      this.active,
      this.price_full,
      this.products,
      this.date,
      this.address,
      this.lat,
      this.lon,
      this.email,
      this.phone,
      this.pay,
      this.obs});

  factory RequestX.fromJson(Map<String, dynamic> map) {
    return RequestX(
        id: map["id"],
        client: map["client"],
        active: map["active"],
        price_full: map["price_full"],
        products: map["products"],
        date: map["date"],
        address: map['address'],
        lat: map["lat"],
        lon: map['lon'],
        email: map['email'],
        phone: map['phone'],
        pay: map['pay'],
        obs: map['obs']);
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "client": client,
      "active": active,
      "price_full": price_full,
      "products": products,
      "date": date,
      "address": address,
      "lat": lat,
      "lon": lon,
      "email": email,
      "phone": phone,
      "pay": pay,
      "obs": obs
    };
  }

  @override
  String toString() {
    return 'RequestX{id: $id, client: $client, active: $active, price_full: $price_full, products: $products, '
        ' date: $date, address: $address, lat: $lat, lon: $lon, email: $email, phone: $phone, pay: $pay, obs: $obs';
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
