import 'package:capstone_sams/declare/ValueDeclaration.dart';
import 'package:capstone_sams/global-widgets/TitleAppBar.dart';
import 'package:capstone_sams/models/patient.dart';
import 'package:capstone_sams/providers/patient_provider.dart';
import 'package:capstone_sams/screens/ehr-list/widgets/patient_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:capstone_sams/theme/pallete.dart';

class EHRListScreen extends StatefulWidget {
  @override
  State<EHRListScreen> createState() => _EHRListScreenState();
}

class _EHRListScreenState extends State<EHRListScreen> {
  late Future<List<Patient>> patients;

  @override
  void initState() {
    super.initState();
    patients = context.read<PatientProvider>().fetchPatients();
  }

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
      body: FutureBuilder(
        future: patients,
        builder: (context, snapshot) {
          if (!snapshot.hasData) return const CircularProgressIndicator();
          return ListView.builder(
            itemCount: snapshot.data?.length,
            itemBuilder: (context, index) {
              final patient = snapshot.data![index];
              return PatientCard(patient: patient);
            },
          );
        },
      ),
    );
  }
}
