import 'package:capstone_sams/providers/PatientProvider.dart';
import 'package:capstone_sams/screens/ehr-list/patient/health-record/widgets/PatientInfoCard.dart';
import 'package:flutter/material.dart';

import '../../../../models/PatientModel.dart';
import '../../../../theme/Sizing.dart';

class HealthRecordsScreen extends StatefulWidget {
  final Patient patient;
  const HealthRecordsScreen({super.key, required this.patient});

  @override
  State<HealthRecordsScreen> createState() => _HealthRecordsScreenState();
}

class _HealthRecordsScreenState extends State<HealthRecordsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: EdgeInsets.only(
          left: Sizing.sectionSymmPadding,
          right: Sizing.sectionSymmPadding,
          top: Sizing.sectionSymmPadding,
          bottom: Sizing.sectionSymmPadding * 4,
        ),
        scrollDirection: Axis.vertical,
        physics: BouncingScrollPhysics(),
        child: Column(
          children: [
            PatientInfoCard(
              patient: widget.patient,
            ),
          ],
        ),
      ),
    );
  }
}
