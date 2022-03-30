import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:korda/core/utils/hive_strings.dart';
import 'package:korda/features/account/controller/account_controller.dart';
import 'package:korda/features/account/model/account_model.dart';
import 'package:korda/features/users/model/user_model.dart';
import 'package:korda/features/users/view/users_list.dart';
import 'package:provider/provider.dart';

import '../../../core/utils/api_strings.dart';
import '../../../core/utils/notifications.dart';

class UserController extends GetConnect with ChangeNotifier {
// progress indicator
  bool inProgress = false;

  List<User> users = [];

  // selected user variable
  User? selectedUser;

  // get hive all users box
  final usersBox = Hive.box(kHiveAllUsers);

  // create a function that sets the selected user
  setSelectedUser(User newUser) {
    selectedUser = newUser;
    notifyListeners();
  }

  // remove deleted user from the list
  removeUser(User user) {
    users.removeAt(users.indexOf(user));
    notifyListeners();
  }

  //  get log in user details from AccountController
  AccountModel? accountModel = Provider.of<AccountController>(
    Get.context!,
    listen: false,
  ).newAccountModel;

  // create a user
  Future<void> createUser(User user) async {
    inProgress = true;
    notifyListeners();

    try {
      final response = await post(ApiStrings.users, user.toJson(), headers: {
        'authorization': 'Bearer ${accountModel?.token}',
      });

      final body = response.body;

      print("body from create user: $body");

      inProgress = false;
      notifyListeners();

      if (response.statusCode == 201) {
        // check code from response

        // final userBox = await Hive.openBox<User>(kUserBox);
        // userBox.put(kUserBox, user);
        Get.back();
        successNotification('User created successfully');
      } else {
        errorNotification('$body');
      }
    } catch (e) {
      inProgress = false;
      notifyListeners();
      errorNotification('An error occurred $e', duration: 5);
    }
  }

  // get all users
  Future<void> getAllUsers() async {
    inProgress = true;
    // notifyListeners();

    var lastPage = Hive.box(kHiveLastRequestPage).get(kHiveLastRequestPage);

    if (lastPage == null) {
      lastPage = 1;
      Hive.box(kHiveLastRequestPage).put(kHiveLastRequestPage, lastPage);
    } else {
      lastPage++;
      Hive.box(kHiveLastRequestPage).put(kHiveLastRequestPage, lastPage);
    }

    try {
      final response =
          await get("${ApiStrings.users}?page=$lastPage", headers: {
        'authorization': 'Bearer ${accountModel?.token}',
      });

      // if (lastPage >= int.parse(response.body['total_pages'])) {
      //   Hive.box(kHiveLastRequestPage).put(kHiveLastRequestPage, lastPage + 1);
      // }

      final body = response.body;

      inProgress = false;
      notifyListeners();

      if (response.statusCode == 200) {
        for (var user in body['data']) {
          // print("user ${user['name']}");
          User newUser = User.fromJson(user);
          usersBox.put(newUser.id, newUser.toJsonWithId());
        }
        notifyListeners();

        // successNotification('User created successfully');
      } else {
        errorNotification('$body');
      }
    } catch (e) {
      inProgress = false;
      notifyListeners();
      errorNotification('An error occurred $e', duration: 5);
    }
  }

  // get particular user
  // create a function to get a particular user by id

  getParticularUser() async {
    try {
      final response =
          await get("${ApiStrings.users}${selectedUser!.id}", headers: {
        'authorization': 'Bearer ${accountModel?.token}',
      });

      final body = response.body;

      if (response.statusCode == 200) {
        selectedUser = User.fromJson(body);
      } else if (response.statusCode == 401) {
        // errorNotification('You are not authorized to delete this user');
        Get.defaultDialog(
          title: 'You are not authorized to delete this user',
          middleText: 'You are not authorized to delete this user',
        );
      } else {
        errorNotification("$body");
      }
    } catch (e) {
      errorNotification('an error occurred');
    }
  }

  // update user
  Future<void> updateUser(user) async {
    inProgress = true;
    notifyListeners();

    try {
      final response = await put(
        "${ApiStrings.users}/${selectedUser!.id}",
        user.toJsonWithId(),
        headers: {
          'authorization': 'Bearer ${accountModel?.token}',
        },
      );

      final body = response.body;

      inProgress = false;
      notifyListeners();

      if (response.statusCode == 200) {
        // check code from response

        // final userBox = await Hive.openBox<User>(kUserBox);
        // userBox.put(kUserBox, user);
        selectedUser = User.fromJson(body);
        usersBox.put(
          selectedUser!.id,
          selectedUser!.toJsonWithId(),
        );
        Get.back();
        successNotification('User updated successfully');
      } else if (response.body == "Invalid token") {
        // errorNotification('You are not authorized to delete this user');
        Get.defaultDialog(
          title: 'You are not authorized to delete this user',
          middleText: 'You are not authorized to delete this user',
        );
      } else {
        errorNotification('Update fialed');
      }
    } catch (e) {
      inProgress = false;
      notifyListeners();
      errorNotification('An error occurred $e', duration: 5);
    }
  }

  // delete user
  deleteUser() async {
    try {
      final response =
          await delete("${ApiStrings.users}${selectedUser!.id}", headers: {
        'authorization': 'Bearer ${accountModel?.token}',
      });

      print("User delete response body ${response.body}");

      if (response.statusCode == 200) {
        Get.offAll(() => const UsersList());
        // removeUser(selectedUser!);
        usersBox.delete(selectedUser!.id);
        successNotification('User deleted successfully');
      } else if (response.statusCode == 404) {
        errorNotification('No User Found');
      } else if (response.body == "Invalid token") {
        // errorNotification('You are not authorized to delete this user');
        Get.defaultDialog(
          title: 'You are not authorized to delete this user',
          middleText: 'You are not authorized to delete this user',
        );
      }
    } catch (e) {
      errorNotification('an error occurred');
    }
  }
}
