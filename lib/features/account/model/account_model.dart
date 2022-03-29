import '../../../core/utils/const_strings.dart';

class AccountModel {
  String name, email, password;
  String? token;
  int? id;

  AccountModel(
      {required this.name,
      required this.email,
      required this.password,
      this.id,
      this.token});

  factory AccountModel.fromJson(Map<String, dynamic> json) => AccountModel(
        name: json[kName],
        email: json[kEmail],
        password: json[kPassword],
        id: json[kId],
        token: json[kToken],
      );

  Map<String, dynamic> toJson() => {
        kName: name,
        kEmail: email,
        kPassword: password,
      };
}
