import 'package:korda/core/utils/const_strings.dart';

class User {
  String name, email, location;
  User({
    required this.name,
    required this.email,
    required this.location,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
        name: json[kName],
        email: json[kEmail],
        location: json[kLocation],
      );

  Map<String, dynamic> toJson() => {
        kName: name,
        kEmail: email,
        kLocation: location,
      };
}
