import 'package:capstone_sams/constants/theme/pallete.dart';
import 'package:capstone_sams/providers/AccountProvider.dart';
import 'package:capstone_sams/providers/ContactPersonProvider.dart';
import 'package:capstone_sams/providers/HealthRecordProvider.dart';
import 'package:capstone_sams/providers/LabResultProvider.dart';
import 'package:capstone_sams/providers/MedicalRecordProvider.dart';
import 'package:capstone_sams/providers/MedicineProvider.dart';
import 'package:capstone_sams/providers/PatientProvider.dart';
import 'package:capstone_sams/providers/PrescriptionProvider.dart';
import 'package:capstone_sams/providers/SymptomsFieldsProvider.dart';
import 'package:capstone_sams/screens/authentication/LoginScreen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/MedicalNotesProvider.dart';

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
        ChangeNotifierProvider<LabresultProvider>(
          create: (context) => LabresultProvider(),
        ),
        ChangeNotifierProvider<PrescriptionProvider>(
          create: (context) => PrescriptionProvider(),
        ),
        ChangeNotifierProvider<HealthRecordProvider>(
          create: (context) => HealthRecordProvider(),
        ),
        ChangeNotifierProvider<ContactPersonProvider>(
          create: (context) => ContactPersonProvider(),
        ),
        ChangeNotifierProvider<MedicalRecordProvider>(
          create: (context) => MedicalRecordProvider(),
        ),
      ],
      child: const SAMSApp(),
    ),
  );
}

class SAMSApp extends StatelessWidget {
  const SAMSApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Capstone S.A.M.S. Prototype',
      theme: ThemeData(
        textButtonTheme: TextButtonThemeData(
          style: ButtonStyle(
            foregroundColor: MaterialStateProperty.all(
              Pallete.greyColor,
            ),
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(
              Pallete.mainColor,
            ),
            foregroundColor: MaterialStateProperty.all(
              Pallete.whiteColor,
            ),
          ),
        ),
        cardTheme: CardTheme(
          color: Pallete.whiteColor,
        ),
        dialogBackgroundColor: Pallete.whiteColor,
        scaffoldBackgroundColor: Pallete.backgroundColor,
        floatingActionButtonTheme: FloatingActionButtonThemeData(
          backgroundColor: Pallete.mainColor,
          foregroundColor: Pallete.whiteColor,
        ),
      ),
      home: const LoginScreen(),
    );
  }
}
