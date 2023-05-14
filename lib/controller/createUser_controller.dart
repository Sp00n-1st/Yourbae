import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
      String name,
      String kodeNegara,
      String kodeNomorNegara,
      String nomorHP,
      String? imageProfile,
      String? token,
      BuildContext context) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    await auth.createUserWithEmailAndPassword(email: email, password: password);
    await auth.currentUser!.sendEmailVerification();
    await createUserToStorage(email, auth.currentUser!.uid, name, kodeNegara,
        kodeNomorNegara, nomorHP, imageProfile, token);
    showDialog(
      context: context,
      builder: (context) {
        return CupertinoAlertDialog(
          title: Text(
            'Register Sukses',
            style: GoogleFonts.poppins(),
          ),
          content: Column(
            children: [
              //#D8D8DC
              SizedBox(
                  width: 100.w,
                  height: 100.h,
                  child: Image.asset('assets/emailSend.png')),
              Text(
                'Kami Telah Mengirimkan Email Verifikasi Ke Email Yang Telah Didaftarkan, Cek Inbox/Spam Pada Email Anda Sebelum Login',
                style: GoogleFonts.poppins(),
                textAlign: TextAlign.justify,
              )
            ],
          ),
          actions: [
            MaterialButton(
              onPressed: () async {
                await FirebaseAuth.instance.signOut();
                Navigator.pop(context);
                Get.offAll(const Login());
              },
              child: const Text('OK'),
            )
          ],
        );
      },
    );
  }

  Future<void> createUserToStorage(
      String email,
      String uid,
      String name,
      String kodeNegara,
      String kodeNomorNegara,
      String nomorHP,
      String? imageProfile,
      String? token) async {
    bool isDisable = false;
    FirebaseFirestore firebase = FirebaseFirestore.instance;
    final userCreated = <String, dynamic>{
      'token': token,
      'isDisable': isDisable,
      'name': name,
      'kodeNegara': kodeNegara,
      'kodeNomorNegara': kodeNomorNegara,
      'nomorHP': nomorHP,
      'email': email,
      'imageProfile': imageProfile,
      'isLogin': null,
      'lastLogin': null
    };
    firebase.collection('user').doc(uid).set(userCreated);
    isLoading.value = false;
  }
}