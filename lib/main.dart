import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:korda/core/utils/hive_strings.dart';
import 'package:korda/features/account/controller/account_controller.dart';
import 'package:korda/features/account/view/sign_up.dart';
import 'package:korda/features/users/controller/user_controller.dart';
import 'package:provider/provider.dart';
import 'package:hive_flutter/hive_flutter.dart';

void main() async {
  await Hive.initFlutter();
  await Hive.openBox(kHiveAllUsers);
  await Hive.openBox(kHiveLastRequestPage);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<AccountController>(
          create: (_) => AccountController(),
        ),
        ChangeNotifierProvider<UserController>(
          create: (_) => UserController(),
        ),
      ],
      child: GetMaterialApp(
        title: 'Korda Demo',
        theme: ThemeData(
          brightness: Brightness.dark,
          appBarTheme: const AppBarTheme(
            backgroundColor: Colors.deepOrange,
          ),
          primarySwatch: Colors.deepOrange,
        ),
        home: const SignUp(),
      ),
    );
  }
}
