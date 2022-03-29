import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:korda/core/utils/api_strings.dart';
import 'package:korda/core/utils/notifications.dart';
import 'package:korda/features/account/model/account_model.dart';
import 'package:korda/features/users/view/users_list.dart';

class AccountController extends GetConnect with ChangeNotifier {
  // bool to check progress
  bool inProgress = false;

  // signed in user account
  AccountModel? accountModel;

  // sign up
  Future<void> signUp(AccountModel accountModel) async {
    inProgress = true;
    notifyListeners();

    try {
      final response = await post(ApiStrings.signUp, accountModel.toJson());

      final body = response.body;

      if (response.isOk) {
        // final accountBox = await Hive.openBox<AccountModel>(kAccountBox);
        // accountBox.put(kAccountBox, accountModel);

        // check code from response
        if (body['code'] == 0) {
          inProgress = false;
          accountModel = AccountModel.fromJson(body['data']);

          notifyListeners();
          Get.offAll(() => const UsersList());
          successNotification('Account created successfully');
        } else {
          errorNotification('${body['message']}');
          inProgress = false;
          notifyListeners();
        }
      } else {
        inProgress = false;
        notifyListeners();

        errorNotification('${body['message']}');
      }
    } catch (e) {
      inProgress = false;

      notifyListeners();
      errorNotification('An error occurred');
    }
  }

  // log in
  Future<void> logIn(AccountModel accountModel) async {
    inProgress = true;
    notifyListeners();

    try {
      final response = await post(ApiStrings.logIn, accountModel.toJson());

      final body = response.body;
      print("response body $body");

      if (response.isOk) {
        // final accountBox = await Hive.openBox<AccountModel>(kAccountBox);
        // accountBox.put(kAccountBox, accountModel);

        // check code from response
        if (body['code'] == 0) {
          inProgress = false;
          accountModel = AccountModel.fromJson(body["data"]);
          notifyListeners();
          Get.offAll(() => const UsersList());
          successNotification('Log in was successful');
        } else {
          errorNotification('${body['message']}');
          inProgress = false;
          notifyListeners();
        }
      } else {
        inProgress = false;
        notifyListeners();

        errorNotification('${body['message']}');
      }
    } catch (e) {
      inProgress = false;
      print("Error from account creation $e");
      notifyListeners();
      errorNotification('An error occurred');
    }
  }
}
