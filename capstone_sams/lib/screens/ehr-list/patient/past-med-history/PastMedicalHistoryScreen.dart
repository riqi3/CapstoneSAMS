import 'package:capstone_sams/constants/Strings.dart';
import 'package:capstone_sams/constants/theme/sizing.dart';
import 'package:capstone_sams/models/MedicalRecordModel.dart';
import 'package:capstone_sams/models/PatientModel.dart';
import 'package:capstone_sams/providers/MedicalRecordProvider.dart';
import 'package:capstone_sams/screens/ehr-list/patient/past-med-history/widgets/PastIllnessInfoCard.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PastMedHistory extends StatefulWidget {
  final Patient patient;
  const PastMedHistory({
    super.key,
    required this.patient,
  });

  @override
  State<PastMedHistory> createState() => _PastMedHistoryState();
}

class _PastMedHistoryState extends State<PastMedHistory> {
  // late Future<List<MedicalRecord>> medicalRecords;

  @override
  void initState() {
    super.initState();
    // medicalRecords = context
    //     .read<MedicalRecordProvider>()
    //     .fetchMedicalRecords(token,widget.patient.patientId.toString());
  }

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
            PastIllnesInfoCard(patient: widget.patient),
          ],
        ),
      ),
    );
  }
}
