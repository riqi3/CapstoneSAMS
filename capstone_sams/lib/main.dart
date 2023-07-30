import 'package:capstone_sams/providers/AccountProvider.dart';
import 'package:capstone_sams/providers/MedicineProvider.dart';
import 'package:capstone_sams/providers/PatientProvider.dart';

import 'package:capstone_sams/providers/SymptomsFieldsProvider.dart';
import 'package:capstone_sams/screens/authentication/LoginScreen.dart';
import 'package:capstone_sams/screens/home/HomeScreen.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'providers/MedicalNotesProvider.dart';

import 'theme/AppTheme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => AccountProvider(),
          child: const SAMSApp(),
        ),
        ChangeNotifierProvider(
          create: (context) => PatientProvider(),
          child: const SAMSApp(),
        ),
        ChangeNotifierProvider(
          create: (context) => TodosProvider(),
          child: const SAMSApp(),
        ),
        ChangeNotifierProvider<MedicineProvider>(
          create: (context) => MedicineProvider(),
        ),
        ChangeNotifierProvider<SymptomFieldsProvider>(
          create: (context) => SymptomFieldsProvider(),
        ),
      ],
      child: const SAMSApp(),
    ),
  );
}

class SAMSApp extends StatelessWidget {
  const SAMSApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Capstone S.A.M.S. Prototype',
      theme: AppTheme.theme,
      home: const LoginScreen(),
    );
  }
}
