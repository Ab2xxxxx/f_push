import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

// Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
//   print('Фоновое сообщение: ${message.messageId}');
// }

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  // FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MessageScreen(),
    );
  }
}

class MessageScreen extends StatefulWidget {
  @override
  _MessageScreenState createState() => _MessageScreenState();
}

class _MessageScreenState extends State<MessageScreen> {
  String? _message;

  @override
  void initState() {
    super.initState();
    FirebaseMessaging messaging = FirebaseMessaging.instance;
    messaging.requestPermission();
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      setState(() {
        _message = message.notification?.body;
      });
    });
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      setState(() {
        _message = message.notification?.body;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Полученные сообщения')),
      body: Center(
        child: Text(
          _message ?? 'Ожидается сообщение...',
          style: TextStyle(fontSize: 18),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
