import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_event.dart';
import '../bloc/auth_state.dart';
import '../core/services/local_notification_service.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AuthBloc>().state;

    String email = "";
    String password = "";

    if (state is AuthAuthenticated) {
      email = state.email;
      password = state.password;
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Home"),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              context.read<AuthBloc>().add(LogoutEvent());
            },
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [

            Text("Email: $email"),
            const SizedBox(height: 8),
            Text("Password: $password"),

            const SizedBox(height: 30),

            ElevatedButton(
              onPressed: () {
                LocalNotificationService.showNotification();
              },
              child: const Text("Show Notification"),
            ),

            const SizedBox(height: 20),

            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
              ),
              onPressed: () {
                context.read<AuthBloc>().add(LogoutEvent());
              },
              child: const Text("Logout"),
            ),
          ],
        ),
      ),
    );
  }
}