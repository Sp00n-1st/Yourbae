import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:yourbae_project/view/login.dart';
import 'auth_controller.dart';

class CreateUserController extends GetxController {
  var authController = Get.put(AuthController());
  var isLoading = false.obs;
  Future<void> createUserWithEmail(
      String email,
      String password,
      String firstName,
      String? imageProfile,
      String? token,
      BuildContext context) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    await auth.createUserWithEmailAndPassword(email: email, password: password);
    await auth.currentUser!.sendEmailVerification();
    await createUserToStorage(
        email, auth.currentUser!.uid, firstName, imageProfile, token);
    authController.isLogin.value = !authController.isLogin.value;
    showDialog(
      context: context,
      builder: (context) {
        return CupertinoAlertDialog(
          title: Text(
            'Hooray You Have Successfully Registered',
            style: GoogleFonts.poppins(),
          ),
          content: Column(
            children: [
              //#D8D8DC
              Image.asset('assets/success7.gif'),
              Text(
                'Now You Can Login Using The Account You Registered',
                style: GoogleFonts.poppins(),
              )
            ],
          ),
          actions: [
            MaterialButton(
              onPressed: () async {
                await FirebaseAuth.instance.signOut();
                Navigator.pop(context);
                Get.offAll(Login());
              },
              child: const Text('OK'),
            )
          ],
        );
      },
    );
  }

  Future<void> createUserToStorage(String email, String uid, String firstName,
      String? imageProfile, String? token) async {
    bool isDisable = false;
    FirebaseFirestore firebase = FirebaseFirestore.instance;
    final userCreated = <String, dynamic>{
      'token': token,
      'isDisable': isDisable,
      'firstName': firstName,
      'email': email,
      'imageProfile': imageProfile,
      'isLogin': null,
      'lastLogin': null
    };
    firebase.collection('user').doc(uid).set(userCreated);
  }
}
