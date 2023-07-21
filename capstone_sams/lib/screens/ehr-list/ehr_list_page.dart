import 'package:capstone_sams/constants/Dimensions.dart';
import 'package:capstone_sams/declare/ValueDeclaration.dart';
import 'package:capstone_sams/global-widgets/TitleAppBar.dart';
import 'package:capstone_sams/models/patient.dart';
import 'package:capstone_sams/providers/patient_provider.dart';
import 'package:capstone_sams/screens/ehr-list/widgets/patient_card.dart';
import 'package:capstone_sams/screens/patient-record/PatientRecordScreen.dart';
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
            // text: '',
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
            padding: const EdgeInsets.only(
              left: Sizing.sectionSymmPadding,
              right: Sizing.sectionSymmPadding,
              top: Sizing.sectionSymmPadding,
            ),
            child: LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constraints) {
                if (constraints.maxWidth >= Dimensions.mobileWidth) {
                  return _tabletView(snapshot);
                } else {
                  return _mobileView(snapshot);
                }
              },
            ),
          );
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

  // ListView _mobileView(AsyncSnapshot<List<Patient>> snapshot) {
  //   return ListView.builder(
  //     itemCount: snapshot.data?.length,
  //     itemBuilder: (context, index) {
  //       final patient = snapshot.data![index];
  //       return PatientCard(patient: patient);
  //     },
  //   );
  // }

  GridView _mobileView(AsyncSnapshot<List<Patient>> snapshot) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const BouncingScrollPhysics(),
      itemCount: snapshot.data?.length,
      itemBuilder: (context, index) {
        final patient = snapshot.data![index];
        return PatientCard(patient: patient);
      },
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 1,
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
        childAspectRatio: 16 / 8,
      ),
    );
  }

  GridView _tabletView(AsyncSnapshot<List<Patient>> snapshot) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const BouncingScrollPhysics(),
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
    );
  }
}
