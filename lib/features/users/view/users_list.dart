import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:korda/core/utils/connectivity_checker.dart';
import 'package:korda/features/users/controller/user_controller.dart';
import 'package:korda/features/users/view/create_edit_users_widget.dart';
import 'package:korda/features/users/view/user_details.dart';
import 'package:modal_progress_hud_alt/modal_progress_hud_alt.dart';
import 'package:provider/provider.dart';

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
          ),
          body: ListView.builder(
            itemCount: userController.users.length,
            itemBuilder: ((context, index) {
              final user = userController.users[index];
              return ListTile(
                onTap: () {
                  userController.setSelectedUser(user);
                  userController.getParticularUser();
                  Get.to(() => const UserDetailspage());
                },
                title: Text(user.name),
                subtitle: Text(user.email),
                leading: CircleAvatar(
                  backgroundImage: NetworkImage(user.imageUrl!),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}
