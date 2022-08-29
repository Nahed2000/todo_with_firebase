import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LunchScreen extends StatefulWidget {
  const LunchScreen({Key? key}) : super(key: key);

  @override
  State<LunchScreen> createState() => _LunchScreenState();
}

class _LunchScreenState extends State<LunchScreen> {
  late bool isLogin;

  @override
  void initState() {
    // TODO: implement initState

    if (FirebaseAuth.instance.currentUser != null) {
      isLogin = true;
      print(isLogin);
      print(' if  : $isLogin');
    } else {
      isLogin = false;
      print(' else  : $isLogin');
    }
    Future.delayed(const Duration(seconds: 2), () {
      Navigator.pushReplacementNamed(
          context, isLogin ? '/home_screen' : '/login_screen');
      print(' Navigator : $isLogin');
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.orange,
              Colors.deepOrangeAccent,
            ],
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
          ),
        ),
        alignment: Alignment.center,
        child: const Text(
          'Todo with firebase ',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 22,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
