import 'dart:convert';

class User {

  String email;
  String name;
  String password;

 User({this.email, this.name, this.password});

  factory User.fromJson(Map<String, dynamic> map) {
    return User(
        email: map["email"], name: map["name"], password: map["password"]);
  }

  Map<String, dynamic> toJson() {
    return {"email": email, "name": name, "password": password};
  }

  @override
  String toString() {
    return 'User{email: $email, name: $name, password: $password}';
  }

}

List<User> userFromJson(String jsonData) {
  final data = json.decode(jsonData);
  return List<User>.from(data.map((item) => User.fromJson(item)));
}

String userToJson(User data) {
  final jsonData = data.toJson();
  return json.encode(jsonData);
}
