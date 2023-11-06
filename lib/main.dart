import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueAccent),
        useMaterial3: true,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
  @override
  void initState() {
    // Initialise FlutterLocalNotificationsPlugin
    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

    // Ask for permission
    flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()?.requestNotificationsPermission();

    // Setup AndroidInitializationSettings
    const AndroidInitializationSettings initializationSettingsAndroid = AndroidInitializationSettings('secondary_icon');

    // Setup InitializationSettings with above AndroidInitializationSettings
    const InitializationSettings initializationSettings = InitializationSettings(android: initializationSettingsAndroid);

    // Initialise plugin with above InitializationSettings
    // Add a custom method to `onDidReceiveNotificationResponse` to handle notification on tap
    // Default opens the app
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      await flutterLocalNotificationsPlugin.initialize(initializationSettings, onDidReceiveNotificationResponse: null);
    });
    super.initState();
  }

  showNotification() async {
    // Setup android notification with custom sound

    const AndroidNotificationDetails androidNotificationDetails = AndroidNotificationDetails(
      // ChannelID and ChannelName is set when you first install
      // If you change sound but above two params remain same, changes wont be reflected
      // Refer ⚠️ at https://github.com/MaikuB/flutter_local_notifications/tree/master/flutter_local_notifications#custom-notification-icons-and-sounds
      // Uninstall app from device then reinstall for changes to take effect.
      'channelID',
      'channelName',
      channelDescription: 'your channel desc',
      importance: Importance.max,
      priority: Priority.high,
      icon: "secondary_icon",
      // Sound can be changed at 'app/src/main/res/raw'
      // Also change name in keep.xml
      sound: RawResourceAndroidNotificationSound('samplesound')
    );
    const NotificationDetails notificationDetails = NotificationDetails(android: androidNotificationDetails);
    await flutterLocalNotificationsPlugin.show(
        2,
        'Notification with custom sound',
        'Notification body',
        notificationDetails,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: FloatingActionButton.extended(
          onPressed: () async{
            await showNotification();
          },
          icon: const Icon(Icons.notifications_active_outlined),
          label: const Text('Show notification'),
        ),
      ),
    );
  }
}
