import 'package:flutter/material.dart';
import '../core/services/local_notification_service.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Home")),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            LocalNotificationService.showNotification();
          },
          child: const Text("Show Notification"),
        ),
      ),
    );
  }
}