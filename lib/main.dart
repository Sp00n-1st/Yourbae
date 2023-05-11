import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:oktoast/oktoast.dart';
import 'package:yourbae_project/bindings/home_binding.dart';
import 'package:yourbae_project/controller/auth_controller.dart';
import 'package:yourbae_project/firebase_options.dart';
import 'package:yourbae_project/view/home.dart';
import 'view/login.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      builder: (context, child) => OKToast(
        child: GetMaterialApp(
          debugShowCheckedModeBanner: false,
          home: child,
        ),
      ),
      child: Check(),
    );
  }
}

class Check extends StatelessWidget {
  var authController = Get.put(AuthController());
  Future<FirebaseApp> _initializeFirebase() async {
    FirebaseApp firebaseApp = await Firebase.initializeApp();
    User? user = FirebaseAuth.instance.currentUser;
    try {
      if (user != null) {
        Get.offAll(Home());
      } else {
        //DataBaseServices().logoutAuth(false);
        Get.offAll(Login());
      }
    } on FirebaseAuthException catch (e) {
      showToast(e.message!);
      authController.logoutAuth(false);
    }
    return firebaseApp;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: _initializeFirebase(),
        builder: (context, snapshot) => CircularProgressIndicator(),
      ),
    );
  }
}
