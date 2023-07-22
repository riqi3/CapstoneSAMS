import 'package:capstone_sams/providers/medicine_provider.dart';
import 'package:capstone_sams/providers/patient_provider.dart';
import 'package:capstone_sams/providers/symptoms_fields_provider.dart';
import 'package:capstone_sams/screens/home/HomeScreen.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'providers/medical_notes_provider.dart';
import 'theme/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(
    MultiProvider(
      providers: [
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
      home: const HomeScreen(),
    );
  }
}
