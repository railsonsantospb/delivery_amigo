import 'dart:convert';

class Profile {
  int id;
  String name;
  String email;
  int age;
  String image;

  Profile({this.id = 0, this.name, this.email, this.age, this.image});

  factory Profile.fromJson(Map<String, dynamic> map) {
    return Profile(
        id: map["id"], name: map["name"], email: map["email"], age: map["age"], image: map["image"]);
  }

  Map<String, dynamic> toJson() {
    return {"id": id, "name": name, "email": email, "age": age, "image": image};
  }

  @override
  String toString() {
    return 'Profile{id: $id, name: $name, email: $email, age: $age, image: $image}';
  }

}

List<Profile> profileFromJson(String jsonData) {
  final data = json.decode(jsonData);
  return List<Profile>.from(data.map((item) => Profile.fromJson(item)));
}

String profileToJson(Profile data) {
  final jsonData = data.toJson();
  return json.encode(jsonData);
}
