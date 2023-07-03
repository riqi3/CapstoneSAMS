import 'package:capstone_sams/declare/ValueDeclaration.dart';
import 'package:capstone_sams/global-widgets/TitleAppBar.dart';
import 'package:capstone_sams/screens/patient-record/PatientRecordScreen.dart';
import 'package:capstone_sams/theme/pallete.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class EHRListScreen extends StatelessWidget {
  const EHRListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      endDrawer: ValueDashboard(),
      appBar: PreferredSize(
        child: TitleAppBar(
            text: 'Electronic Health Records',
            iconColor: Pallete.whiteColor,
            backgroundColor: Pallete.mainColor),
        preferredSize: Size.fromHeight(kToolbarHeight),
      ),
      body: TextButton(
        child: Text('GO TO PATIENT RECORD'),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const PatientRecordScreen(),
            ),
          );
        },
      ),
    );
  }
}
