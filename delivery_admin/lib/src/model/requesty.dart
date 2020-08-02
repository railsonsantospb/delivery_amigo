import 'dart:convert';

class RequestY {
  int id;
  String client;
  String email;
  String copName;

  RequestY({this.id = 0, this.client, this.email, this.copName});

  factory RequestY.fromJson(Map<String, dynamic> map) {
    return RequestY(
        id: map["id"],
        client: map["client"],
        email: map['email'],
        copName: map['copName']);
  }

  Map<String, dynamic> toJson() {
    return {"id": id, "client": client, "email": email, "copName": copName};
  }

  @override
  String toString() {
    return 'RequestY{id: $id, client: $client,  email: $email, copName: $copName';
  }
}

List<RequestY> ryFromJson(String jsonData) {
  final data = json.decode(jsonData);
  return List<RequestY>.from(data.map((item) => RequestY.fromJson(item)));
}

String ryToJson(RequestY data) {
  final jsonData = data.toJson();
  return json.encode(jsonData);
}
