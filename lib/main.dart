import 'package:flutter/material.dart';
import 'package:flutter_app_01/screens/homepage.dart';
import 'core/services/firebase_service.dart';
import 'core/services/local_notification_service.dart';
// import 'home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await FirebaseService.initialize();
  await LocalNotificationService.initialize();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: HomeScreen(),
    );
  }
}