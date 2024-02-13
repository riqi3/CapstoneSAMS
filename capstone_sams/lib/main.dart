import 'package:capstone_sams/constants/theme/pallete.dart';
import 'package:capstone_sams/global-widgets/forms/healthcheckscreen.dart';
import 'package:capstone_sams/providers/AccountProvider.dart';
import 'package:capstone_sams/providers/ContactPersonProvider.dart';
import 'package:capstone_sams/providers/HealthRecordProvider.dart';
import 'package:capstone_sams/providers/LabResultProvider.dart';
import 'package:capstone_sams/providers/MedicalRecordProvider.dart';
import 'package:capstone_sams/providers/MedicineProvider.dart';
import 'package:capstone_sams/providers/PatientProvider.dart';
import 'package:capstone_sams/providers/PrescriptionProvider.dart';
import 'package:capstone_sams/providers/PresentIllnessProvider.dart';
import 'package:capstone_sams/providers/SymptomsFieldsProvider.dart';
import 'package:capstone_sams/providers/healthcheckprovider.dart';
import 'package:capstone_sams/screens/authentication/LoginScreen.dart';
import 'package:capstone_sams/screens/ehr-list/EHRListScreen.dart';
import 'package:capstone_sams/screens/ehr-list/widgets/PatientCard.dart';
import 'package:capstone_sams/screens/home/HomeScreen.dart';
import 'package:capstone_sams/screens/medical_notes/MedicalNotesScreen.dart';
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
        ChangeNotifierProvider<HealthCheckProvider>(
          create: (context) => HealthCheckProvider(),
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
        ChangeNotifierProvider<PresentIllnessProvider>(
          create: (context) => PresentIllnessProvider(),
        ),
      ],
      child: const SAMSApp(),
    ),
  );
}

// final GoRouter _router = GoRouter(
//   routes: <RouteBase>[
//     GoRoute(
//       path: '/',
//       builder: (BuildContext context, GoRouterState state) {
//         return const LoginScreen();
//       },
//       routes: <RouteBase>[
//         GoRoute(
//           path: 'home',
//           builder: (BuildContext context, GoRouterState state) {
//             return const HomeScreen();
//           },
//           routes: <RouteBase>[
//             GoRoute(
//               path: 'ehr_list',
//               builder: (BuildContext context, GoRouterState state) {
//                 return EhrListScreen();
//               },
//             ),
//             GoRoute(
//               path: 'med_notes',
//               builder: (BuildContext context, GoRouterState state) {
//                 return MedicalNotes();
//               },
//             ),
//           ],
//         ),
//         GoRoute(
//           path: 'ehr_list',
//           builder: (BuildContext context, GoRouterState state) {
//             return EhrListScreen();
//           },
//         ),
//         GoRoute(
//           path: 'med_notes',
//           builder: (BuildContext context, GoRouterState state) {
//             return MedicalNotes();
//           },
//         ),
//       ],
//     ),
//   ],
// );

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
      // home: const LoginScreen(),
      initialRoute: '/',
      routes: {
        '/': (context) => LoginScreen(),
        '/home': (context) => HomeScreen(),
        '/ehr_list': (context) => EhrListScreen(),
        '/med_notes': (context) => MedicalNotes(),

        // 'home': (context) => HomeScreen(),
      },
      // routerConfig: _router,
    );
  }
}
