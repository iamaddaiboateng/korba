import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:korda/features/account/controller/account_controller.dart';
import 'package:korda/features/account/model/account_model.dart';
import 'package:korda/features/account/view/log_in_page.dart';

class SignUp extends StatefulWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sign Up'),
      ),
      body: Form(
        key: _formkey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
            TextFormField(
              controller: _nameController,
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Please enter your name';
                }
                return null;
              },
              decoration: const InputDecoration(
                labelText: 'Name',
              ),
            ),
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
            TextFormField(
              obscureText: true,
              controller: _confirmPasswordController,
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Please enter a password';
                } else if (value != _passwordController.text) {
                  return 'Passwords do not match';
                }
                return null;
              },
              decoration: const InputDecoration(
                labelText: 'Confirm Password',
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            ElevatedButton(
                child: const Text('Sign Up'),
                onPressed: () {
                  // check if form is valid
                  if (_formkey.currentState!.validate()) {
                    // create an account model
                    AccountModel accountModel = AccountModel(
                      name: _nameController.text,
                      email: _emailController.text,
                      password: _passwordController.text,
                    );

                    // sign up
                    AccountController().signUp(accountModel);
                  }
                }),
            Row(
              children: [
                const Text('Already have an account?'),
                TextButton(
                  child: const Text('Sign In'),
                  onPressed: () {
                    Get.to(() => const LogInPage());
                  },
                ),
              ],
            )
          ]),
        ),
      ),
    );
  }
}
