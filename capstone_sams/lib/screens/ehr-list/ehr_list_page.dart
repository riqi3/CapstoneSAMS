import 'package:capstone_sams/declare/ValueDeclaration.dart';
import 'package:capstone_sams/global-widgets/TitleAppBar.dart';
import 'package:capstone_sams/models/patient.dart';
import 'package:capstone_sams/providers/patient_provider.dart';
import 'package:capstone_sams/screens/ehr-list/widgets/patient_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:capstone_sams/theme/pallete.dart';

import '../../theme/sizing.dart';

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
          if (!snapshot.hasData)
            return Center(
              child: const CircularProgressIndicator(),
            );

          return Padding(
            padding: const EdgeInsets.all(Sizing.sectionSymmPadding),
            child: GridView.builder(
              itemCount: snapshot.data?.length,
              itemBuilder: (context, index) {
                final patient = snapshot.data![index];
                return PatientCard(patient: patient);
              },
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
                childAspectRatio: 16 / 8,
              ),
              // gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
              //   maxCrossAxisExtent: 500,
              //   childAspectRatio: 16 / 8,
              //   crossAxisSpacing: 5,
              //   mainAxisSpacing: 5,
              // ),
            ),
          );

          // return ListView.builder(
          //   itemCount: snapshot.data?.length,
          //   itemBuilder: (context, index) {
          //     final patient = snapshot.data![index];
          //     return PatientCard(patient: patient);
          //   },
          // );
        },
      ),

      // FutureBuilder(
      //   future: patients,
      //   builder: (context, snapshot) {
      //     if (!snapshot.hasData) return const CircularProgressIndicator();
      //     return ListView.builder(
      //       itemCount: snapshot.data?.length,
      //       itemBuilder: (context, index) {
      //         final patient = snapshot.data![index];
      //         return PatientCard(patient: patient);
      //       },
      //     );
      //   },
      // ),
    );
  }
}
