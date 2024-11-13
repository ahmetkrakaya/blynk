import 'package:blynk/notification_service.dart';
import 'package:blynk/send_notification_service.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final NotificationServices _notificationServices = NotificationServices();
  final SendNotificationService _sendNotificationService = SendNotificationService();

  @override
  void initState() {
    super.initState();
    _notificationServices.initialize(context);
  }

  @override
  Widget build(BuildContext context) {
    String _targetDeviceToken =
        'eCWbN5ZmQUCUurr2ed-PKp:APA91bGPfBOFjPROQvEhO9ygvmio4M9Bw4ZdNWhoWNgQMPn6rAqYobCSe_EbANzonxGEhpvQY9I8M7gJrP8w_cRwwVGb8Yp0Fc7DBPLsHgcagAs7hyoSFhU';
    //'cDD_MWWuTC-avDdTZZds9A:APA91bHY8yYRrcTMvdRe4X4RWS1ausJqknJtkXYkz5Eiquu9MKYnV5YVjKdP2X-wH7oXIN9Uk53Ds0tcOKgtv5SGrdB6dJzckWX7oH4ftYY9sotqJuLMXyU';
    String _title = 'Test Notification';
    String _body = 'This is a test message from Flutter app.';

    return Scaffold(
      appBar: AppBar(
        title: const Text("Home Screen"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'Bildirim Gönder',
            ),
            ElevatedButton(
                onPressed: () async {
                  await _sendNotificationService.sendPushNotification(_targetDeviceToken, _title, _body);
                },
                child: const Text('Gönder')),
          ],
        ),
      ),
    );
  }
}
