import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_01/core/auth/auth_wrapper.dart';
import 'package:flutter_app_01/screens/signup.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'bloc/auth_bloc.dart';
import 'bloc/auth_event.dart';
import 'bloc/auth_state.dart';

import 'screens/login.dart';
import 'screens/homepage.dart';

import 'core/services/firebase_service.dart';
import 'core/services/local_notification_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 🔥 Initialize Firebase
  await FirebaseService.initialize();

  // 🔔 Initialize Local Notifications
  await LocalNotificationService.initialize();

  runApp(const MyApp());
  print(FirebaseAuth.instance.currentUser);
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => AuthBloc()..add(CheckAuthStatus()),
      child: const MaterialApp(
        debugShowCheckedModeBanner: false,
        home: AuthWrapper(),
      ),
    );
  }
}
