import 'package:firebase_course/firebase/firebase_auth_controller.dart';
import 'package:firebase_course/utils/helper.dart';
import 'package:flutter/material.dart';

import '../../model/firebase_response.dart';
import '../../widget/custom_button.dart';
import '../../widget/custom_text_field.dart';

class ForgetPassword extends StatefulWidget {
  const ForgetPassword({Key? key}) : super(key: key);

  @override
  State<ForgetPassword> createState() => _ForgetPasswordState();
}

class _ForgetPasswordState extends State<ForgetPassword> with Helper {
  late TextEditingController emailController;

  @override
  void initState() {
    // TODO: implement initState
    emailController = TextEditingController();
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
            CustomButton(
              title: 'Register',
              onPress: () async {
                await _performForget();
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _performForget() async {
    if (checkData()) {
      await forget();
    }
  }

  bool checkData() {
    if (emailController.text.isNotEmpty) {
      return true;
    }
    showSnackBar(context,
        message: 'Required Data , please enter your email ',
        error: true);
    return false;
  }

  Future<void> forget() async {
    FirebaseResponse firebaseResponse = await FirebaseAuthController()
        .forgetPassword(email: emailController.text);
    showSnackBar(context,
        message: firebaseResponse.message, error: !firebaseResponse.status);
    if (firebaseResponse.status) {
      Navigator.pop(context);
    }
  }
}
