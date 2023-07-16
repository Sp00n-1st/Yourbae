import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:oktoast/oktoast.dart';
import '../controller/auth_controller.dart';
import '../controller/notification_controller.dart';
import '../firebase_options.dart';
import '../view/home.dart';
import 'view/login.dart';

void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  NotificationController notificationController =
      Get.put(NotificationController());
  FirebaseMessaging.onBackgroundMessage(
      notificationController.firebaseMessagingBackgroundHandler);

  if (!kIsWeb) {
    await notificationController.setupFlutterNotifications();
  }
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
      child: const Check(),
    );
  }
}

class Check extends StatelessWidget {
  const Check({super.key});

  Future<FirebaseApp> _initializeFirebase() async {
    final AuthController authController = Get.put(AuthController());
    FirebaseApp firebaseApp = await Firebase.initializeApp();
    User? user = FirebaseAuth.instance.currentUser;
    try {
      if (user != null) {
        Get.offAll(const Home());
      } else {
        Get.offAll(const Login());
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
        builder: (context, snapshot) => const CircularProgressIndicator(),
      ),
    );
  }
}
