import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_course/firebase/firebase_auth_controller.dart';
import 'package:firebase_course/firebase/social_auth.dart';
import 'package:firebase_course/utils/helper.dart';
import 'package:flutter/material.dart';

import '../../model/firebase_response.dart';
import '../../widget/custom_button.dart';
import '../../widget/custom_text_field.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> with Helper {
  late TextEditingController emailController;
  late TextEditingController passwordController;

  @override
  void initState() {
    // TODO: implement initState
    emailController = TextEditingController();
    passwordController = TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Login Screen',
          style: TextStyle(
            color: Colors.black,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomTextField(
              hintText: 'Email',
              controller: emailController,
              icon: Icons.email_outlined,
            ),
            const SizedBox(height: 20),
            CustomTextField(
              hintText: 'password',
              controller: passwordController,
              icon: Icons.lock_outline,
            ),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                  onPressed: () =>
                      Navigator.pushNamed(context, '/forget_password'),
                  child: const Text("Forget password?")),
            ),
            CustomButton(
              title: 'Login',
              onPress: () async {
                await _performLogin();
              },
            ),
            const SizedBox(height: 20),
            CustomButton(
              title: 'Login with Anonymously',
              onPress: () async {
                await FirebaseAuthController().anonymouslyLogin();
                Navigator.pushReplacementNamed(context, '/home_screen');
              },
            ),
            SizedBox(height: 20),
            CustomButton(
              title: 'Login with Google',
              onPress: () async {
                UserCredential user =
                    await FirebaseSocialAuth().signInWithGoogle();
                print(user);
                if (user.user != null) {
                  Navigator.pushReplacementNamed(context, '/home_screen');
                }
              },
            ),
            TextButton(
                onPressed: () =>
                    Navigator.pushNamed(context, '/register_screen'),
                child: const Text("Don't have account? create Now")),
          ],
        ),
      ),
    );
  }

  Future<void> _performLogin() async {
    if (checkData()) {
      await login();
    }
  }

  bool checkData() {
    if (emailController.text.isNotEmpty && passwordController.text.isNotEmpty) {
      return true;
    }
    showSnackBar(context,
        message: 'Required Data , please enter your email and password',
        error: true);
    return false;
  }

  Future<void> login() async {
    FirebaseResponse firebaseResponse = await FirebaseAuthController()
        .loginWithEmailAndPassword(
            email: emailController.text, password: passwordController.text);
    showSnackBar(context,
        message: firebaseResponse.message, error: !firebaseResponse.status);
    if (firebaseResponse.status) {
      Navigator.pushReplacementNamed(context, '/home_screen');
    }
  }
}
