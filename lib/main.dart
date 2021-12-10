import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:flutter/widgets.dart';
import 'package:social_network_front/ui/pages/splash/splash_page.dart';

// !!!!!!!!!!!!!!!! DEV ONLY !!!!!!!!!!!!!!!!
class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}


void main() async {
  HttpOverrides.global = MyHttpOverrides();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  bool _initialized = false;

  void initializeFlutterFire() async {
    try {
      // Wait for Firebase to initialize and set `_initialized` state to true
      await Firebase.initializeApp();
      setState(() {
        _initialized = true;
      });
    } catch(e) {
      // Set `_error` state to true if Firebase initialization fails
      setState(() {
        _initialized = false;
      });
    }
  }

  @override
  void initState() {
    initializeFlutterFire();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    if (_initialized) {
      return MaterialApp(
        themeMode: ThemeMode.system,
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.deepPurple,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        title: 'Keen of Arts',
        home: const SplashPage(),
      );
    }

    else {
      return Container(
        alignment: Alignment.center,
        child: const Text(
          'Error!',
          style: const TextStyle(color: Colors.yellow),
          textDirection: TextDirection.ltr,
        ),
      );
    }

  }
}


