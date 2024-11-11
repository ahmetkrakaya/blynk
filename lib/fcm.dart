import 'package:firebase_messaging/firebase_messaging.dart';

class FCMService {
  // Firebase Cloud Messaging'i başlatıyoruz
  static Future<void> initializeFirebase() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;

    // Bildirim izni isteme (kullanıcı izni gereklidir)
    await requestNotificationPermission();

    // Firebase Messaging'i başlat
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('Received a message: ${message.notification?.title}');
      // Gelen bildirimde yapılacak işlemleri burada yazabilirsiniz
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('Message clicked!');
      // Uygulama açıldığında yapılacak işlemler
    });

    // FCM token'ını al
    String? fcmToken = await messaging.getToken();
    if (fcmToken != null) {
      print("FCM Token: $fcmToken");
    } else {
      print("FCM token couldn't be retrieved.");
    }
  }

  // Bildirim izni isteme
  static Future<void> requestNotificationPermission() async {
    NotificationSettings settings = await FirebaseMessaging.instance.requestPermission(provisional: true);
    print("Permission granted: ${settings.authorizationStatus}");
  }
}
