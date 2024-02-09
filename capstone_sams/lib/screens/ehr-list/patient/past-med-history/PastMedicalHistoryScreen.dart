import 'package:capstone_sams/global-widgets/scaffolds/ScaffoldTemplate.dart';
import 'package:capstone_sams/models/PatientModel.dart';
import 'package:capstone_sams/screens/ehr-list/patient/past-med-history/widgets/PastIllnessInfoCard.dart';
import 'package:flutter/material.dart';

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
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldTemplate(
      column: Column(
        children: [
          PastIllnesInfoCard(patient: widget.patient),
        ],
      ),
    );
  }
}
