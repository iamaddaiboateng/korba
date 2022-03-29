import 'package:get/get.dart';

import '../../../core/utils/const_strings.dart';

class AccountModel {
  String name, email;
  String? token, password;
  int? id;

  AccountModel(
      {required this.name,
      required this.email,
      this.password,
      this.id,
      this.token});

  factory AccountModel.fromJson(Map<String, dynamic> json) => AccountModel(
        name: json['Name'],
        email: json['Email'],
        id: json["Id"],
        token: json["Token"],
      );

  Map<String, dynamic> toJson() => {
        kName: name,
        kEmail: email,
        kPassword: password,
        kId: id,
        kToken: token,
      };
}
