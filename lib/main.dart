import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_todo_sun_c11/auth/login/login_screen.dart';
import 'package:flutter_app_todo_sun_c11/auth/register/register_screen.dart';
import 'package:flutter_app_todo_sun_c11/home/home_screen.dart';
import 'package:flutter_app_todo_sun_c11/my_theme_data.dart';
import 'package:flutter_app_todo_sun_c11/provider/auth_user_provider.dart';
import 'package:flutter_app_todo_sun_c11/provider/list_provider.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Platform.isAndroid
      ? await Firebase.initializeApp(
          options: const FirebaseOptions(
              apiKey: 'AIzaSyA0TkLu5RcI9sCJ5h4rH4jwAi0T54l_nlw',
              appId: 'com.example.flutter_app_todo_sun_c11',
              messagingSenderId: '276618511161',
              projectId: 'todo-app-sun-c11'))
      : await Firebase.initializeApp();
  // await FirebaseFirestore.instance.disableNetwork();
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (context) => ListProvider()),
      ChangeNotifierProvider(create: (_) => AuthUserProvider())
    ],
    child: MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: LoginScreen.routeName,
      routes: {
        HomeScreen.routeName: (context) => HomeScreen(),
        RegisterScreen.routeName: (context) => RegisterScreen(),
        LoginScreen.routeName: (context) => LoginScreen(),
      },
      theme: MyThemeData.lightTheme,
      locale: Locale('es'),
    );
  }
}
