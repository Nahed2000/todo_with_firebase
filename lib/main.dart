import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_course/screen/auth/forget_password.dart';
import 'package:firebase_course/screen/auth/register_screen.dart';
import 'package:firebase_course/screen/note/note_screen.dart';
import 'package:firebase_course/screen/auth/login_screen.dart';
import 'package:firebase_course/screen/lunch_screen.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/lunch_screen',
      routes: {
        '/lunch_screen': (context) =>const  LunchScreen(),
        '/login_screen': (context) =>const  LoginScreen(),
        '/register_screen': (context) =>const  RegisterScreen(),
        '/forget_password': (context) =>const  ForgetPassword(),
        '/home_screen': (context) => const NoteScreen(),
      },
    );
  }
}
