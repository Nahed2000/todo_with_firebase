import 'package:firebase_auth/firebase_auth.dart';

import '../model/firebase_response.dart';

class FirebaseAuthController {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  Future<FirebaseResponse> anonymouslyLogin() async {
    try {
      UserCredential userCredential = await _firebaseAuth.signInAnonymously();
      // print("Signed in with temporary account.");
      print(userCredential.user);
      if (userCredential.user != null) {
        return FirebaseResponse(
            message: 'Signed in with temporary account', status: true);
      }
    } on FirebaseAuthException catch (e) {
      return controlError(e);
    }
    return FirebaseResponse(message: 'Something went wrong !', status: false);
  }

  Future<FirebaseResponse> loginWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      UserCredential userCredential = await _firebaseAuth
          .signInWithEmailAndPassword(email: email, password: password);
      if (userCredential.user != null) {
        String message = userCredential.user!.emailVerified
            ? 'Successfully Login'
            : 'you must verify your email';
        return FirebaseResponse(
            message: message, status: userCredential.user!.emailVerified);
      }
    } on FirebaseAuthException catch (e) {
      return controlError(e);
    } catch (e) {
      //
    }
    return FirebaseResponse(message: 'Something went wrong', status: false);
  }

  Future<FirebaseResponse> createWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      UserCredential userCredential = await _firebaseAuth
          .createUserWithEmailAndPassword(email: email, password: password);
      if (userCredential.user != null) {
        userCredential.user!.sendEmailVerification();
        return FirebaseResponse(
            message: 'Successfully Send verify link', status: true);
      }
    } on FirebaseAuthException catch (e) {
      return controlError(e);
    } catch (e) {
      //
    }
    return FirebaseResponse(message: 'Something went wrong', status: false);
  }

  Future<FirebaseResponse> forgetPassword({required String email}) async {
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: email);
      return FirebaseResponse(
          message: 'Successfully Send Rest Password link', status: true);
    } on FirebaseAuthException catch (e) {
      return controlError(e);
    } catch (e) {
      //
    }
    return FirebaseResponse(message: 'Something went wrong', status: false);
  }

  Future<void> logeOut() async {
    await _firebaseAuth.signOut();
  }

  FirebaseResponse controlError(FirebaseAuthException authException) {
    // print('${authException.code} : hi ');
    if (authException.code == 'email-already-in-use') {
    } else if (authException.code == 'invalid-email') {
    } else if (authException.code == 'operation-not-allowed') {
    } else if (authException.code == 'weak-password') {
    } else if (authException.code == 'wrong-password') {
    } else if (authException.code == 'user-not-found') {
    } else if (authException.code == 'invalid-email') {
    } else if (authException.code == 'user-disabled') {
    } else if (authException.code == 'auth/invalid-email') {
    } else if (authException.code == 'auth/user-not-found') {
    } else if (authException.code == 'operation-not-allowed') {}
    return FirebaseResponse(
        message: authException.message ?? 'Error Occurred', status: false);
  }
}
