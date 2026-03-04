import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import '../../firebase_options.dart';

class FirebaseService {
  static Future<void> initialize() async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    await FirebaseAnalytics.instance.logAppOpen();

    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    await _requestPermission();
    await _printFCMToken();

    FirebaseMessaging.instance.onTokenRefresh.listen((newToken) {
      print("Refreshed FCM Token: $newToken");
    });
    
// push notification on foreground
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
  print("Foreground message received");

  if (message.notification != null) {
    print("Title: ${message.notification!.title}");
    print("Body: ${message.notification!.body}");
  }
});
  }

  static Future<void> _requestPermission() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;

    NotificationSettings settings = await messaging.requestPermission();

    print('Permission status: ${settings.authorizationStatus}');
  }

  static Future<void> _printFCMToken() async {
    String? token = await FirebaseMessaging.instance.getToken();
    print("FCM Token: $token");
  }
// getting the fcm token
  static Future<String?> getFCMToken() async {
    return await FirebaseMessaging.instance.getToken();
  }
  
}

// background push notification
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  print("Background message: ${message.messageId}");
}
