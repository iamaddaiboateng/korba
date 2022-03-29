import 'package:flutter/material.dart';
import 'package:get/get_connect.dart';
import 'package:korda/core/utils/api_strings.dart';
import 'package:korda/core/utils/notifications.dart';
import 'package:korda/features/account/model/account_model.dart';

class AccountController extends GetConnect with ChangeNotifier {
  // bool to check progress
  bool inProgress = false;

  // sign up
  Future<void> signUp(AccountModel accountModel) async {
    try {
      final response = await post(ApiStrings.signUp, accountModel.toJson());

      if (response.isOk) {
        // final accountBox = await Hive.openBox<AccountModel>(kAccountBox);
        // accountBox.put(kAccountBox, accountModel);

        successNotification('Account created successfully');
      } else {
        errorNotification('An error occurred');
      }
    } catch (e) {
      inProgress = false;
      notifyListeners();
      errorNotification('An error occurred');
    }
  }
}
