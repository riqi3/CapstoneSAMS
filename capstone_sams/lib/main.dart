import 'package:capstone_sams/screens/authentication/LoginScreen.dart';
import 'package:flutter/material.dart';

import 'screens/home/HomeScreen.dart';
import 'theme/app_theme.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Capstone S.A.M.S. Prototype',
      theme: AppTheme.theme,
      home: const HomeScreen( ),
    );
  }
}
