import 'package:firebase_course/firebase/firebase_auth_controller.dart';
import 'package:firebase_course/utils/helper.dart';
import 'package:flutter/material.dart';

import '../../model/firebase_response.dart';
import '../../widget/custom_button.dart';
import '../../widget/custom_text_field.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> with Helper {
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
        iconTheme: IconThemeData(
          color: Colors.black,
        ),
        title: const Text(
          'Register Screen',
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
            const SizedBox(height: 20),
            CustomButton(
              title: 'Register',
              onPress: () async {
                await _performRegister();
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _performRegister() async {
    if (checkData()) {
      await register();
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

  Future<void> register() async {
    FirebaseResponse firebaseResponse = await FirebaseAuthController()
        .createWithEmailAndPassword(
            email: emailController.text, password: passwordController.text);
    showSnackBar(context,
        message: firebaseResponse.message, error: !firebaseResponse.status);
    if (firebaseResponse.status) {
      Navigator.pop(context);
    }
  }
}
