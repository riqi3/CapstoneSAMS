import 'package:capstone_sams/constants/Dimensions.dart';
import 'package:capstone_sams/declare/ValueDeclaration.dart';
import 'package:capstone_sams/global-widgets/TitleAppBar.dart';
import 'package:capstone_sams/models/PatientModel.dart';

import 'package:capstone_sams/screens/ehr-list/widgets/PatientCard.dart';

import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:capstone_sams/theme/pallete.dart';

import '../../providers/PatientProvider.dart';
import '../../theme/sizing.dart';

class EhrListScreen extends StatefulWidget {
  @override
  State<EhrListScreen> createState() => _EhrListScreenState();
}

class _EhrListScreenState extends State<EhrListScreen> {
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
            text: 'Health Records',
            // text: '',
            iconColorLeading: Pallete.whiteColor,
            iconColorTrailing: Pallete.whiteColor,
            backgroundColor: Pallete.mainColor),
        preferredSize: Size.fromHeight(kToolbarHeight),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.only(
          left: Sizing.sectionSymmPadding,
          right: Sizing.sectionSymmPadding,
          top: Sizing.sectionSymmPadding * 2,
          bottom: Sizing.sectionSymmPadding * 4,
        ),
        scrollDirection: Axis.vertical,
        physics: BouncingScrollPhysics(),
        child: FutureBuilder(
          future: patients,
          builder: (context, snapshot) {
            if (!snapshot.hasData)
              return Center(
                child: const CircularProgressIndicator(),
              );
            return LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constraints) {
                if (constraints.maxWidth >= Dimensions.mobileWidth) {
                  return _tabletView(snapshot);
                } else {
                  return _mobileView(snapshot);
                }
              },
            );
          },
        ),
      ),
    );
  }

  GridView _mobileView(AsyncSnapshot<List<Patient>> snapshot) {
    return GridView.builder(
      shrinkWrap: true,
      padding: EdgeInsets.only(),
      physics: const BouncingScrollPhysics(),
      itemCount: snapshot.data?.length,
      itemBuilder: (context, index) {
        final patient = snapshot.data![index];
        return PatientCard(patient: patient, index: (index + 1));
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
        // print('aasdasasd${a.toString()}');
        return PatientCard(patient: patient, index: (index + 1) );
      },
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
        childAspectRatio: 16 / 10,
      ),
    );
  }
}
