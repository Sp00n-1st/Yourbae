import 'dart:convert';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:yourbae_project/controller/auth_controller.dart';
import '../firebase_options.dart';

@pragma('vm:entry-point')
class NotificationController extends GetxController {
  String? initialMessage;
  bool _resolved = false;
  FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;
  // AuthController authController = Get.put(AuthController());

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    FirebaseMessaging.instance.getInitialMessage().then((value) {
      _resolved = true;
      initialMessage = value?.data.toString();
    });

    FirebaseMessaging.onMessage.listen(showFlutterNotification);

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('A new onMessageOpenedApp event was published!');
      // Navigator.pushNamed(
      //   context,
      //   '/message',
      //   arguments: MessageArguments(message, true),
      // );
    });
  }

  bool isFlutterLocalNotificationsInitialized = false;
  late AndroidNotificationChannel channel;
  late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
  Future<void> setupFlutterNotifications() async {
    if (isFlutterLocalNotificationsInitialized) {
      return;
    }
    channel = const AndroidNotificationChannel(
      'high_importance_channel', // id
      'High Importance Notifications', // title
      description:
          'This channel is used for important notifications.', // description
      importance: Importance.high,
    );

    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

    /// Create an Android Notification Channel.
    ///
    /// We use this channel in the `AndroidManifest.xml` file to override the
    /// default FCM channel to enable heads up notifications.
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);

    /// Update the iOS foreground notification presentation options to allow
    /// heads up notifications.
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );
    isFlutterLocalNotificationsInitialized = true;
  }

  Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
    await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform);
    await setupFlutterNotifications();
    showFlutterNotification(message);
    // If you're going to use other Firebase services in the background, such as Firestore,
    // make sure you call `initializeApp` before using other Firebase services.
    print('Handling a background message ${message.messageId}');
  }

  void showFlutterNotification(RemoteMessage message) {
    RemoteNotification? notification = message.notification;
    AndroidNotification? android = message.notification?.android;

    if (notification != null && android != null && !kIsWeb) {
      flutterLocalNotificationsPlugin.show(
        notification.hashCode,
        notification.title,
        notification.body,
        NotificationDetails(
          android: AndroidNotificationDetails(channel.id, channel.name,
              channelDescription: channel.description,
              playSound: true,
              // TODO add a proper drawable resource to android, for now using
              //      one that already exist
              icon: 'ic_launcher'),
        ),
      );
    }
  }

  // int _messageCount = 0;

  /// The API endpoint here accepts a raw FCM payload for demonstration purposes.
  // String constructFCMPayload(String? token) {
  //   _messageCount++;
  //   return jsonEncode({
  //     'token': token,
  //     'data': {
  //       'via': 'FlutterFire Cloud Messaging!!!',
  //       'count': _messageCount.toString(),
  //     },
  //     'notification': {
  //       'title': 'Hello FlutterFire!',
  //       'body': 'This notification (#$_messageCount) was created via FCM!',
  //     },
  //   });
  // }

  Future<void> sendPushMessage(String token) async {
    final data = {
      'click_action': "FLUTTER_NOTIFICATION_CLICK",
      'id': '3432',
      'status': 'done',
      'message': 'Push'
    };

    final noti = {'body': 'push', 'title': 'Judul'};

    if (token == '') {
      print('Unable to send FCM message, no token exists.');
      return;
    }

    try {
      var r = await http.post(
        Uri.parse('https://fcm.googleapis.com/fcm/send'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization':
              'key=AAAA68t28us:APA91bFqDLEODC5BDg_P4tkHWfFVnbe-RyvbK3QGOoe333id3Zr-hKryanLf_WGMit2YGxWxtincyJIFcipLob0GggtqDbmT7cwNE67K6WNYaVLmyXWixmGm2_4GslEgpDux7dfjLWzD'
        },
        body: jsonEncode({
          'notification': noti,
          'priority': 'high',
          'data': data,
          'to': token
        }),
      );
      print('FCM request for device sent!');
      print(r.statusCode);
    } catch (e) {
      print(e);
    }
  }

  Future<String?> getToken() async {
    return await firebaseMessaging.getToken();
  }
}
