import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:korda/core/utils/connectivity_checker.dart';
import 'package:korda/core/utils/hive_strings.dart';
import 'package:korda/features/account/view/sign_up.dart';
import 'package:korda/features/users/controller/user_controller.dart';
import 'package:korda/features/users/view/create_edit_users_widget.dart';
import 'package:korda/features/users/view/user_details.dart';
import 'package:modal_progress_hud_alt/modal_progress_hud_alt.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../model/user_model.dart';

class UsersList extends StatefulWidget {
  const UsersList({Key? key}) : super(key: key);

  @override
  State<UsersList> createState() => _UsersListState();
}

class _UsersListState extends State<UsersList> {
  getAllUser() {
    // check network connection
    connectivityChecker(action: () {
      Provider.of<UserController>(context, listen: false).getAllUsers();
    });
  }

  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  @override
  void initState() {
    super.initState();
    getAllUser();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<UserController>(
      builder: (_, userController, __) => ModalProgressHUD(
        inAsyncCall: userController.inProgress,
        child: Scaffold(
          bottomNavigationBar: Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              onPressed: () {
                Get.defaultDialog(
                  radius: 5,
                  title: 'Create New User',
                  content: const CreateEditUserWidget(),
                );
              },
              child: const Text('Create New User'),
            ),
          ),
          appBar: AppBar(
            title: const Text('Users'),
            actions: [
              IconButton(
                onPressed: () {
                  // create a sign our dialog
                  Get.defaultDialog(
                    radius: 5,
                    title: 'Sign Out',
                    content: const Text('Are you sure you want to sign out?'),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Get.back();
                        },
                        child: const Text('Cancel'),
                      ),
                      TextButton(
                        onPressed: () {
                          Get.offAll(const SignUp());
                        },
                        child: const Text('Sign Out'),
                      ),
                    ],
                  );
                },
                icon: const Icon(
                  Icons.exit_to_app,
                ),
              )
            ],
          ),
          body: userController.inProgress
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : ValueListenableBuilder(
                  valueListenable: Hive.box(kHiveAllUsers).listenable(),
                  builder: (_, Box usersBox, __) => SmartRefresher(
                    controller: _refreshController,
                    enablePullUp: true,
                    enablePullDown: false,
                    onLoading: () {
                      Provider.of<UserController>(context, listen: false)
                          .getAllUsers();
                      _refreshController.loadComplete();
                    },
                    child: ListView.builder(
                      itemCount: usersBox.length,
                      itemBuilder: ((context, index) {
                        final userFromDatabase = usersBox.getAt(index);
                        User user = User.fromJson(userFromDatabase);

                        return ListTile(
                          onTap: () {
                            userController.setSelectedUser(user);
                            userController.getParticularUser();
                            Get.to(() => const UserDetailspage());
                          },
                          title: Text(user.name),
                          subtitle: Text(user.email),
                          leading: CircleAvatar(
                            backgroundImage: NetworkImage(user.imageUrl ?? ''),
                          ),
                        );
                      }),
                    ),
                  ),
                ),
        ),
      ),
    );
  }
}
