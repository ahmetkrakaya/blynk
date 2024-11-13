import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationServices {
  // Firebase Mesajlaşma servisini başlatır
  FirebaseMessaging messaging = FirebaseMessaging.instance;

  // Cihazda yerel bildirimleri göstermek için kullanılan Flutter plugin'i
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  // Firebase, bildirim izinleri, arka planda mesaj dinleyicileri vb. işlemleri başlatmak için çağrılan ana fonksiyon
  Future<void> initialize(BuildContext context) async {
    await requestNotificationPermissions();
    await foreGroundMessage();
    firebaseInit(context);
    await setupInteractMessage(context);
    isRefreshToken();
    String token = await getDeviceToken();
    print(token);
  }

  // Cihazın Firebase token'ını almak için kullanılır
  Future<String> getDeviceToken() async {
    String? token = await messaging.getToken();
    return token!;
  }

  // Firebase token'ı yenilendiğinde yapılacak işlemi dinler
  void isRefreshToken() async {
    messaging.onTokenRefresh.listen((event) {
      event.toString();
    });
  }

  // Uygulama, cihazın bildirim göndermesi için gerekli izinleri alır (özellikle iOS'ta)
  Future<void> requestNotificationPermissions() async {
    if (Platform.isIOS) {
      await messaging.requestPermission(
        alert: true,
        announcement: true,
        badge: true,
        carPlay: true,
        criticalAlert: true,
        provisional: true,
        sound: true,
      );
    }
  }

  // Uygulama ön planda iken bildirimin nasıl gösterileceğiyle ilgili ayarlar yapar
  Future foreGroundMessage() async {
    await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );
  }

  // Firebase mesajlaşma servisi ile mesajları dinler ve bildirimi gösterir
  void firebaseInit(BuildContext context) {
    FirebaseMessaging.onMessage.listen((message) {
      RemoteNotification? notification = message.notification;

      if (Platform.isIOS) {
        foreGroundMessage();
      }

      if (Platform.isAndroid) {
        initLocalNotifications(context, message);
        showNotification(message);
      }
    });
  }

  // Yerel bildirimleri başlatır ve konfigüre eder
  void initLocalNotifications(BuildContext context, RemoteMessage message) async {
    var androidInitSettings = const AndroidInitializationSettings('@mipmap/ic_launcher');
    var iosInitSettings = const DarwinInitializationSettings();

    var initSettings = InitializationSettings(
      android: androidInitSettings,
      iOS: iosInitSettings,
    );

    // Bildirimlere tıklanma olayını dinler ve tıklama olduğunda handleMessage fonksiyonunu çağırır
    await _flutterLocalNotificationsPlugin.initialize(initSettings, onDidReceiveNotificationResponse: (payload) {
      handleMessage(context, message); // Bildirim tıklandığında mesajı işler
    });
  }

  // Bildirime tıklandığında yapılacak işlemi tanımlar
  void handleMessage(BuildContext context, RemoteMessage message) {
    if (message.data['type'] == 'text') {
      // Yeni bir ekrana yönlendirme veya farklı bir işlem yapılabilir
    }
  }

  // Bildirimi kullanıcıya göstermek için ayarları yapar
  Future<void> showNotification(RemoteMessage message) async {
    AndroidNotificationChannel androidNotificationChannel = AndroidNotificationChannel(
      message.notification!.android!.channelId ?? 'default_channel',
      message.notification!.android!.channelId ?? 'default_channel',
      importance: Importance.max,
      showBadge: true,
      playSound: true,
    );

    // Android bildirim ayarları
    AndroidNotificationDetails androidNotificationDetails = AndroidNotificationDetails(
      androidNotificationChannel.id,
      androidNotificationChannel.name,
      channelDescription: 'Flutter Notifications',
      importance: Importance.max,
      priority: Priority.high,
      playSound: true,
      ticker: 'ticker', // Ticker (ekranın alt kısmında kısa açıklama)
      sound: androidNotificationChannel.sound,
    );

    // iOS bildirim ayarları
    const DarwinNotificationDetails darwinNotificationDetails =
        DarwinNotificationDetails(presentAlert: true, presentBadge: true, presentSound: true);

    NotificationDetails notificationDetails = NotificationDetails(
      android: androidNotificationDetails,
      iOS: darwinNotificationDetails,
    );

    // Bildirimi ekranda gösterir
    _flutterLocalNotificationsPlugin.show(
      0,
      message.notification!.title ?? 'No Title',
      message.notification!.body ?? 'No Body',
      notificationDetails,
    );
  }

  // Uygulama açıldığında veya bildirim tıklama olaylarında yapılacak işlemleri ayarlar
  Future<void> setupInteractMessage(BuildContext context) async {
    // Uygulama açıldığında alınan ilk mesaj
    RemoteMessage? initialMessage = await FirebaseMessaging.instance.getInitialMessage();

    if (initialMessage != null) {
      handleMessage(context, initialMessage);
    }

    // Uygulama arka planda iken bildirime tıklanırsa yapılacak işlemleri dinler
    FirebaseMessaging.onMessageOpenedApp.listen((event) {
      handleMessage(context, event);
    });
  }
}
