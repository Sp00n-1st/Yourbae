import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:oktoast/oktoast.dart';
import 'package:yourbae_project/view/home.dart';
import 'package:yourbae_project/view/login.dart';
import 'controller/auth_controller.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  showNotification(message);
}

FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

void showNotification(RemoteMessage message) async {
  const channelId = 'my_channel_id';
  const channelName = 'My Channel';

  const AndroidNotificationDetails androidPlatformChannelSpecifics =
      AndroidNotificationDetails(
    channelId,
    channelName,
    importance: Importance.max,
    priority: Priority.max,
    channelShowBadge: true,
    showWhen: false,
  );

  const NotificationDetails platformChannelSpecifics =
      NotificationDetails(android: androidPlatformChannelSpecifics);
  await flutterLocalNotificationsPlugin.show(
    0,
    message.notification!.title,
    message.notification!.body,
    platformChannelSpecifics,
    payload: 'Default_Sound',
  );
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await FirebaseMessaging.instance
      .requestPermission(
          alert: true,
          badge: true,
          provisional: false,
          sound: true,
          announcement: true,
          carPlay: true,
          criticalAlert: true)
      .then((value) async {
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
    FirebaseMessaging.onMessage.listen(showNotification);
  });

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
