import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:korda/features/account/controller/account_controller.dart';
import 'package:korda/features/account/model/account_model.dart';
import 'package:korda/features/users/view/users_list.dart';
import 'package:modal_progress_hud_alt/modal_progress_hud_alt.dart';
import 'package:provider/provider.dart';

class LogInPage extends StatefulWidget {
  const LogInPage({Key? key}) : super(key: key);

  @override
  State<LogInPage> createState() => _LogInPageState();
}

class _LogInPageState extends State<LogInPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AccountController>(
      builder: (_, account, __) => account.accountModel != null
          ? const UsersList()
          : ModalProgressHUD(
              inAsyncCall: account.inProgress,
              child: Scaffold(
                appBar: AppBar(
                  title: const Text('Log In'),
                ),
                body: Form(
                  key: _formkey,
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        TextFormField(
                          controller: _emailController,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please enter an email';
                            } else if (!value.isEmail) {
                              return 'Please enter a valid email';
                            } else {
                              return null;
                            }
                          },
                          keyboardType: TextInputType.emailAddress,
                          decoration: const InputDecoration(
                            labelText: 'Email',
                          ),
                        ),
                        TextFormField(
                          obscureText: true,
                          controller: _passwordController,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please enter a password';
                            }
                            return null;
                          },
                          decoration: const InputDecoration(
                            labelText: 'Password',
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        ElevatedButton(
                          onPressed: () {
                            if (_formkey.currentState!.validate()) {
                              AccountModel accountModel = AccountModel(
                                name: ' ',
                                email: _emailController.text,
                                password: _passwordController.text,
                              );

                              account.logIn(accountModel);
                            }
                          },
                          child: const Text('Log In'),
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
