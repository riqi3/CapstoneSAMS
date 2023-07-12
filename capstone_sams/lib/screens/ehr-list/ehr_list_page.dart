import 'package:capstone_sams/constants/Dimensions.dart';
import 'package:capstone_sams/declare/ValueDeclaration.dart';
import 'package:capstone_sams/global-widgets/TitleAppBar.dart';
import 'package:capstone_sams/models/patient.dart';
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
            text: 'Health Records',
            iconColor: Pallete.whiteColor,
            backgroundColor: Pallete.mainColor),
        preferredSize: Size.fromHeight(kToolbarHeight),
      ),
      body: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
        if (constraints.maxWidth >= Dimensions.tabletWidth) {
          return _tabletView(patientList);
        } else {
          return _mobileView(patientList);
        }
      }),
    );
  }

  // ListView _tabletView(List<Patient> patientList) {
  //   return ListView.builder(
  //     itemCount: patientList.length,
  //     itemBuilder: (context, index) {
  //       final patient = patientList[index];
  //       return PatientCard(patient: patient);
  //     },
  //   );
  // }

  GridView _tabletView(List<Patient> patientList) {
    return GridView.count(
      crossAxisCount: 2,
      children: List.generate(
        patientList.length,
        (index) {
          final patient = patientList[index];
          return PatientCard(patient: patient);
        },
      ),
    );
  }

  ListView _mobileView(List<Patient> patientList) {
    return ListView.builder(
      itemCount: patientList.length,
      itemBuilder: (context, index) {
        final patient = patientList[index];
        return PatientCard(patient: patient);
      },
    );
  }
}
