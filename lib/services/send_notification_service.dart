import 'dart:convert';

//import 'package:blynk/firebase_access_token.dart';
import 'package:http/http.dart' as http;

class SendNotificationService {
  //FirebaseAccessToken firebaseAccessToken = FirebaseAccessToken();

  Future<void> sendPushNotification(String token, String title, String body) async {
    final Uri url = Uri.parse('https://sendnotification-ifjejdsnmq-uc.a.run.app');

    var response = await http.post(
      url,
      body: json.encode({
        'token': token, // Cihaz B'nin token'ı
        'title': title,
        'body': body,
      }),
      headers: {
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      print("Bildirim başarıyla gönderildi");
    } else {
      print("Bildirim gönderilemedi");
    }
  }

  // Future<void> sendPushNotification(String token, String title, String body) async {
  //   String _accessToken = await firebaseAccessToken.getToken();

  //   final String fcmUrl = 'https://fcm.googleapis.com/v1/projects/blynk-80b4a/messages:send';

  //   final Map<String, dynamic> notificationData = {
  //     "message": {
  //       "token": token, // Bildirim göndereceğiniz cihazın token'ı
  //       "notification": {
  //         "title": title, // Bildirim başlığı
  //         "body": body, // Bildirim metni
  //       },
  //     }
  //   };

  //   final response = await http.post(
  //     Uri.parse(fcmUrl),
  //     headers: {
  //       'Content-Type': 'application/json',
  //       'Authorization': 'Bearer $_accessToken', // OAuth 2.0 erişim token'ı
  //     },
  //     body: json.encode(notificationData),
  //   );

  //   if (response.statusCode == 200) {
  //     print("Notification sent successfully!");
  //   } else {
  //     print("Failed to send notification: ${response.body}");
  //   }
  // }
}
