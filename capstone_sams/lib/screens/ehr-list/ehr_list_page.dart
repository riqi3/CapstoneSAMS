import 'package:capstone_sams/declare/ValueDeclaration.dart';
import 'package:capstone_sams/global-widgets/TitleAppBar.dart';
import 'package:capstone_sams/providers/patient_provider.dart';
import 'package:capstone_sams/screens/ehr-list/widgets/patient_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:capstone_sams/theme/pallete.dart';

class EHRListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final patientProvider = Provider.of<PatientProvider>(context);
    final patientList = patientProvider.patientList;

    return Scaffold(
      endDrawer: ValueDashboard(),
      appBar: PreferredSize(
        child: TitleAppBar(
            text: 'Electronic Health Records',
            iconColor: Pallete.whiteColor,
            backgroundColor: Pallete.mainColor),
        preferredSize: Size.fromHeight(kToolbarHeight),
      ),
      body: ListView.builder(
        itemCount: patientList.length,
        itemBuilder: (context, index) {
          final patient = patientList[index];
          return PatientCard(patient: patient);
        },
      ),
    );
  }
}
