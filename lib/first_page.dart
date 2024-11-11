import 'package:flutter/material.dart';

class FirstPage extends StatefulWidget {
  const FirstPage({super.key});

  @override
  State<FirstPage> createState() => _FirstPageState();
}

class _FirstPageState extends State<FirstPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Firebase Messaging Example"),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () async {
            // Burada token'ı gerçek bir cihaz token'ı ile değiştirin.
            String exampleToken = "your token";
            print("FCM Token: $exampleToken");
          },
          child: const Text('Get Token'),
        ),
      ),
    );
  }
}
