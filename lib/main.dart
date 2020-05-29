import 'dart:isolate';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:wakeup_kid/screens/about/about.dart';
import 'screens/homepage/home_page.dart';
import 'screens/splash/splash.dart';

const String isolateName = 'wakeup_kid_isolate_name';

final ReceivePort port = ReceivePort();

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  IsolateNameServer.registerPortWithName(
    port.sendPort,
    isolateName,
  );

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'WakeUp Kid!',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primaryColor: Colors.lightBlue[800],
        accentColor: Colors.cyan[600],
        // This makes the visual density adapt to the platform that you run
        // the app on. For desktop platforms, the controls will be smaller and
        // closer together (more dense) than on mobile platforms.
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => Splash(),
        '/home': (context) => HomePage(title: 'WakeUp Kid!'),
        '/about': (context) => AboutPage(),
      },
    );
  }
}
