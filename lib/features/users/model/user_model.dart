import 'package:korda/core/utils/const_strings.dart';

class User {
  String name, email, location;
  String? imageUrl;
  int? id;
  User(
      {required this.name,
      required this.email,
      required this.location,
      this.imageUrl,
      this.id});

  factory User.fromJson(Map<String, dynamic> json) => User(
      name: json[kName],
      email: json[kEmail],
      location: json[kLocation],
      imageUrl: json[kImageUrl],
      id: json[kId]);

  Map<String, dynamic> toJson() => {
        kName: name,
        kEmail: email,
        kLocation: location,
        // kId: id,
      };

      // create user model to json with id 
  Map<String, dynamic> toJsonWithId() => {
        kName: name,
        kEmail: email,
        kLocation: location,
        kId: id,
      };
}
