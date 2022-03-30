import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:korda/features/users/controller/user_controller.dart';
import 'package:korda/features/users/view/create_edit_users_widget.dart';
import 'package:modal_progress_hud_alt/modal_progress_hud_alt.dart';
import 'package:provider/provider.dart';

class UserDetailspage extends StatefulWidget {
  const UserDetailspage({Key? key}) : super(key: key);

  @override
  State<UserDetailspage> createState() => _UserDetailspageState();
}

class _UserDetailspageState extends State<UserDetailspage> {
  @override
  Widget build(BuildContext context) {
    return Consumer<UserController>(
      builder: (_, user, __) => ModalProgressHUD(
        inAsyncCall: user.inProgress,
        child: Scaffold(
          appBar: AppBar(
            title: const Text('User Details'),
          ),
          body: ListView(
            padding: const EdgeInsets.all(20),
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.network(
                  user.selectedUser!.imageUrl!,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(height: 20),
              Text(
                user.selectedUser!.name,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headline4,
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                user.selectedUser!.email,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headline6,
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: Colors.teal,
                      ),
                      onPressed: () {
                        Get.defaultDialog(
                          radius: 5,
                          title: 'Edit User',
                          content: CreateEditUserWidget(
                            user: user.selectedUser,
                          ),
                        );
                      
                      },
                      child: const Text('Edit'),
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: Colors.red,
                      ),
                      onPressed: () {
                        Get.defaultDialog(
                          radius: 5,
                          title: 'Delete User',
                          content: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                'Are you sure you want to delete "${user.selectedUser!.name}"?',
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    primary: Colors.red,
                                  ),
                                  onPressed: () {
                                    user.deleteUser();
                                  },
                                  child: const Text("Delete User"))
                            ],
                          ),
                        );
                      },
                      child: const Text('Delete'),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
