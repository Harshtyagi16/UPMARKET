import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RegisterC extends GetxController {
  final _auth = FirebaseAuth.instance;
  RxString verificationIDToken = ''.obs; //token
  RxString uid =''.obs; //id


  Future<void> RegisterM(String number) async {
    final auth = await _auth.verifyPhoneNumber(
        phoneNumber: "+91$number",
        verificationCompleted: (phoneAuthCred) async {},
        verificationFailed: (verificationFailed) async {
          print(verificationFailed);
        },
        codeSent: (verificationId, resendingToken) async {
          verificationIDToken.value = verificationId; //token
        },
        codeAutoRetrievalTimeout: (verificationId) async {});
  }

  Future<void> verify(AuthCredential authCred) async {
    final auth = _auth.signInWithCredential(authCred);
    try {
      final authCred = await auth;
      if (authCred.user != null) {
        uid.value = authCred.user!.uid;
        print("this is user ${authCred.user}");
        print("this is token ${verificationIDToken.value}"); //token
        print("this is uid ${authCred.user!.uid}"); //uid
      }
    } on FirebaseAuthException catch (e) {
      print('Invalid Otp');
    }
  }
}
