import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:oktoast/oktoast.dart';
import 'package:intl/intl.dart';
import 'package:yourbae_project/view/home.dart';
import 'package:yourbae_project/view/login.dart';

import 'controller.dart';

class AuthController extends GetxController {
  var controller = Get.put(Controller());
  var isLogin = false.obs;

  Future<void> loginAuth(
      BuildContext context, String email, String password) async {
    await FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email, password: password);
    final auth = FirebaseAuth.instance.currentUser!;
    var collection =
        FirebaseFirestore.instance.collection('user').doc(auth.uid);
    var querySnapshot = await collection.get();
    Map<String, dynamic>? data = querySnapshot.data();
    var name = data!['name'];
    var isDisable = data['isDisable'];
    if (isDisable == false) {
      if (auth.emailVerified == true) {
        collection.update(({'isLogin': true}));
        Get.offAll(Home());
        isLogin.value = !isLogin.value;
        showToast('Hello $name You Are Login Now',
            position: const ToastPosition(align: Alignment.bottomCenter),
            backgroundColor: const Color(0xff00AA13));
      } else if (auth.emailVerified == false) {
        isLogin.value = false;
        dialogEmail(context);
      }
    } else {
      isLogin.value = !isLogin.value;
      showCupertinoDialog(
        context: context,
        builder: (context) {
          return CupertinoAlertDialog(
            title: Text(
              'You can\'t login because you\'ve been banned',
              style: GoogleFonts.poppins(fontSize: 18),
            ),
            content: Column(
              children: [
                const Icon(
                  CupertinoIcons.clear_circled,
                  color: Colors.red,
                  size: 80,
                ),
                Text(
                  'Contact Sweet Dream customer service for more information',
                  style: GoogleFonts.poppins(fontSize: 14),
                )
              ],
            ),
            actions: [
              MaterialButton(
                  child: const Text('OK'),
                  onPressed: () {
                    logoutAuth(false);
                  })
            ],
          );
        },
      );
    }
  }

  Future<void> logoutAuth(bool isShowToast) async {
    DateTime now = DateTime.now();
    final date = DateFormat('dd-MM-yyyy').format(now);
    final auth = FirebaseAuth.instance.currentUser!.uid;
    var collection = FirebaseFirestore.instance.collection('user').doc(auth);
    await FirebaseAuth.instance.signOut();
    collection.update(({'isLogin': false, 'lastLogin': date}));
    Get.offAll(Login());
    isShowToast == true
        ? showToast('You Are Logout',
            position: const ToastPosition(align: Alignment.bottomCenter))
        : null;
    controller.selectedPages.value = 0;
  }

  dialogEmail(BuildContext context) {
    final auth = FirebaseAuth.instance.currentUser!;
    return showDialog(
      context: context,
      builder: (context) {
        return CupertinoAlertDialog(
          title: Text(
            'Email anda belum terverifikasi!',
            style: GoogleFonts.poppins(),
          ),
          content: Column(
            children: [
              Container(
                  margin: EdgeInsets.fromLTRB(0, 10.r, 0, 10.r),
                  width: 100.w,
                  height: 100.h,
                  child: Image.asset('assets/email3.png')),
              Text(
                'Kami telah mengirimkan email verifikasi ke alamat email yang Anda daftarkan. Mohon periksa kotak masuk Anda untuk menemukan email tersebut. Jika Anda tidak menemukan email verifikasi di kotak masuk, harap periksa juga folder spam atau folder promosi. Jika email tidak terkirim klik tombol KIRIM ULANG dibawah ini',
                textAlign: TextAlign.justify,
                style: GoogleFonts.poppins(),
              ),
              Container(
                margin: EdgeInsets.fromLTRB(0, 20.r, 0, 0),
                width: 150.w,
                height: 30.h,
                child: ElevatedButton(
                    onPressed: () async {
                      await auth.sendEmailVerification();
                      await FirebaseAuth.instance.signOut();
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green, shape: StadiumBorder()),
                    child: Text(
                      'Kirim Ulang',
                      style: GoogleFonts.poppins(),
                    )),
              )
            ],
          ),
          actions: [
            TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text(
                  'OK',
                  style: GoogleFonts.poppins(color: Colors.black),
                ))
          ],
        );
      },
    );
  }
}
