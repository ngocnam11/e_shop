import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_shop/data/models/notification.dart';
import 'package:e_shop/main.dart';
import 'package:e_shop/presentation/router/app_router.dart';
import 'package:e_shop/services/firestore_services.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:http/http.dart' as http;

import '../firebase_options.dart';

class NotificationServices {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  Future<void> initNotification() async {
    final fcmToken = await _firebaseMessaging.getToken();

    print("Token: $fcmToken");

    initPushNotification();
  }

  void _handleMessage(RemoteMessage? message) {
    if (message == null) return;

    navigatorKey.currentState
        ?.pushNamed(AppRouter.notification, arguments: message);
  }

  Future initPushNotification() async {
    _firebaseMessaging.getInitialMessage().then(_handleMessage);

    FirebaseMessaging.onMessageOpenedApp.listen(_handleMessage);

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('Got a message whilst in the foreground!');
      print('Message data: ${message.data}');

      if (message.notification != null) {
        print('Message also contained a notification: ${message.toMap()}');
      }
    });

    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  }

  bool isFlutterLocalNotificationsInitialized = false;

  final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  final AndroidNotificationChannel channel = const AndroidNotificationChannel(
    'high_importance_channel',
    'High Importance Notifications',
    description: 'This channel is used for important notifications.',
    importance: Importance.high,
  );

  Future<void> setupFlutterNotifications() async {
    if (isFlutterLocalNotificationsInitialized) {
      return;
    }

    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);

    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );
    isFlutterLocalNotificationsInitialized = true;
  }

  void showFlutterNotification(RemoteMessage message) {
    RemoteNotification? notification = message.notification;
    // AndroidNotification? android = message.notification?.android;
    if (notification != null && !kIsWeb) {
      flutterLocalNotificationsPlugin.show(
        notification.hashCode,
        notification.title,
        notification.body,
        NotificationDetails(
          android: AndroidNotificationDetails(
            channel.id,
            channel.name,
            channelDescription: channel.description,
            icon: '@mipmap/launcher_icon',
          ),
        ),
      );
    }
  }

  Future<String> sendPushMessage({
    required String title,
    required String body,
    required String senderId,
    required String receiverId,
  }) async {
    String sendNoti = 'Some error occurred';
    try {
      final fcmToken = await _firebaseMessaging.getToken();

      NotificationModel notification = NotificationModel(
        id: '',
        senderId: senderId,
        title: title,
        body: body,
        receiverId: receiverId,
        imageUrl: '',
        createdAt: Timestamp.now(),
      );

      await FireStoreServices().addFCMToken(token: fcmToken!);
      await FireStoreServices().addNotification(notification: notification);
      await http.post(
        Uri.parse('https://fcm.googleapis.com/fcm/send'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization':
              'Bearer AAAAAWQt39U:APA91bFJLIMVm-UcQBNFZJI2VaHpGEl1GqRdjnt4wy2IIgwqxxYdZQIHGakVhCNVbhkSKrs4Pp_m7hRwJl2p4gvm42DWyMPmj00zrvJ2ftTjwoxigYpajBacVQFKlAVlQRhwP4zFlX79'
        },
        body: jsonEncode(
          <String, dynamic>{
            'priority': 'high',
            'data': <String, dynamic>{
              'status': 'done',
              'body': body,
              'title': title,
            },
            'notification': <String, dynamic>{
              'title': title,
              'body': body,
            },
            'to': fcmToken,
          },
        ),
      );
      sendNoti = 'success';
    } catch (e) {
      sendNoti = e.toString();
    }

    return sendNoti;
  }
}

@pragma("vm:entry-point")
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  await NotificationServices().setupFlutterNotifications();
  NotificationServices().showFlutterNotification(message);

  print("Handling a background message ${message.messageId}");
}
