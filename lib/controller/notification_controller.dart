import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';

@pragma('vm:entry-point')
class NotificationController extends GetxController {
  String? initialMessage;
  bool resolved = false;
  FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;
  @override
  void onInit() async {
    super.onInit();
    FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
        FlutterLocalNotificationsPlugin();
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('ic_launcher');
    const InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);
    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  Future<String?> getToken() async {
    return await firebaseMessaging.getToken();
  }
}
