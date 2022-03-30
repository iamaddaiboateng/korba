import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:korda/core/utils/connectivity_checker.dart';
import 'package:korda/features/users/controller/user_controller.dart';
import 'package:korda/features/users/model/user_model.dart';
import 'package:modal_progress_hud_alt/modal_progress_hud_alt.dart';
import 'package:provider/provider.dart';

class CreateEditUserWidget extends StatefulWidget {
  final User? user;
  const CreateEditUserWidget({Key? key, this.user}) : super(key: key);

  @override
  State<CreateEditUserWidget> createState() => _CreateEditUserWidgetState();
}

class _CreateEditUserWidgetState extends State<CreateEditUserWidget> {
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();

  // create a function that assign value to the controller when editing a user
  void _assignValuesToController() {
    if (widget.user != null) {
      _nameController.text = widget.user!.name;
      _emailController.text = widget.user!.email;
      _locationController.text = widget.user!.location;
    }
  }

  @override
  void initState() {
    super.initState();
    _assignValuesToController();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Form(
        key: _formkey,
        child: Consumer<UserController>(
          builder: (_, userController, __) => ModalProgressHUD(
            inAsyncCall: userController.inProgress,
            child: Container(
              width: 300,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  TextFormField(
                    controller: _nameController,
                    textCapitalization: TextCapitalization.words,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter name';
                      } else {
                        return null;
                      }
                    },
                    decoration: const InputDecoration(
                      labelText: 'Name',
                    ),
                  ),
                  TextFormField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter an email';
                      } else if (!value.isEmail) {
                        return 'Please enter a valid email';
                      } else {
                        return null;
                      }
                    },
                    decoration: const InputDecoration(
                      labelText: 'Email',
                    ),
                  ),
                  TextFormField(
                    controller: _locationController,
                    textCapitalization: TextCapitalization.words,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter location';
                      } else {
                        return null;
                      }
                    },
                    decoration: const InputDecoration(
                      labelText: 'Location',
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  userController.inProgress
                      ? const Center(
                          child: CircularProgressIndicator(),
                        )
                      : ElevatedButton(
                          onPressed: () {
                            if (_formkey.currentState!.validate()) {
                              User user = User(
                                id: widget.user == null
                                    ? null
                                    : widget.user!.id,
                                name: _nameController.text,
                                email: _emailController.text,
                                location: _locationController.text,
                              );

                              // check network connection
                              connectivityChecker(action: () {
                                widget.user != null
                                    ? userController.updateUser(user)
                                    : userController.createUser(user);
                              });
                            }
                          },
                          child: Text(
                            widget.user != null
                                ? "Edit User Profile"
                                : 'Create User',
                          ),
                        ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
