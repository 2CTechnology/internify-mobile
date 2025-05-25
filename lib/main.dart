// ignore_for_file: use_key_in_widget_constructors, deprecated_member_use

import 'package:flutter/material.dart';
import 'package:simag_app/app/constant/url.dart';

import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:simag_app/app/data/db_provider.dart';
import 'package:simag_app/app/modules/home/controllers/home_controller.dart';
import 'package:simag_app/app/modules/navigation_bar/controllers/navigation_bar_controller.dart';
import 'package:simag_app/app/modules/navigation_bar/views/navigation_bar_view.dart';
import 'package:simag_app/app/modules/profile/controllers/profile_controller.dart';
import 'package:simag_app/app/provider/auth_provider.dart';
import 'package:simag_app/app/routes/app_pages.dart';
import 'package:simag_app/utils/app_theme.dart';
import 'package:firebase_core/firebase_core.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'package:simag_app/app/modules/notification/notif_service.dart';

void main() async {
  //buat get
  Get.put(NavigationBarController());
  Get.put(DatabaseProvider());
  WidgetsFlutterBinding.ensureInitialized();

  // // firebase
  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  getToken();

  // // Inisialisasi plugin local notification
  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('@mipmap/launcher_icon');
  final InitializationSettings initializationSettings =
      InitializationSettings(android: initializationSettingsAndroid);

  await flutterLocalNotificationsPlugin.initialize(initializationSettings);

  //Listen to foreground messages and show local notification
  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    print('📨 Notifikasi diterima: ${message.notification?.title}');
    _showLocalNotification(message);
  });

  runApp(MyApp());
}

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  _showLocalNotification(message);
  print("Pesan background: ${message.notification?.title}");
  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    if (message.notification != null) {
      print("📩 Notification: ${message.notification!.title}");
      Get.snackbar(
        message.notification!.title ?? 'Notifikasi',
        message.notification!.body ?? '',
        snackPosition: SnackPosition.TOP,
      );
    }
  });
}

FirebaseMessaging messaging = FirebaseMessaging.instance;

void getToken() async {
  final fcmToken = await FirebaseMessaging.instance.getToken();
  print("📱 FCM Token: $fcmToken");

  final dbProvider = Get.put(DatabaseProvider());
  final loginToken =
      await dbProvider.getToken(); // ✅ Ambil token login user yang valid

  if (fcmToken != null && loginToken != null) {
    final url = Uri.parse('${AppUrl.baseUrl}/save-fcm-token');

    final response = await http.post(
      url,
      headers: {
        'Authorization': 'Bearer $loginToken', // ✅ pakai token dari login user
        'Content-Type': 'application/json',
      },
      body: jsonEncode({'fcm_token': fcmToken}),
    );

    print(
        "✅ FCM token sent. Status: ${response.statusCode}, Body: ${response.body}");
  } else {
    print("❌ Token FCM atau Login tidak tersedia.");
  }
}

//local notification
void _showLocalNotification(RemoteMessage message) async {
  RemoteNotification? notification = message.notification;
  AndroidNotification? android = message.notification?.android;

  if (notification != null && android != null) {
    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
      'jadwal_bimbingan_channel',
      'Jadwal Bimbingan',
      channelDescription: 'Notifikasi untuk jadwal bimbingan',
      importance: Importance.max,
      priority: Priority.high,
      ticker: 'ticker',
    );

    const NotificationDetails platformDetails =
        NotificationDetails(android: androidDetails);

    await flutterLocalNotificationsPlugin.show(
      notification.hashCode,
      notification.title,
      notification.body,
      platformDetails,
    );
  }
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthenticationProvider()),
        ChangeNotifierProvider(create: (_) => DatabaseProvider()),
        ChangeNotifierProvider(create: (_) => HomeController()),
        ChangeNotifierProvider(create: (_) => ProfileController()),
      ],
      child: GetMaterialApp(
        debugShowCheckedModeBanner: false,
        title: "SIMAG",
        defaultTransition: Transition.native,
        theme: appTheme,
        initialRoute: Routes.SPLASH_SCREEN,
        getPages: AppPages.routes,
        home: NavigationBarView(),
      ),
    );
  }
}
